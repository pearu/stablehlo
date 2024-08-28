// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x6x7xf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[[[0], [1]], [[2], [3]]]> : tensor<2x2x1xi64>
    %0:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<5x2x2x7xf16>)
    %1 = call @expected() : () -> tensor<5x6x7xf16>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 3], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 2>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %3 = stablehlo.multiply %arg0, %arg1 : tensor<f16>
      stablehlo.return %3 : tensor<f16>
    }) : (tensor<5x6x7xf16>, tensor<2x2x1xi64>, tensor<5x2x2x7xf16>) -> tensor<5x6x7xf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> ()
    return %2 : tensor<5x6x7xf16>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16> {mhlo.layout_mode = "default"}, tensor<5x2x2x7xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x92391FB8604730C369C5E93C72C0E1BDC540754380C41EC099BCC2C2BFC5D53762B9F6440842663F9B4711B90A432EC05F4153C21DC0913B4CC11141B043334142BEB7C267C1133B35B96AC158B209B624B882BCA3B915BDFB3DE3404E43BCC00D442FBC0CBEC73CDD3E8146CDBA30B98A3C224465BF0EC03A3C80B8CE4064440D410844084338C636BD14440A445F41E83C0AC4E3370B3BAD447D3AB8B06339ECC5CC4453C63CC125C52CC4C043D93D9FC4F841EC3F33C12A3AE033F743ABBD8C374FC260C446C3F13B10A820C020C3A5C256417542B8C4EE422CC36A3903C0063815C0382CEA408E2CC8420C4568354CBDB0C0113AACC0184569C2D5C14C3F8BBCD44390BDB341B9C59241B8351FBC31B89EC3F3C2A23C873DF13797416C45EB3CB63F8644B43F14BF1DB0AB309436F83D913A2DC13FBE31B70C405B366838C938D6C4A535FA38FDC7E2C0FDC37EC5AB3CF9329640CD4012B02442FE393C424F34D9C28E3F072DBA35FD3F62BDA4AB79B9173E26B45343B0977AC15DC1C92C1B43FA458CB5FFC350BC71410CC4F4C16FC0AAC115BE2AC21FBE33BF13C2193045414ABC"> : tensor<5x6x7xf16>
    %cst_0 = stablehlo.constant dense<"0xD13EBE45CFB83BC69544E3B8C8C2F641DD3D28385DC1C34018BB983731C0944453C4BFC0D1405138DFB4A534893851200440883975C288458644E23ECA3E80BF18BD7140E240D93B513A8CBF98C338457A42114227454F4051BC1245493EE543CF3A1B34013D0742493F17C07E48D2C1A4BDC82E093F26C12C3AE8445FB409463DC47AC019C66D3997BAA7442BBF34C341C286C42A4412C4D23BDA4515448AC16CC7D8438141CBC40FC4AFC030B51C3E573F9CC5D7BE51C61E387BC034C012C66F285FC383C3623F233BD33E6139B0C2D545B0C657B47C4270C597C124C799408FC46EB6503F7B41654208B81FBC4EBEE942BE4250C465BC4739F0C475C5E2C1E841B6B3B33D3B4179B991434AC66139F93FACB80B46ADC4"> : tensor<5x2x2x7xf16>
    return %cst, %cst_0 : tensor<5x6x7xf16>, tensor<5x2x2x7xf16>
  }
  func.func private @expected() -> (tensor<5x6x7xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xBF3CEBC16FC4994D33CE00BA894761C4FE42C03F094AE7C4143C6ABE054A7B40D241E3C94347FC3BA2C0E2B1FB3F83A464455FC0A4463B454CC11141B043334142BEB7C267C1133B35B96AC158B209B624B882BC60C25FC0134195C4A7C442C5F2481BBCC6BC82C084C63E5081C1DEBFD9457448FB3F24C9A43E71C01740823C5242134A67465C4ADAC9EFC90A445F41E83C0AC4E3370B3BAD447D3AB8B06339ECC5CC4453C63CC1414713B7D14687C321C3524B54B8D8CB88C268B812CEB0BB37B656CBD7478D4A35C298304BC8404B7FC2CE4B974A894A6ECE08CB733FCF48063815C0382CEA408E2CC8420C4568354CBDB0C0113AACC0184569C2EB4946C4E435FA451AC1FECBE54866CCE3319E40673CC84DB4AF45C431C5543BFD40A0489D3A72C6984E70CAAE37ABB658BA99BC54C98C3F2DC13FBE31B70C405B366838C938D6C4A535FA38FDC7E2C0FDC37EC552C59BAD3144944682B630BE2CBAEAC4713BC5C913C886AD8E33EEC858479E310AC0DFB5E9B5CA4842152EC9374C6F2A1547FBC231C0AC4C50BC71410CC4F4C16FC0AAC115BE2AC21FBE33BF13C2193045414ABC"> : tensor<5x6x7xf16>
    return %cst : tensor<5x6x7xf16>
  }
}