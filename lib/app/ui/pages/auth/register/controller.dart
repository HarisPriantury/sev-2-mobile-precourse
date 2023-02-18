import 'package:flutter/cupertino.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/register/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/register/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/auth/register_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';

class RegisterController extends BaseController {
  RegisterPresenter _presenter;
  late RegisterArgs _data;

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  bool _fullNameValid = false;
  bool _usernameValid = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _passwordConfirmValid = false;
  bool _isPasswordVisible = false;
  bool _isPasswordConfirmVisible = false;

  RegisterController(this._presenter);

  TextEditingController get fullNameController => _fullNameController;

  TextEditingController get usernameController => _usernameController;

  TextEditingController get emailController => _emailController;

  TextEditingController get passwordController => _passwordController;

  TextEditingController get passwordConfirmController =>
      _passwordConfirmController;

  bool get fullNameValid => _fullNameValid;

  bool get usernameValid => _usernameValid;

  bool get emailValid => _emailValid;

  bool get passwordValid => _passwordValid;

  bool get passwordConfirmValid => _passwordConfirmValid;

  bool get isPasswordVisible => _isPasswordVisible;

  bool get isPasswordConfirmVisible => _isPasswordConfirmVisible;

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as RegisterArgs;
      print(_data.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.registerOnNext = (BaseApiResponse resp) {
      if (resp.result.toLowerCase().contains("success")) {
        print("register: success register ${resp.result}");
        Navigator.pushReplacementNamed(context, Pages.accountCreated);
      } else {
        if (resp.result.toLowerCase().contains("username"))
          _usernameValid = false;
        else if (resp.result.toLowerCase().contains("email"))
          _emailValid = false;
        printd("register: failed register ${resp.result}");
        refreshUI();
      }
      loading(false);
    };

    _presenter.registerOnComplete = () {
      print("register: completed register");
    };

    _presenter.registerOnError = (e) {
      loading(false);
      print("register: error register$e");
    };
  }

  @override
  void load() {
    loading(false);
  }

  void register() {
    loading(true);
    _presenter.onRegister(
      RegisterApiRequest(
        _usernameController.text,
        _fullNameController.text,
        _emailController.text,
        _passwordController.text,
        _passwordConfirmController.text,
      ),
    );
  }

  void validateFullName() {
    _fullNameValid = _fullNameController.text.length >= 3;
    refreshUI();
  }

  void validateUsername() {
    _usernameValid = _usernameController.text.length >= 3;
    refreshUI();
  }

  void validateEmail() {
    _emailValid = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(_emailController.text);
    refreshUI();
  }

  void validatePassword() {
    _passwordValid = _passwordController.text.length >= 8;
    refreshUI();
  }

  void validatePasswordConfirm() {
    _passwordConfirmValid = _passwordValid &&
        (_passwordController.text == _passwordConfirmController.text);
    refreshUI();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    refreshUI();
  }

  bool isFormValid() {
    return _fullNameValid &&
        _usernameValid &&
        _emailValid &&
        _passwordValid &&
        _passwordConfirmValid;
  }

  void togglePasswordConfirmVisibility() {
    _isPasswordConfirmVisible = !_isPasswordConfirmVisible;
    refreshUI();
  }

  void goToLoginPage() {
    Navigator.pushReplacementNamed(context, Pages.login,
        arguments: LoginArgs(
            type: LoginType.emailPassword, workspaceName: _data.workspaceName));
  }
}
