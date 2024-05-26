// RUN: stablehlo-opt --chlo-legalize-to-stablehlo %s | stablehlo-translate --interpret
module @asin_complex64 {
  func.func private @samples() -> tensor<169xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0x000080FF000080FFFFFF7FFF000080FFFEFF7FFF000080FF000000C0000080FFF30435A0000080FF00008080000080FF00000000000080FF00008000000080FFF3043520000080FF00000040000080FFFEFF7F7F000080FFFFFF7F7F000080FF0000807F000080FF000080FFFFFF7FFFFFFF7FFFFFFF7FFFFEFF7FFFFFFF7FFF000000C0FFFF7FFFF30435A0FFFF7FFF00008080FFFF7FFF00000000FFFF7FFF00008000FFFF7FFFF3043520FFFF7FFF00000040FFFF7FFFFEFF7F7FFFFF7FFFFFFF7F7FFFFF7FFF0000807FFFFF7FFF000080FFFEFF7FFFFFFF7FFFFEFF7FFFFEFF7FFFFEFF7FFF000000C0FEFF7FFFF30435A0FEFF7FFF00008080FEFF7FFF00000000FEFF7FFF00008000FEFF7FFFF3043520FEFF7FFF00000040FEFF7FFFFEFF7F7FFEFF7FFFFFFF7F7FFEFF7FFF0000807FFEFF7FFF000080FF000000C0FFFF7FFF000000C0FEFF7FFF000000C0000000C0000000C0F30435A0000000C000008080000000C000000000000000C000008000000000C0F3043520000000C000000040000000C0FEFF7F7F000000C0FFFF7F7F000000C00000807F000000C0000080FFF30435A0FFFF7FFFF30435A0FEFF7FFFF30435A0000000C0F30435A0F30435A0F30435A000008080F30435A000000000F30435A000008000F30435A0F3043520F30435A000000040F30435A0FEFF7F7FF30435A0FFFF7F7FF30435A00000807FF30435A0000080FF00008080FFFF7FFF00008080FEFF7FFF00008080000000C000008080F30435A000008080000080800000808000000000000080800000800000008080F3043520000080800000004000008080FEFF7F7F00008080FFFF7F7F000080800000807F00008080000080FF00000000FFFF7FFF00000000FEFF7FFF00000000000000C000000000F30435A000000000000080800000000000000000000000000000800000000000F3043520000000000000004000000000FEFF7F7F00000000FFFF7F7F000000000000807F00000000000080FF00008000FFFF7FFF00008000FEFF7FFF00008000000000C000008000F30435A000008000000080800000800000000000000080000000800000008000F3043520000080000000004000008000FEFF7F7F00008000FFFF7F7F000080000000807F00008000000080FFF3043520FFFF7FFFF3043520FEFF7FFFF3043520000000C0F3043520F30435A0F304352000008080F304352000000000F304352000008000F3043520F3043520F304352000000040F3043520FEFF7F7FF3043520FFFF7F7FF30435200000807FF3043520000080FF00000040FFFF7FFF00000040FEFF7FFF00000040000000C000000040F30435A000000040000080800000004000000000000000400000800000000040F3043520000000400000004000000040FEFF7F7F00000040FFFF7F7F000000400000807F00000040000080FFFEFF7F7FFFFF7FFFFEFF7F7FFEFF7FFFFEFF7F7F000000C0FEFF7F7FF30435A0FEFF7F7F00008080FEFF7F7F00000000FEFF7F7F00008000FEFF7F7FF3043520FEFF7F7F00000040FEFF7F7FFEFF7F7FFEFF7F7FFFFF7F7FFEFF7F7F0000807FFEFF7F7F000080FFFFFF7F7FFFFF7FFFFFFF7F7FFEFF7FFFFFFF7F7F000000C0FFFF7F7FF30435A0FFFF7F7F00008080FFFF7F7F00000000FFFF7F7F00008000FFFF7F7FF3043520FFFF7F7F00000040FFFF7F7FFEFF7F7FFFFF7F7FFFFF7F7FFFFF7F7F0000807FFFFF7F7F000080FF0000807FFFFF7FFF0000807FFEFF7FFF0000807F000000C00000807FF30435A00000807F000080800000807F000000000000807F000080000000807FF30435200000807F000000400000807FFEFF7F7F0000807FFFFF7F7F0000807F0000807F0000807F"> : tensor<169xcomplex<f32>>
    return %0 : tensor<169xcomplex<f32>>
  }
  func.func private @expected() -> tensor<169xcomplex<f32>> {
    %0 = stablehlo.constant dense<"0xDB0F49BF000080FF00000000000080FF00000000000080FF00000000000080FF00000000000080FF00000000000080FF00000000000080FF00000000000080FF00000000000080FF00000000000080FF00000000000080FF00000000000080FFDB0F493F000080FFDB0FC9BF000080FFDB0F49BF6E86B3C2DA0F49BF6E86B3C200004080FCD4B2C200000000FCD4B2C200000000FCD4B2C200000000FCD4B2C200000000FCD4B2C200000000FCD4B2C200004000FCD4B2C2DA0F493F6E86B3C2DB0F493F6E86B3C2DB0FC93F000080FFDB0FC9BF000080FFDB0F49BF6E86B3C2DB0F49BF6E86B3C200004080FCD4B2C200000000FCD4B2C200000000FCD4B2C200000000FCD4B2C200000000FCD4B2C200000000FCD4B2C200004000FCD4B2C2DB0F493F6E86B3C2DB0F493F6E86B3C2DB0FC93F000080FFDB0FC9BF000080FFDB0FC9BFFCD4B2C2DB0FC9BFFCD4B2C2791641BF59FEDDBF9BE8A19F0CC9B8BF000000000CC9B8BF000000000CC9B8BF000000000CC9B8BF9BE8A11F0CC9B8BF7916413F59FEDDBFDB0FC93FFCD4B2C2DB0FC93FFCD4B2C2DB0FC93F000080FFDB0FC9BF000080FFDB0FC9BFFCD4B2C2DB0FC9BFFCD4B2C2DB0FC9BF1492A8BFF30435A0F30435A000008080F30435A000000000F30435A000008000F30435A0F3043520F30435A0DB0FC93F1492A8BFDB0FC93FFCD4B2C2DB0FC93FFCD4B2C2DB0FC93F000080FFDB0FC9BF000080FFDB0FC9BFFCD4B2C2DB0FC9BFFCD4B2C2DB0FC9BF1492A8BFF30435A000008080000080800000808000000000000080800000800000008080F304352000008080DB0FC93F1492A8BFDB0FC93FFCD4B2C2DB0FC93FFCD4B2C2DB0FC93F000080FFDB0FC9BF0000807FDB0FC9BFFCD4B242DB0FC9BFFCD4B242DB0FC9BF1492A83FF30435A000000000000080800000000000000000000000000000800000000000F304352000000000DB0FC93F1492A83FDB0FC93FFCD4B242DB0FC93FFCD4B242DB0FC93F0000807FDB0FC9BF0000807FDB0FC9BFFCD4B242DB0FC9BFFCD4B242DB0FC9BF1492A83FF30435A000008000000080800000800000000000000080000000800000008000F304352000008000DB0FC93F1492A83FDB0FC93FFCD4B242DB0FC93FFCD4B242DB0FC93F0000807FDB0FC9BF0000807FDB0FC9BFFCD4B242DB0FC9BFFCD4B242DB0FC9BF1492A83FF30435A0F304352000008080F304352000000000F304352000008000F3043520F3043520F3043520DB0FC93F1492A83FDB0FC93FFCD4B242DB0FC93FFCD4B242DB0FC93F0000807FDB0FC9BF0000807FDB0FC9BFFCD4B242DB0FC9BFFCD4B242791641BF59FEDD3F9BE8A19F0CC9B83F000000000CC9B83F000000000CC9B83F000000000CC9B83F9BE8A11F0CC9B83F7916413F59FEDD3FDB0FC93FFCD4B242DB0FC93FFCD4B242DB0FC93F0000807FDB0FC9BF0000807FDB0F49BF6E86B342DB0F49BF6E86B34200004080FCD4B24200000000FCD4B24200000000FCD4B24200000000FCD4B24200000000FCD4B24200000000FCD4B24200004000FCD4B242DB0F493F6E86B342DB0F493F6E86B342DB0FC93F0000807FDB0FC9BF0000807FDB0F49BF6E86B342DA0F49BF6E86B34200004080FCD4B24200000000FCD4B24200000000FCD4B24200000000FCD4B24200000000FCD4B24200000000FCD4B24200004000FCD4B242DA0F493F6E86B342DB0F493F6E86B342DB0FC93F0000807FDB0F49BF0000807F000000000000807F000000000000807F000000000000807F000000000000807F000000000000807F000000000000807F000000000000807F000000000000807F000000000000807F000000000000807F000000000000807FDB0F493F0000807F"> : tensor<169xcomplex<f32>>
    return %0 : tensor<169xcomplex<f32>>
  }
  func.func public @main() {
    %0 = call @samples() : () -> tensor<169xcomplex<f32>>
    %1 = "chlo.asin"(%0) : (tensor<169xcomplex<f32>>) -> tensor<169xcomplex<f32>>
    %2 = call @expected() : () -> tensor<169xcomplex<f32>>
    check.expect_is_close_to_reference %1, %2, %0, max_ulp_difference = 3 : tensor<169xcomplex<f32>>, tensor<169xcomplex<f32>>, tensor<169xcomplex<f32>>
    func.return
  }
}
