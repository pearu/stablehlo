// RUN: stablehlo-opt --chlo-legalize-to-stablehlo %s | stablehlo-translate --interpret
module @asin_float32 {
  func.func private @samples() -> tensor<169xf32> {
    %0 = stablehlo.constant dense<"0x000080FFFFFF7FFFFEFF7FFFA29D5FFC71FED0FA025443F9558EB6F7749E2AF665769FF4160915F3534A8BF1B02E02F0065773EEA86DE3ECA58E54EB90A8C6E924AB39E82987ADE6682E22E5979397E34AAA0DE2E66684E0237DF7DE524E67DD662ED8DBA80B4ADA88D5BCD8907C30D749F2A4D52E291AD49E1490D2CCA806D15CB57BCFE93FEBCDF9DD5BCC887DCDCABE0D40C9E17EB3C73BC227C60DCA9CC47E8912C38DF488C1000000C0B7426FBEA29DDFBC71FE50BB0254C3B9558E36B8749EAAB665761FB5160995B3534A0BB2B02E82B00657F3AEA86D63ADA58ED4AB90A846AA24ABB9A829872DA7682EA2A5979317A44AAA8DA2E66604A1237D779F524EE79D662E589CA80BCA9A88D53C99907CB09749F224962E299A949E141093CCA886915CB5FB8FE93F6B8EF9DDDB8C887D4D8BBE0DC089E17E33883BC2A7860DCA1C857E8992838DF408820000808000000000000080008DF408027E8992030DCA1C053BC2A706E17E3308BE0DC009887D4D0BF9DDDB0CE93F6B0E5CB5FB0FCCA886119E1410132E299A1449F22416907CB01788D53C19A80BCA1A662E581C524EE71D237D771FE66604214AAA8D2297931724682EA22529872D2724ABB92890A8462AA58ED42BA86D632D0657F32EB02E8230534A0B321609953365761F35749EAA36558E36380254C33971FE503BA29DDF3CB7426F3E000000408DF488417E8912430DCA9C443BC22746E17EB347BE0D4049887DCD4AF9DD5B4CE93FEB4D5CB57B4FCCA806519E1490522E291A5449F2A455907C305788D5BC58A80B4A5A662ED85B524E675D237DF75EE66684604AAA0D6297939763682E22652987AD6624AB396890A8C669A58E546BA86DE36C0657736EB02E0270534A8B711609157365769F74749E2A76558EB6770254437971FED07AA29D5F7CFEFF7F7FFFFF7F7F0000807F"> : tensor<169xf32>
    return %0 : tensor<169xf32>
  }
  func.func private @expected() -> tensor<169xf32> {
    %0 = stablehlo.constant dense<"0x0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F307E71BEBFA4DFBC88FE50BB0254C3B9558E36B8749EAAB665761FB5160995B3534A0BB2B02E82B00657F3AEA86D63ADA58ED4AB90A846AA24ABB9A829872DA7682EA2A5979317A44AAA8DA2E66604A1237D779F524EE79D662E589CA80BCA9A88D53C99907CB09749F224962E299A949E141093CCA886915CB5FB8FE93F6B8EF9DDDB8C887D4D8BBE0DC089E17E33883BC2A7860DCA1C857E8992838DF408820000808000000000000080008DF408027E8992030DCA1C053BC2A706E17E3308BE0DC009887D4D0BF9DDDB0CE93F6B0E5CB5FB0FCCA886119E1410132E299A1449F22416907CB01788D53C19A80BCA1A662E581C524EE71D237D771FE66604214AAA8D2297931724682EA22529872D2724ABB92890A8462AA58ED42BA86D632D0657F32EB02E8230534A0B321609953365761F35749EAA36558E36380254C33988FE503BBFA4DF3C307E713E0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F0000C07F"> : tensor<169xf32>
    return %0 : tensor<169xf32>
  }
  func.func public @main() {
    %0 = call @samples() : () -> tensor<169xf32>
    %1 = "chlo.asin"(%0) : (tensor<169xf32>) -> tensor<169xf32>
    %2 = call @expected() : () -> tensor<169xf32>
    check.expect_close %1, %2, max_ulp_difference = 3 : tensor<169xf32>, tensor<169xf32>
    func.return
  }
}
