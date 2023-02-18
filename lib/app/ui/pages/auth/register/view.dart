import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/pages/auth/register/controller.dart';

class RegisterPage extends View {
  final Object? arguments;

  RegisterPage({this.arguments});

  @override
  _RegisterPageState createState() => _RegisterPageState(
      AppComponent.getInjector().get<RegisterController>(), arguments);
}

class _RegisterPageState extends ViewState<RegisterPage, RegisterController> {
  RegisterController _controller;

  _RegisterPageState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => ControlledWidgetBuilder<RegisterController>(
          builder: (context, controller) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          key: globalKey,
          home: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageItem.BG_MILKY_WAY),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                elevation: 0,
                flexibleSpace: SimpleAppBar(
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  prefix: IconButton(
                    icon: FaIcon(FontAwesomeIcons.chevronLeft),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    S.of(context).label_back,
                    style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimens.SPACE_20),
                        child: Text(
                          S.of(context).register_join_suite_label,
                          style: GoogleFonts.raleway(
                            fontSize: Dimens.SPACE_22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Text(
                        S.of(context).register_full_name_label,
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_8),
                      Theme(
                        data: new ThemeData(
                          primaryColor: ColorsItem.grey666B73,
                          primaryColorDark: ColorsItem.grey666B73,
                        ),
                        child: TextFormField(
                          controller: _controller.fullNameController,
                          onChanged: (val) {
                            _controller.validateFullName();
                          },
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.fullNameValid
                                        ? ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.fullNameValid
                                        ? ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            hintStyle: GoogleFonts.montserrat(
                                color: !_controller.fullNameValid
                                    ? ColorsItem.grey666B73
                                    : ColorsItem.orangeFB9600),
                            hintText:
                                "${S.of(context).label_enter} ${S.of(context).register_full_name_label.toLowerCase()}",
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_16),
                      Text(
                        S.of(context).register_username_label,
                        style: GoogleFonts.montserrat(
                          color: ColorsItem.greyB8BBBF,
                          fontSize: Dimens.SPACE_12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_8),
                      Theme(
                        data: new ThemeData(
                          primaryColor: ColorsItem.grey666B73,
                          primaryColorDark: ColorsItem.grey666B73,
                        ),
                        child: TextFormField(
                          controller: _controller.usernameController,
                          onChanged: (val) {
                            _controller.validateUsername();
                          },
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.usernameValid
                                        ? ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.usernameValid
                                        ? ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            hintStyle: GoogleFonts.montserrat(
                                color: !_controller.usernameValid
                                    ? ColorsItem.grey666B73
                                    : ColorsItem.orangeFB9600),
                            hintText:
                                "${S.of(context).label_enter} ${S.of(context).register_username_label.toLowerCase()}",
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_16),
                      Text(
                        S.of(context).register_email_label,
                        style: GoogleFonts.montserrat(
                          color: ColorsItem.greyB8BBBF,
                          fontSize: Dimens.SPACE_12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_8),
                      Theme(
                        data: new ThemeData(
                          primaryColor: ColorsItem.grey666B73,
                          primaryColorDark: ColorsItem.grey666B73,
                        ),
                        child: TextFormField(
                          controller: _controller.emailController,
                          onChanged: (val) {
                            _controller.validateEmail();
                          },
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.emailValid
                                        ? ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.emailValid
                                        ? ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            hintStyle: GoogleFonts.montserrat(
                                color: !_controller.emailValid
                                    ? ColorsItem.grey666B73
                                    : ColorsItem.orangeFB9600),
                            hintText:
                                "${S.of(context).label_enter} ${S.of(context).register_email_label.toLowerCase()}",
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_16),
                      Text(
                        S.of(context).register_password_label,
                        style: GoogleFonts.montserrat(
                          color: ColorsItem.greyB8BBBF,
                          fontSize: Dimens.SPACE_12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_8),
                      Theme(
                        data: new ThemeData(
                          primaryColor: ColorsItem.grey666B73,
                          primaryColorDark: ColorsItem.grey666B73,
                        ),
                        child: TextFormField(
                          controller: _controller.passwordController,
                          obscureText: !_controller.isPasswordVisible,
                          onChanged: (val) {
                            _controller.validatePassword();
                            _controller.validatePasswordConfirm();
                          },
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.passwordValid
                                        ? _controller.passwordController.text
                                                .isNotEmpty
                                            ? ColorsItem.redDA1414
                                            : ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.passwordValid
                                        ? _controller.passwordController.text
                                                .isNotEmpty
                                            ? ColorsItem.redDA1414
                                            : ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _controller.isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                _controller.togglePasswordVisibility();
                              },
                            ),
                            hintStyle: GoogleFonts.montserrat(
                                color: ColorsItem.grey666B73),
                            hintText:
                                "${S.of(context).label_enter} ${S.of(context).register_password_label.toLowerCase()}",
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_8),
                      Text(
                        S.of(context).register_password_validation_label,
                        style: GoogleFonts.montserrat(
                          color:
                              _controller.passwordController.text.isNotEmpty &&
                                      !_controller.passwordValid
                                  ? ColorsItem.redDA1414
                                  : ColorsItem.greyB8BBBF,
                          fontSize: Dimens.SPACE_12,
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_16),
                      Text(
                        S.of(context).register_password_confirmation_label,
                        style: GoogleFonts.montserrat(
                          color: ColorsItem.greyB8BBBF,
                          fontSize: Dimens.SPACE_12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_8),
                      Theme(
                        data: new ThemeData(
                          primaryColor: ColorsItem.grey666B73,
                          primaryColorDark: ColorsItem.grey666B73,
                        ),
                        child: TextFormField(
                          controller: _controller.passwordConfirmController,
                          obscureText: !_controller.isPasswordConfirmVisible,
                          onChanged: (val) {
                            _controller.validatePasswordConfirm();
                          },
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.passwordConfirmValid
                                        ? _controller.passwordConfirmController
                                                .text.isNotEmpty
                                            ? ColorsItem.redDA1414
                                            : ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: !_controller.passwordConfirmValid
                                        ? _controller.passwordConfirmController
                                                .text.isNotEmpty
                                            ? ColorsItem.redDA1414
                                            : ColorsItem.grey666B73
                                        : ColorsItem.orangeFB9600)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _controller.isPasswordConfirmVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                _controller.togglePasswordConfirmVisibility();
                              },
                            ),
                            hintStyle: GoogleFonts.montserrat(
                                color: ColorsItem.grey666B73),
                            hintText:
                                "${S.of(context).label_enter} ${S.of(context).register_password_confirmation_label.toLowerCase()}",
                          ),
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_8),
                      _controller.passwordConfirmController.text.isNotEmpty &&
                              !_controller.passwordConfirmValid
                          ? Text(
                              S
                                  .of(context)
                                  .register_password_confirmation_error_label,
                              style: GoogleFonts.montserrat(
                                color: ColorsItem.redDA1414,
                                fontSize: Dimens.SPACE_12,
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: Dimens.SPACE_16 * 2),
                      ButtonDefault(
                        buttonText: S.of(context).label_register.toUpperCase(),
                        buttonTextColor: ColorsItem.black191C21,
                        buttonColor: ColorsItem.orangeFB9600,
                        buttonLineColor: ColorsItem.orangeFB9600,
                        disabledTextColor: ColorsItem.black191C21,
                        disabledButtonColor: ColorsItem.grey8C8C8C,
                        disabledLineColor: Colors.transparent,
                        letterSpacing: 1.5,
                        paddingHorizontal: Dimens.SPACE_80,
                        paddingVertical: Dimens.SPACE_14,
                        radius: Dimens.SPACE_8,
                        isDisabled:
                            !_controller.isFormValid() || _controller.isLoading,
                        onTap: () {
                          _controller.register();
                        },
                      ),
                      SizedBox(height: Dimens.SPACE_20),
                      Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).register_has_account_label,
                              style: GoogleFonts.montserrat(
                                color: ColorsItem.grey858A93,
                                fontSize: Dimens.SPACE_14,
                              ),
                            ),
                            SizedBox(
                              height: Dimens.SPACE_8,
                            ),
                            InkWell(
                              onTap: () {
                                _controller.goToLoginPage();
                              },
                              child: Text(
                                S.of(context).register_login_now_label,
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.yellowFFA600,
                                  fontSize: Dimens.SPACE_14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: Dimens.SPACE_20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}
