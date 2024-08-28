// RUN: stablehlo-opt --chlo-pre-serialization-pipeline -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s | stablehlo-translate --serialize --target=current | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf64>
    %1 = call @expected() : () -> tensor<20x20xf64>
    %2 = chlo.bessel_i1e %0 : tensor<20x20xf64> -> tensor<20x20xf64>
    stablehlo.custom_call @check.expect_almost_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xf64>, tensor<20x20xf64>) -> ()
    return %2 : tensor<20x20xf64>
  }
  func.func private @inputs() -> (tensor<20x20xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xE8A90A48D18DECBF1209033AD3A9EEBFA272317626CE12402F0C69CA9524AC3F9EAD96B64451EB3F7ED3FCCE7B4003401CF704D3D328833F82AF5ABD2EDFF1BF38C6C7B2731D1040E171A857E1240740D0E694E28295FCBFF103EF4F6AA0FBBF7EA9C21816350DC0C53E1D283194F43FD68B02FC0B770B403AB64A93830BC4BF1F1A6FFEF2BFEBBF5E814BA77D60D33F480548D973C8F63F5FBFC733FEC50B407C2D0D49578818C0C12BDD01DFA115C0DC605FC56FF8F23F0BD0CCEE53D1054011A56ECC3CED12404434A5B304D412C09E37837E601301C06C8B3FA74E57F93FEBE1E70F6E7506C0E93E07C314C7F53F9E02A0D2282505406801F0833E050C40EDA842BC5B80134046DF7853FBD2EC3F0477A065EDF210C0D68A5C4C36F70BC008FB1771A96EC23FBA08F51B1003F03FB8A4DD7E5E61FB3F41CD3C2631A1DFBF1D96695F4A50F33F0B4E8379164FE53FBBA961E835B71440371C40FAF64D054036F8F25D7A720F4014561B2BA61EFA3F4EB3A6EB78030C403AD86752E497FDBF65E4DF36A0E1C73F609ECD4B577206C06E80C3CE2E640FC094A4E0D9AB7EF83F2D0C99AE1502154051A485C8E07902C011BD0C8C138DFF3F900D5F02F33C0C40B2E0416C549AF83F8A34571D160BE43F98DCC5B99565FEBFDEB54AFA521F01C01FC134BEE73C12C0A499925534DBE0BF1299E698BA94FF3F9F07819B695CE13F7FAC2FDC0D85F43F8A6E9BF00CEAEABFECF124B8BA35FFBF8D949713FEF1EEBFE04797595087EF3F78AE2C6B8E8CE2BFB5F0E106FC4EE4BFB882D3E44BEAD7BF37EF4B09C91A0040760856222FC813C05DB9D498945E03C0DCD019E4D66B0B40E8A302D99DBB01401FC846068A380E401D59479039E1F63F077C51D369D610406CEF06103DD319C06657D541BC7B0240F6B958DE9B6E10C0E8A5DC0F5F4EF2BFEDCDBF4FD767DABF7C1F8DA931D400C0AA607B0A56F7F83FC32D3F44A280F0BF45E31AB131F61640E705FC2DA30A06C0B27018F90B55A2BF890A713FB3DB0040F253BBFF98D6E4BFE16EDCAB065700C0E85F3DB838DE16C0B297300F62EEEB3F37605050AD4609C0122ADEDC0E1AF2BF621328369617E8BF4AB11B43AD3B12401AA433EE59F9ECBF6F04A21CDFAAD43F0C66A3AC38420B40A0C2F026C4FFE33FE6811D75C358DDBF641AC579C760F2BFE631098D740F09C0CB927D80A35400C05D359A96D6A505C0C4D3AE7993AA1240920C4EFA722C11C0BCD9E29B0C85084098D8444753B500C0A1A2F1782F6A14C0DCA92029E8E9D93F388AC1C51958CC3FD08A1D500BBB09C0CBE59E0A7B4F00C06BD21FC98B0103408F5B79EE481BEF3FB3170468A62FF43F4E1BB0EA58DBE9BF90E55D729564FA3FBA232062CE810A40625975E2DA18CA3FEAC12EDB54BACCBF7AC53AC13EC7F8BFAA77EB43B31F16C08C305A6D87D102C010A6B36D1BF1E03F7B4B9ABF9A1615406F5B9A8DE0B6F1BF503163117667D23F989817E74814024058EAA2E6EC570740ACCBAF097E2CEABF6695E86884CFE93FC41EC5A18BEC0FC061C2977A9BB3E5BF40C0BB871E1818C015E6A1C9D88E19408D35336554D20340D4FFF5E3C9D0F9BFA0FF0D087638D8BF00AEB4736E78F83F97452BC6B39FF23F26A9FDDC35EEF13FFEDD774B8D101040EE4752B84E24FCBF2DCB211266531A4091E6E3FA989118C0422E0849C821174082116B7FA3EEFA3FF93AFE60E13C0040A537C178EBEDF53F444BF1910C57EBBF05146DE43F8FF0BF34D56D94EEA212C055F4C7BCC57616C0282557F666CB0CC038D26816864BF43FE6E9EFB2916DF8BFAE116FDE6F8FFEBF0C6EA6072AF1D1BFE0018A847A339ABFC91E632D7E610340AB74E63F2248124062973E4B691A1A4058A1C7D0593A14C0505F4EF7CFA8154046D03CC26637C53F247639574D27FDBFC206260F92E202C02887FD3EFE21FCBF3C558448C00A224002E0962FE8EACEBF94006470244E094046712CB6975CF8BFFCC581E788880E40027ECC34C8D001C0C0E7FCE1C394E23F9E50CE5EEFC10CC0A873266172B2E13F7862DE865EB2F93F8C3C6905DEDA0140E09064B02A40DB3F30B4846192411240135413CA5832E63F14210C0D559AD03FA2F853EE40430AC0FBAFB5DF0D50F13FF56F2830FB240FC096A1B64E8C1906C0F3A0A4843DCE14C06A9EC7867DA0E6BF107667963063DE3F4CA7A0CD3652EFBF2CA49FB171FBE73FA7DEF73E700A14C0223153A3BAD3F3BF2ADACE5B5BCDEEBFEE302FAFE42A9EBF51AB17627BB1E0BF2B6236D28F7BE6BF77E2038B5C9CF63F6545CF69374D03C0A97662ECF308D9BF91FB02835E0ED23FE8418DC4F52FF8BFC00478AE1C5A12C0FB735CF5282C1440861D652570B3EFBFC938616FF11903C0D023312E46E506C00BAE111346DF04C0C8202DC442A6D0BFAC44D8B04164FB3FCB6C872C1A7406404C1B0B6BBE1B0040B84A8B1557970E402417339DBD52FD3F523F995DF9D9FF3F4415F7021D43EC3FC03DABA8ED730A403EF7876E1E29C13F79AAE657E6C7F53F4066C8D500971BC0247B84B4571612405EF6916A6532F5BFB266562AED0315C0388AD1F3B24EEEBFBCC4B3052FF512C04247FEF0FDE612C01653A97DC74D01C069433ACEA0ED094064FA1C6610E114C09E64479AA5830940CAE97BFEC8FDD5BF49C5F443F32613C0521837456BDDFC3F15C7A69567AD0DC046CB41CD210A03C032B52853B30F00C05FEFC80B2B8616C05E5AEC6A0F140340EE2D53B5CC490BC0E53F98DAABB904C0608664CFC884E13F2A8EDBACF3B504404ACD843B7886DE3FB254B2BBDBF2EE3F8322791E8F62C5BFD2B80E490A33094056F6C9051900084008184895B911E9BF19731691539FC4BFA4A1009BEDF917408ACED2E2DDC2E8BFA4B10E936AD113400D2DCBB5A1AA05C00B8714CDF90203409E1F1D150D5202C0B8D08F09252A0A40B824B811EFC8F43F8F9D1D7114B21DC0F5F30CDFE8CBFE3FFA114829257017C06AC0989FF434FEBF5AE97603F40909C0F5AC68609DCA02403306E338C20710C048B68C20FB3516C036FAD43175A413C0411BC499571110C02144861FAA8B05402C6768B60C8F11C0C3AA29865EF50340B86A9D7416E4D53F0DD1596A9BD601C0ECDF8FA9A7D6A0BF84AB1DEC4D84F9BF0098B25442CABD3F34DDB4B584C90640F0E44A1336410BC0406EA0A9E8080CC06100C34F4BD10040F7A6F47A673112C09D681D69FF6C1940C7D1B6C0E9E2F6BFD65888D65BEAFE3F41CFF97B6750004008B0B26B81C0FC3F2AEB4C4B10740240A646E3149867094012C66047F8830040B710BB509FF5F03F2C0F7A584F151A40207290D2BFF8D3BF481C4E43A4F0F03F98C5FE9107A9124018CA01F9391CE13F3B810EB00B47E4BFA2064638CD10CDBF093AF152362E04C0C8E4474C179E01C04E28E3A80429034077B6A0D00CDEF6BF167013F98F8B0B405E6C40527326DF3F1E5F8D2052FCE8BF4EF55DBEDE090640CCC6732416990AC004B89CF3351CD6BF502B61714CC5F83F4AF7B40C57B10B40594E7BE8EE4CF73F30D6EC01BA8C014018CF704D074B16406B1B52A5534AF2BFC40A60968C4FF13FA68B2AB1E3FDF73FECC17D93267A07C0EF48DA51795DE4BF7067C60C9C75C63FDC7D4AD561ADFBBFD2A360CBCE45F3BF183A95F04821F83F3C7F8E02B130DE3F38421D9C7140F7BFEF4114AA56A019409E6EF654CD8BF6BF7D0608AEFB7710C0AF256801805E16C0416594D353C216C03A1EF09EEAAB24C01A5C1626641CD9BF06695DA420BDFA3FD33F792C57BBEF3FB59D40A42CEFF73F1731B875FE160440235267BACB96EEBFDF95EFD74C60FCBFC60A1055D36313C01BBD49CE653014C0E907EC6A5B21104080E2739FF1A4D1BF6315702C8DFFEBBF1C8C411B7ACBFCBFB84930EDD6E4FABFCB94A96FA74F1340402BF9034DA7F5BFAF98F89A5EFE0EC075C072A9F8D700C06908F6D3DF12D03FF53B83AB414C10406A62F0E10BF66FBF05DB107D1BEEE1BF2299E036834410C02E9793DE2107F83F9957C68E957813C0A7B1603D7FFA01C08EADB0BC516916C07FA533E1629F04400C2389C742D31B4074D465EDEC22FE3F17FC3A2C8073E53F8EA2C8B96C93D7BFD574A23D393CF8BF54483223E8D9F4BF5DD7B06131000540213341FAC6C11A40EAA8C20065261040E867061199A30F40D1CB1CE47519F63F2BB90D74119200401068761FD79113C0D8FB7D5DDCE30EC0C390FB38159EFBBF4B88E39408830340ECBC9B2AED7AFFBFBE845837116411406741A3782571E03F15503F7C45ACAD3FB6F1D67DBAFC1BC0CDE9104233F208C060CAD31C7DEC13C0D3ECF3937E2AC4BF20D3A6BFD636F3BF142C27CF6594FB3F5C50A90F7513014008E86A9C46A9EC3F24C5F3CC1239EF3FB19B153F4B9309400AA8235A2B3A10C0D6DB7AEE029EF9BF8D9372AA30DD04C0906BADCB9CDDD43FEAE5DA831AF2FD3FFA0C8A3C5AF9F7BF7C46B083B2C9F3BF"> : tensor<20x20xf64>
    return %cst : tensor<20x20xf64>
  }
  func.func private @expected() -> (tensor<20x20xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xE869A1F407CEC9BFECCFD8780E54CABF8A975239C882C53F5D70D80DD6A59A3F268A71697373C93F5C553C4F86ABCA3F649FEE7635FB723F42D1109A113DCBBF0030D812DDD1C63F2E0DE8790476C93F5D00F170B5E2CBBF30ADCA3E5DF3CBBF44C78D5D3CA4C7BFF5CA4540E9C8CB3FD96A35B9B424C83FFCF2A07E2331B1BFFC74651D3194C9BF1FBB2E8AA8F5BC3F558D5E2915FECB3F752543D3990DC83FA94E0B553248C3BF7CACCAB1B553C4BFEF3F6E305F81CB3F00FB137B90E0C93FB9B6CE8FC974C53F3EA74E202280C5BF8352D879CA49CBBF16FBC604030ACC3F2DFB97670BADC9BF7EE077AE87EBCB3F47F1AA637D16CA3F9E88185F33FBC73FE4CF1E2FCD33C53F23AD10B198E0C93F5B313569B664C6BF7F3DA62846FFC7BF09C543376C00B03FAC65C5E1079ECA3F7B239E0907F7CB3F5C5D3E7A0DE4C3BFF676B6284E93CB3FFC908E6D4122C73F266FFBD3FAB0C43FBD1B4050BB09CA3FD11CC619CC06C73FB55F4FE05105CC3FE97FD6F9B6FBC73FA6EEF8D165CDCBBF2A0D89182EE7B33F421475AC03AEC9BFE91832449D0AC7BF018736F3090BCC3F8B72C192B992C43F7495515038E6CABFD4EAA29FF19ACB3FBBCF9E3C14EBC73FB21E60FD280BCC3FC307C171F57EC63F7766E41005BACBBFD139A50CA546CBBFC24D094F6AC5C5BF7871C845379BC4BF41C095D9179ACB3F15EE7D264DEFC43F44E98F1BD1C6CB3F081525A4D853C9BF204546077FA4CBBFDDB3430F2664CABF1CC772B72984CA3FFF614740CCA9C5BFF54194BE71A2C6BFD4E0251456BFC0BF7F8C5DA6B987CB3F450BD25DCE14C5BFEBC6BADD78A2CABF54F6B794FF27C83F9A009E194C1CCB3FE6C21646E65BC73FEC15825369FFCB3FB8A45A900273C63F7215A503E5DCC2BF84474B3CAEE5CA3F3A97E1A6CAA7C6BF5D6BF969235ACBBF9983F33477DAC1BF7177CD0A315ACBBFFBDA395E040BCC3F97E9A2A6D3CDCABF7449E6D42AD4C33FC366E88493CEC9BFD82965C6B5B091BF3DC1B8C64358CB3F1ECFE4254BE7C6BFF8761BE76379CBBF4A300411DEDCC3BFA03C10B494A1C93FD1B206ACD1CCC8BF513F3A69CF4CCBBFD217AD157757C8BFFB6EB6DAFCC5C53FF67EE560B6EAC9BF6E39BABFC051BE3F91BAE7484034C83FB58855BFF978C63F24A75130880BC3BF2879C70DAF5ECBBF0EA1263BBCDDC8BF39D7699BF779CBBF51F251BB34EEC9BF538CCE4BE992C53FB1FD40A92148C6BF5398921B5D08C93F8289303D0D62CBBFF653E6159AD0C4BF55C2884D67A4C13F9AC72BF67FDAB63F83BF04F45BA9C8BF925F841A367BCBBFB87BA1E054BECA3F39E4554D2C6DCA3F18DA530A46BACB3F0176BB7DDBFBC8BFCA6F8663E402CC3F13B7EA126E6DC83FC8906520FB64B53FA08DF249F018B7BFCA23FF1A320BCCBF68D8D3078623C4BFE44E8BC08ECCCABFEF2D4018AEA9C43F407BD5EC838AC43FA0431418D431CBBF7080293B55E5BB3F9EF384886603CB3F140F81E20A66C93F4C274C950617C9BF255540ABD6F7C83FC77944CD6DE6C6BF2C9FEACFE551C7BF91CEA1CD276EC3BFF92356B986F2C23F3C177960587FCA3FA7A95E228E07CCBFECFD18CB55E3C0BF4147533B000BCC3F837DAA73AA6DCB3F42D7269A2941CB3F259646D29DD8C63F2FBD47B2DCEACBBFFF0C708B17B5C23F368F04251A45C3BFC05E6F5A74C4C33F542D128DFDFCCB3FE6BD9370AB7FCB3F4C790C4FE8EECB3FFD87A5A43075C9BFC068C3581AD3CABF348300A76496C5BFCE8AD518E502C4BFF9549D7E36C2C7BF41EC2D4181BECB3F85C526E9EC0ACCBF942DB5DED6B5CBBF63623BE6E460BBBF1DFDAD03918A89BFAF42491F98A1CA3FD4637C9830C0C53F8F420D8BACC6C23FC32C40B97FE4C4BF8D28C4E40451C43F08FE50FF9A09B23F6EF5A6C11FD7CBBFA3CC278185C7CABFFA3A994E05EBCBBF4FA999A88244C03F70F6E3BCED75B8BFD5E8C05289CAC83FAB697A90C80ACCBF386DCE05F645C73F4577042A6816CBBFCF1DC5CF9DAEC53FF82A1398E9C4C7BFA8EE8834A825C53F019034604A08CC3F42D0C1969613CB3FA02A1C344235C23FC10CCBF73DC3C53F2DED3EAB038CC73F6C77EFA194D5B93FE528ED023380C8BF23FA41BB6313CB3F8FAA56848E1BC7BF8D883011E5C9C9BF58481CA89FA7C4BF89BF1135CCBCC7BF3BB606D45970C33F6D7E9D4EF978CABFE17D6C51744CC83F10711A58A1F8C4BFDF18630759ABCBBF0F70E8DD075CCABF7960ED5C814B8DBF054623206C7FC4BFF57562199EACC7BF94EE8BB386FBCB3F61E55A06B3A7CABF29ED20089341C1BF1EE657E9C681BB3F31DE53C7440ACCBF5A1A9A70D9B7C5BFD7409CB770EAC43F51FBFE944C8DCABFDDA357DA0FB7CABF14D74B00F389C9BF641CB30C4B2CCABF4D9B9595A0E3B9BFA95CA696DDF6CB3F5F6F8F1D76ADC93FD015F4368087CB3FE619896FEB41C73F1C4F68FF72D3CB3F77C371464C92CB3F954A3B7F7EB9C93FA601782F9671C83F28936B891D15AE3FF9CB02799AEBCB3FB3B66DABA454C2BFC034750875D7C53FEB508A1392DCCBBF9BBA6393FC91C4BF25B25750253FCABF8B78BA9C3971C5BF0C6A0C6C9777C5BF66E52544483ACBBF30807B50079AC83FE7FA1A7402A0C4BFCF86C01B35BAC83FADB97DF1BEA7BFBF5ADE282A0D5BC5BFA1DD926C24DDCB3F1188B58D7782C7BF8AD275B8C6BBCABF224A818B4F8ACBBFFBC3356B2FFDC3BF2CBB6E3BD1B8CA3FB54C65530432C8BFA15768C0FE37CABF7ACBC3EBF708C53F38EC68BF2639CA3FFE94F0D36E7DC33F56BCBFD95664CA3FED3AA5D66C28B2BFFAB7A1FFD3D2C83F1B0E545C9631C93F84A952374DB5C8BFA78DC233579CB1BFD2A2966A8278C33FD85D0A227D98C8BFB2A33832DB10C53F47E598F0B3ECC9BF4317CA01E8BDCA3FCC4D4D8CBCF1CABF385A52E1C187C83F5BD9E27BE9CFCB3FB4483CD4BDBFC1BF98816F4DAAAFCB3F38117CD18BA8C3BF39CF3A80C7BECBBFB3604F7A6CDFC8BF00C023C798CECA3F746A02DC3ADDC6BF22D91F8D1E1BC4BF7FA3130C2A24C5BF5B6D11C933D8C6BF1EA5A72A69F6C93FB7AAE109F217C6BF8592F50EA074CA3FB33BBA5F568EBF3FAC4AF7A1C714CBBFA3F67CDDC14B90BF51BD159C4009CCBFE4863334FF8FAA3F5C3DC06FA792C93FCC95228D8C34C8BFBDE2AE3E23FAC7BF291CDE30EF5ACB3F4E845ED2C7CAC5BF4BBF8BDD55FDC23FEBFCB7CB7FFFCBBF2D7601897FACCB3F740AE922FD7ACB3FA8CAB4686ADFCB3FF7187C3DE8E7CA3FF20C9817C3C2C83F24EE37D4656ECB3F46227EC371F6CA3F05E673C641C8C23F243300B8EB97BDBF5F490E07CAF4CA3FF244E6829D93C53FD15ABF2CE7C5C43FD6E747A1549EC6BFAE657E02954FB7BF9C9C664D2963CABF83ED64B97424CBBF326500858EB2CA3F8CB16BD33EFFCBBFDBFBE5DDAF1EC83F12D7CF41FBB7C33F82A537C98CADC8BF7692DA30D1CEC93F1DACD97A7766C8BF7EEE2759B8C5BFBF524ED2C1320BCC3F5BE0A96AA113C83F5C366BAA5004CC3F559908AF3829CB3FC4A9F0113713C43FDCA2DA2D2159CBBFE8FFFAD13B13CB3FBAD9CC427109CC3F4AA8EDFD575BC9BFB2B90CAFEDA9C6BF2EADFB7CE6EAB23FBB3C9FF593F2CBBFA70EE5E83E91CBBFB5C0B5D40D0ACC3FBA793D78845DC33FD271E75ED103CCBFCE03D4A9F7ECC23FEEF6D07480FACBBFB97CCD48FAA2C6BFD31136C8EE0BC4BFBB718E220BE7C3BFCB43087E8893BEBFC80EAAE13A4AC1BF587A1E8B45FFCB3F9BD6EF87EB8ECA3F074AA60E2609CC3F1200CB194E6ACA3F4EAFADA8BE4FCABF66D775E2A2E6CBBF07BAC50B3F40C5BF8E974E0AAAE8C4BF0929CCA5D2CFC63FA446ECA87E0ABBBFD264C4E87AA6C9BFC68335FB8EDECBBF444F66CA74FDCBBF2771A4021749C53FC8A88B2C9BE8CBBFAA58BEEAF525C7BF03A0D3013959CBBF95E28BC69034B93F08BE886483B9C63F1CBB29AB33D65FBF7C6F937A994AC5BFFAEB599886BDC6BFE988A8729D09CC3FC77D364C2F37C5BFA0560C27B30ACBBFAF42A611E607C4BF606987322940CA3F6BD4F07F4B43C23F9A8ECF4384C0CB3F3CEBDFA4AC33C73F693DCCC1E496C0BF926858436E0ACCBF17DA548E11D2CBBF0292B3EF0722CA3FC426A36A8E93C23F2E72825E31CDC63FD3FC9841B9F9C63F1AFF6B4971F2CB3F2EAE3854E66ACB3F3B6CA2BD362CC5BF95CB1E76202DC7BFF37F632681F3CBBF2BD5F6EC7597CA3F560CDAE2F39CCBBF5CC84C98D32CC63F8355D2A0F053C43F508A12DE8D039C3FB164C7A07637C2BF558FB911B8E6C8BF6E9C9C6A5105C5BF5B6D5983B047B1BF74A2F276448ECBBF91D2F34115F4CB3F4F6C5B12C549CB3F26E708E973D5C93FE901D6F89973CA3FAFAC684971B5C83F45BCBE28E5C2C6BF1A319003BD08CCBF913E7D32F12CCABF949386E0E985BE3F25F99A3125C5CB3F7FE834B65A09CCBFFA32C56BA0A9CBBF"> : tensor<20x20xf64>
    return %cst : tensor<20x20xf64>
  }
}