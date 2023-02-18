import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/domain/appearance_method.dart';

class AppearanceController extends BaseController {
  AppearanceController(this._userData);
  UserData _userData;

  UserData get userData => _userData;

  String _selectedAppearance = "";

  String get selectedAppearance => _selectedAppearance;

  List<AppearanceMethod> optAppearanceMethod = [
    AppearanceMethod(
      "1",
      appearanceMethodName: "Light Mode",
    ),
    AppearanceMethod(
      "2",
      appearanceMethodName: "Dark Mode",
    ),
    AppearanceMethod(
      "3",
      appearanceMethodName: "System Default",
    ),
  ];

  @override
  void getArgs() {}

  @override
  void load() {}

  @override
  void initListeners() {
    loading(false);
    switch (_userData.selectedTheme) {
      case "Light":
        _selectedAppearance = "Light Mode";
        break;
      case "Dark":
        _selectedAppearance = "Dark Mode";
        break;
      default:
        _selectedAppearance = "System Default";
    }
  }

  @override
  void disposing() {}

  void setSelectedAppearance(String value) {
    if (_selectedAppearance != value) {
      _selectedAppearance = value;
      if (_selectedAppearance == "Dark Mode") {
        AdaptiveTheme.of(context).setDark();
        _userData.selectedTheme = AdaptiveThemeMode.dark.modeName;
      } else if (_selectedAppearance == "Light Mode") {
        AdaptiveTheme.of(context).setLight();
        _userData.selectedTheme = AdaptiveThemeMode.light.modeName;
      } else {
        AdaptiveTheme.of(context).setSystem();
        _userData.selectedTheme = AdaptiveThemeMode.system.modeName;
      }
      _userData.save();
      refreshUI();
    }
  }
}
