import 'package:event_bus/event_bus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/after_login.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/register/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';

class LoginController extends BaseController {
  LoginArgs? _data;
  DateUtilInterface _dateUtil;
  FirebaseAnalytics _analytics;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _usernameValid = false;
  bool _passwordValid = false;
  bool loginError = false;

  // properties
  LoginPresenter _presenter;
  EventBus _eventBus;
  UserData _userData;

  LoginController(
    this._presenter,
    this._eventBus,
    this._userData,
    this._dateUtil,
    this._analytics,
  ) : super();

  LoginArgs get data =>
      _data ?? LoginArgs(type: LoginType.idp, workspaceName: "");

  TextEditingController get usernameController => _usernameController;

  TextEditingController get passwordController => _passwordController;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get usernameValid => _usernameValid;

  bool get passwordValid => _passwordValid;

  @override
  void load() {
    loading(false);
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as LoginArgs;
      print(_data!.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.loginOnNext = (
      int? intId,
      String? accessToken,
      String? authProvider,
      String? email,
      String? sub,
    ) async {
      print(
          "login: success login $accessToken $email $intId $email $authProvider $sub");
      if (accessToken != null && accessToken.isNotEmpty) {
        _userData.intId = intId ?? 0;
        _userData.accessToken = accessToken;
        _userData.authProvider = authProvider ?? "";
        _userData.email = email ?? "";
        _userData.sub = sub ?? "";
        _userData.save();
      }
    };

    _presenter.loginOnComplete = () {
      print("login: completed login");
      Navigator.pushNamedAndRemoveUntil(
          context, Pages.workspaceList, (_) => false);
    };

    _presenter.loginOnError = (String e, String platform) {
      print("login: error login $e");
      _analytics.logEvent(
        name: "login_error",
        parameters: {
          "platform": platform,
          "error_msg": e,
        },
      );
      loading(false);
      Navigator.pushNamed(context, Pages.loginError);
    };

    _presenter.updateWorkspaceOnNext = (bool resp) {
      print("login: success updateWorkspace $resp");
      loading(false);
      Navigator.pushNamedAndRemoveUntil(context, Pages.main, (_) => false,
          arguments: MainArgs(Pages.login));

      _eventBus.fire(AfterLoginEvent());
    };

    _presenter.updateWorkspaceOnComplete = () {
      print("login: completed updateWorkspace");
    };

    _presenter.updateWorkspaceOnError = (e) {
      loading(false);
      print("login: error updateWorkspace $e");
    };
  }

  // void login() {
  //   loading(true);
  //   if (_data!.type == LoginType.google) {
  //     if (_data != null) {
  //       _presenter.login(_data!.workspaceName).then((_) {
  //         //
  //       });
  //     }
  //   } else {
  //     _presenter.onLogin(
  //         LoginApiRequest(_usernameController.text, _passwordController.text));
  //   }
  // }

  void loginGoogle() {
    loading(true);
    if (_data != null) {
      _presenter.loginGoogle(_data!.workspaceName).then((_) {
        //
      });
    }
  }

  void loginApple() {
    loading(true);
    if (_data != null) {
      _presenter.loginApple(_data!.workspaceName).then((_) {
        //
      });
    }
  }

  void toggleVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    refreshUI();
  }

  String getCurrentYear() {
    return _dateUtil.now().year.toString();
  }

  void validateUsername() {
    loginError = false;
    _usernameValid = _usernameController.text.length >= 3;
    refreshUI();
  }

  void validatePassword() {
    loginError = false;
    _passwordValid = _passwordController.text.length >= 3;
    refreshUI();
  }

  void goToRegisterPage() {
    Navigator.pushReplacementNamed(context, Pages.register,
        arguments: RegisterArgs(_data!.workspaceName));
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
