"""A script to generate test files for math functions with complex
and float inputs.

See build_tools/math/README.md for more information.
"""

import os
import re
import sys
import warnings
import mpmath
import numpy as np

to_float_dtype = {
    np.complex64: np.float32,
    np.complex128: np.float64,
    np.float32: np.float32,
    np.float64: np.float64,
}
to_complex_dtype = {
    np.float32: np.complex64,
    np.float64: np.complex128,
    np.complex128: np.complex128,
    np.complex64: np.complex64,
}

default_size = 13
default_extra_prec_multiplier = 1
default_max_ulp_difference = 1

operations = [
    dict(
        name="asin",
        mpmath_name="arcsin",
        size=13,
        # TODO(pearu): reduce to 1 after a fix to mpmath/mpmath#787 becomes available
        extra_prec_multiplier=20,
        max_ulp_difference=3,
    )
]


def main():
    try:
        import functional_algorithms as fa
    except ImportError as msg:
        print(f"Skipping: {msg}")
        return

    fa_version = tuple(map(int, fa.__version__.split(".", 4)[:3]))
    if fa_version < (0, 4, 0):
        warnings.warn("functional_algorithm version 0.4.0 or newer is required,"
                      f" got {fa.__version__}")
        return

    target_dir = os.path.relpath(
        os.path.normpath(
            os.path.join(os.path.dirname(__file__), "..", "..", "stablehlo",
                         "tests", "math")), os.getcwd())

    for op in operations:
        opname = op["name"]
        mpmath_opname = op.get("mpmath_name", opname)
        size_re = size_im = op.get("size", default_size)
        extra_prec_multiplier = op.get("extra_prec_multiplier",
                                       default_extra_prec_multiplier)
        max_ulp_difference = op.get("max_ulp_difference",
                                    default_max_ulp_difference)

        nmp = fa.utils.numpy_with_mpmath(
            extra_prec_multiplier=extra_prec_multiplier)
        for dtype in [np.complex64, np.complex128, np.float32, np.float64]:
            fi = np.finfo(dtype)

            float_dtype = to_float_dtype[dtype]
            finfo = np.finfo(float_dtype)

            if dtype in [np.complex64, np.complex128]:
                samples = fa.utils.complex_samples(size=(size_re, size_im),
                                                   dtype=dtype).flatten()
                expected = getattr(nmp, mpmath_opname)(samples)
            else:
                samples = fa.utils.real_samples(size=size_re * size_im,
                                                dtype=dtype).flatten()
                expected = getattr(nmp, mpmath_opname)(samples)
                if opname == "asin" and expected.dtype != samples.dtype:
                    # mpmath.asin(x) returns complex value when abs(x) > 1, here
                    # we map this to nan:
                    expected = expected.real
                    expected[np.where(abs(samples) > 1)] = np.nan
                    expected = np.ascontiguousarray(expected)
                assert expected.dtype == samples.dtype, (expected.dtype,
                                                         samples.dtype)

            module_name = f"{opname}_{dtype.__name__}"
            m = SSA.make_module(module_name)

            samples_func = m.make_function("samples", "", mlir_type(samples))
            samples_func.assign(samples)
            samples_func.return_last()

            expected_func = m.make_function("expected", "", mlir_type(expected))
            expected_func.assign(expected)
            expected_func.return_last()

            main_func = m.make_function("main", "", "", "public")

            ref_samples = main_func.call("samples")
            actual = main_func.composite(f"chlo.{opname}", ref_samples)
            expected = main_func.call("expected")

            main_func.void_call(
                "check.expect_close",
                actual,
                expected,
                f"max_ulp_difference = {max_ulp_difference}",
                atypes=", ".join(map(main_func.get_ref_type,
                                     [actual, expected])),
            )
            main_func.void_call("func.return")
            source = str(m).rstrip() + "\n"
            fname = os.path.join(target_dir, f"{module_name}.mlir")
            if os.path.isfile(fname):
                f = open(fname, "r")
                content = f.read()
                f.close()
                if content.endswith(source):
                    print(f"{fname} is up-to-date.")
                    continue

            f = open(fname, "w")
            f.write(
                "// RUN: stablehlo-opt --chlo-legalize-to-stablehlo %s | stablehlo-translate --interpret\n"
            )
            f.write(
                "// This file is generated, see build_tools/math/README.md for more information.\n"
            )
            f.write(source)
            f.close()
            print(f"Created {fname}")


class Block:
    """A data structure used in SSA"""

    def __init__(self, parent, prefix, suffix, start_counter=0):
        self.parent = parent
        self.prefix = prefix
        self.suffix = suffix
        self.counter = start_counter
        self.statements = {}

    def tostr(self, tab=""):
        lines = []
        lines.append(tab + self.prefix)
        for i in sorted(self.statements):
            op, expr, typ = self.statements[i]
            if typ:
                lines.append(f"{tab}  {op} {expr} : {typ}")
            else:
                assert not expr, (op, expr, typ)
                lines.append(f"{tab}  {op}")
        lines.append(tab + self.suffix)
        return "\n".join(lines)

    def assign(self, expr, typ=None):
        if isinstance(expr, np.ndarray):
            assert typ is None, typ
            typ = mlir_type(expr)
            expr = shlo_constant(expr)
        elif isinstance(expr, str) and typ is not None:
            pass
        elif isinstance(expr, bool) and typ is not None:
            expr = shlo_constant(expr)
        else:
            raise NotImplementedError((expr, typ))
        target = f"%{self.counter}"
        self.statements[self.counter] = (f"{target} =", expr, typ)
        self.counter += 1
        return target

    def call(self, name, *args):
        # call function created with make_function
        sargs = ", ".join(args)
        return self.assign(f"call @{name}({sargs})",
                           typ=self.get_function_type(name))

    def composite(self, name, *args, **options):
        sargs = ", ".join(args)
        atypes = tuple(map(self.get_ref_type, args))
        rtype = options.get("rtype")
        if rtype is None:
            # assuming the first op argument defines the op type
            rtype = atypes[0]
        sargs = ", ".join(args)
        typ = f'({", ".join(atypes)}) -> {rtype}'
        return self.assign(f'"{name}"({sargs})', typ=typ)

    def void_call(self, name, *args, **options):
        # call function that has void return
        if args:
            sargs = ", ".join(args)
            atypes = options.get("atypes")
            if atypes is None:
                atypes = ", ".join(map(self.get_ref_type, args))
            self.statements[self.counter] = (name, f"{sargs}", f"{atypes}")
        else:
            self.statements[self.counter] = (name, "", "")
        self.counter += 1

    def apply(self, op, *args, **options):
        sargs = ", ".join(args)
        atypes = tuple(map(self.get_ref_type, args))
        rtype = options.get("rtype")
        if rtype is None:
            # assuming the first op argument defines the op type
            rtype = atypes[0]
        typ = f'({", ".join(atypes)}) -> {rtype}'
        return self.assign(f"{op} {sargs}", typ=typ)

    def return_last(self):
        ref = f"%{self.counter - 1}"
        self.statements[self.counter] = ("return", ref, self.get_ref_type(ref))
        self.counter += 1

    @property
    def is_function(self):
        return self.prefix.startwith("func.func")

    @property
    def function_name(self):
        if self.prefix.startswith("func.func"):
            i = self.prefix.find("@")
            j = self.prefix.find("(", i)
            assert -1 not in {i, j}, self.prefix
            return self.prefix[i + 1:j]

    @property
    def function_type(self):
        if self.prefix.startswith("func.func"):
            i = self.prefix.find("(", self.prefix.find("@"))
            j = self.prefix.find("{", i)
            assert -1 not in {i, j}, self.prefix
            return self.prefix[i:j].strip()

    def get_function_type(self, name):
        for block in self.parent.blocks:
            if block.function_name == name:
                return block.function_type

    def get_ref_type(self, ref):
        assert ref.startswith("%"), ref
        counter = int(ref[1:])
        typ = self.statements[counter][-1]
        return typ.rsplit("->", 1)[-1].strip()


class SSA:
    """A light-weight SSA form factory."""

    def __init__(self, prefix, suffix):
        self.prefix = prefix
        self.suffix = suffix
        self.blocks = []

    @classmethod
    def make_module(cls, name):
        return SSA(f"module @{name} {{", "}")

    def make_function(self, name, args, rtype, attrs="private"):
        if rtype:
            b = Block(self, f"func.func {attrs} @{name}({args}) -> {rtype} {{",
                      "}")
        else:
            b = Block(self, f"func.func {attrs} @{name}({args}) {{", "}")
        self.blocks.append(b)
        return b

    def tostr(self, tab=""):
        lines = []
        lines.append(tab + self.prefix)
        for b in self.blocks:
            lines.extend(b.tostr(tab=tab + "  ").split("\n"))
        lines.append(tab + self.suffix)
        return "\n".join(lines)

    def __str__(self):
        return self.tostr()


def mlir_type(obj):
    if isinstance(obj, np.ndarray):
        s = "x".join(map(str, obj.shape))
        t = {
            np.bool_: "i1",
            np.float16: "f16",
            np.float32: "f32",
            np.float64: "f64",
            np.complex64: "complex<f32>",
            np.complex128: "complex<f64>",
        }[obj.dtype.type]
        return f"tensor<{s}x{t}>"
    else:
        raise NotImplementedError(type(obj))


def shlo_constant(obj):
    if isinstance(obj, bool):
        v = str(obj).lower()
        return f"stablehlo.constant dense<{v}>"
    if isinstance(obj, np.ndarray):
        if obj.dtype == np.bool_:
            h = "".join(map(lambda n: "%01x" % n, obj.view(np.uint8))).upper()
        else:
            h = "".join(map(lambda n: "%02x" % n, obj.view(np.uint8))).upper()
        return f'stablehlo.constant dense<"0x{h}">'
    else:
        raise NotImplementedError(type(obj))


if __name__ == "__main__":
    main()