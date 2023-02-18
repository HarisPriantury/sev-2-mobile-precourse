import 'package:flutter/material.dart';

class ColorsItem {
  static var primaryColor = hexToColor("#191C21");
  static var secondaryBackgroundColor = hexToColor("#020202");

  static var whiteColor = hexToColor("#FFFFFF");
  static var whiteF2F2F2 = hexToColor("#F2F2F2");
  static var whiteFEFEFE = hexToColor("#FEFEFE");
  static var whiteE0E0E0 = hexToColor("#E0E0E0");
  static var whiteEDEDED = hexToColor("#EDEDED");
  static var white9E9E9E = hexToColor("##9E9E9E");

  static var grey666B73 = hexToColor("#666B73");
  static var grey8D9299 = hexToColor("#8D9299");
  static var greyB8BBBF = hexToColor("#B8BBBF");
  static var grey858A93 = hexToColor("#858A93");
  static var grey888888 = hexToColor("#888888");
  static var greyd8d8d8 = hexToColor("#D8D8D8");
  static var grey606060 = hexToColor("#606060");
  static var grey979797 = hexToColor("#979797");
  static var grey555555 = hexToColor("#555555");
  static var grey8C8C8C = hexToColor("#8C8C8C");
  static var greyCCECEF = hexToColor("#CCECEF");
  static var grey32373D = hexToColor("#32373D");
  static var grey2E353A = hexToColor("#2E353A");

  static var black = hexToColor("#000000");
  static var black191C21 = hexToColor("#191C21");
  static var black32373D = hexToColor("#32373D");
  static var black020202 = hexToColor("#020202");
  static var black1F2329 = hexToColor("#1F2329");
  static var black292D33 = hexToColor("#292D33");
  static var black24282E = hexToColor("#24282E");

  static var green00A1B0 = hexToColor("#00A1B0");
  static var green219653 = hexToColor("#219653");
  static var green477908 = hexToColor("#477908");

  static var orangeFFB200 = hexToColor("#FFB200");
  static var orangeFB9600 = hexToColor("#FB9600");
  static var orangeFA8C16 = hexToColor("#FA8C16");
  static var orangeCC6000 = hexToColor("#CC6000");
  static var orangeFF7A00 = hexToColor("#FF7A00");

  static var redB43600 = hexToColor("#B43600");
  static var redDA1414 = hexToColor("#DA1414");
  static var redA70000 = hexToColor("#A70000");

  static var blue3FB5ED = hexToColor("#3FB5ED");
  static var blue38A1D3 = hexToColor("#38A1D3");
  static var blue0055D0 = hexToColor("#0055D0");
  static var blue66C7D0 = hexToColor("#66C7D0");

  static var yellowF2C94C = hexToColor("#F2C94C");
  static var yellowFFA600 = hexToColor("#FFA600");
  static var yellowFEF3E0 = hexToColor("#FEF3E0");

  static var urlColor = hexToColor("#00B4C4");

  static Color hexToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return new Color(int.parse(hexColor, radix: 16) + 0xFF000000);
  }
}
