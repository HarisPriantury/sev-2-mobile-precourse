import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/no_connection.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/controller.dart';

class LoginPage extends View {
  final Object? arguments;

  LoginPage({this.arguments});

  @override
  _LoginState createState() =>
      _LoginState(AppComponent.getInjector().get<LoginController>(), arguments);
}

class _LoginState extends ViewState<LoginPage, LoginController> {
  LoginController _controller;

  _LoginState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  var isLogin = true;

  @override
  Widget get view =>
      ControlledWidgetBuilder<LoginController>(builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageItem.BG_MILKY_WAY),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            key: globalKey,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: SizedBox(),
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(FontAwesomeIcons.chevronLeft,
                      color: ColorsItem.whiteE0E0E0),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  S.of(context).label_back,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16, color: ColorsItem.whiteEDEDED),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                color: Colors.transparent,
              ),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Container(
                    //   height:
                    //       MediaQuery.of(context).size.height / 9 * 2,
                    //   width: double.infinity,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         S.of(context).login_welcome_label,
                    //         style: GoogleFonts.raleway(
                    //           color: ColorsItem.whiteFEFEFE,
                    //           fontSize: Dimens.SPACE_16,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //       ),
                    //       SizedBox(height: Dimens.SPACE_8),
                    //       Text(
                    //         _controller.data.workspaceName.capitalize(),
                    //         style: GoogleFonts.raleway(
                    //           color: ColorsItem.whiteFEFEFE,
                    //           fontSize: Dimens.SPACE_22,
                    //           fontWeight: FontWeight.w400,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      height: MediaQuery.of(context).size.height / 9 * 4,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImageItem.SUITE_LOGO,
                            width: MediaQuery.of(context).size.width / 4,
                          ),
                          SizedBox(height: Dimens.SPACE_15),
                          Text(
                            S.of(context).app_name,
                            style: GoogleFonts.orbitron(
                              fontSize: Dimens.SPACE_25,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.15,
                              color: ColorsItem.whiteColor,
                            ),
                          ),
                          SizedBox(height: Dimens.SPACE_8),
                          Text(
                            S.of(context).mobile_label,
                            style: GoogleFonts.orbitron(
                              fontSize: Dimens.SPACE_13,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.8,
                              color: ColorsItem.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height / 9 * 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => _controller.loginGoogle(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimens.SPACE_16),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          ImageItem.IC_GOOGLE,
                                          height: 14,
                                          width: 14,
                                        ),
                                        SizedBox(
                                          width: Dimens.SPACE_5,
                                        ),
                                        Text(
                                          S.of(context).login_btn_google_label,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                            color: ColorsItem.black32373D,
                                            fontSize: Dimens.SPACE_16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimens.SPACE_20),
                            Platform.isIOS
                                ? InkWell(
                                    onTap: () => _controller.loginApple(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimens.SPACE_16),
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                ImageItem.IC_APPLE,
                                                height: 14,
                                                width: 14,
                                              ),
                                              SizedBox(
                                                width: Dimens.SPACE_5,
                                              ),
                                              Text(
                                                S
                                                    .of(context)
                                                    .login_btn_apple_label,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  color: ColorsItem.black32373D,
                                                  fontSize: Dimens.SPACE_16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        )),
                    Container(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "${S.of(context).label_agreement} ",
                            style: GoogleFonts.montserrat(
                              color: ColorsItem.whiteE0E0E0,
                              fontSize: Dimens.SPACE_12,
                              fontWeight: FontWeight.w500,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${S.of(context).label_tos} ',
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.yellowFFA600,
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _controller
                                        .launchURL('https://sev-2.com/tos');
                                  },
                              ),
                              TextSpan(
                                text: '${S.of(context).label_and} ',
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteE0E0E0,
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: '${S.of(context).privacy_policy}.',
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.yellowFFA600,
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _controller
                                        .launchURL('https://sev-2.com/privacy');
                                  },
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 9 * 2,
                      child: _controller.data.type == LoginType.idp
                          ? SizedBox()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  S.of(context).login_no_account_label,
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
                                    _controller.goToRegisterPage();
                                  },
                                  child: Text(
                                    S.of(context).login_register_now_label,
                                    style: GoogleFonts.montserrat(
                                      color: ColorsItem.yellowFFA600,
                                      fontSize: Dimens.SPACE_14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
