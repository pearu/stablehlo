// RUN: stablehlo-opt --chlo-legalize-to-stablehlo %s | stablehlo-translate --interpret
// This file is generated, see build_tools/math/README.md for more information.
module @acos_float32 {
  func.func private @samples() -> tensor<169xf32> {
    %0 = stablehlo.constant dense<"0x000080FFFFFF7FFFFEFF7FFF979317FCFC4469FAE17EB3F82C1E0AF7A58E54F5D98EA3F35CB5FBF11BAF41F0160995EEE45BE5EC907C30EB6ECD87E971FED0E7EED020E6237D77E4E66FBEE27E8912E1958361DF2987ADDDA08605DC887D4DDAC71E9ED80657F3D6A03E3BD59E1490D3C7BBDDD1749E2AD0974983CEA80BCACC31781BCBB7426FC90D1BB8C74AAA0DC631045AC43BC2A7C22A1601C190A846BFFCDC98BDE93FEBBBF30435BA534A8BB88F5CD6B649F224B55CD87DB30254C3B1F74C16B0524E67AE18FCB1AC8DF408AB9DC452A9682EA2A7F796F9A5BE0D40A4F0C793A2A86DE3A043002F9FCCA8869D173CCF9B65761F9AD667759888D5BC96BA4D1195A29D5F933C11AC91E6660490BAC24B8E0DCA9C8CA94AF18A24AB398926DE8E87F9DDDB85CB2E2984B02E82824758C880264513807EDA0180A42D0080640400806C0000800A0000800100008000000000010000000A0000006C00000064040000A42D00007EDA0100264513004758C800B02E8202CB2E2904F9DDDB0526DE8E0724AB3909A94AF10A0DCA9C0CBAC24B0EE66604103C11AC11A29D5F13BA4D111588D5BC16D667751865761F1A173CCF1BCCA8861D43002F1FA86DE320F0C79322BE0D4024F796F925682EA2279DC452298DF4082B18FCB12C524E672EF74C16300254C3315CD87D3349F224358F5CD636534A8B38F304353AE93FEB3BFCDC983D90A8463F2A1601413BC2A74231045A444AAA0D460D1BB847B7426F4931781B4BA80BCA4C9749834E749E2A50C7BBDD519E149053A03E3B550657F356C71E9E58887D4D5AA086055C2987AD5D9583615F7E891261E66FBE62237D7764EED0206671FED0676ECD8769907C306BE45BE56C1609956E1BAF41705CB5FB71D98EA373A58E54752C1E0A77E17EB378FC44697A9793177CFEFF7F7FFFFF7F7F0000807F"> : tensor<169xf32>
    return %0 : tensor<169xf32>
  }
  func.func private @expected() -> tensor<169xf32> {
    %0 = stablehlo.constant dense<"0x0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F11621D40F19FD23F1BFBC93F7B26C93F0812C93F1010C93FE00FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDB0FC93FDA0FC93FD50FC93FA50FC93FAD0DC93F3AF9C83F9A24C83FC47FBF3F27B72E3F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F"> : tensor<169xf32>
    return %0 : tensor<169xf32>
  }
  func.func public @main() {
    %0 = call @samples() : () -> tensor<169xf32>
    %1 = "chlo.acos"(%0) : (tensor<169xf32>) -> tensor<169xf32>
    %2 = call @expected() : () -> tensor<169xf32>
    check.expect_close %1, %2, max_ulp_difference = 3 : tensor<169xf32>, tensor<169xf32>
    func.return
  }
}
