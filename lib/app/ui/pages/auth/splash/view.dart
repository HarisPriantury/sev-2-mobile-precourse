import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/pages/auth/splash/controller.dart';

class SplashPage extends View {
  final Object? arguments;

  SplashPage({this.arguments});

  @override
  _SplashPageState createState() => _SplashPageState(AppComponent.getInjector().get<SplashController>(), arguments);
}

class _SplashPageState extends ViewState<SplashPage, SplashController> {
  SplashController _controller;

  _SplashPageState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => MaterialApp(
      debugShowCheckedModeBanner: false,
      key: globalKey,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: SafeArea(
            child: new Stack(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    ImageItem.BG_MILKY_WAY,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ),
                new Positioned(
                    child: Align(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 3),
                      Image.asset(
                        ImageItem.SUITE_LOGO,
                        width: Dimens.SPACE_80,
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
                )),
                new Positioned(
                  child: new Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(bottom: Dimens.SPACE_30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              ImageItem.RF_LOGO,
                              width: 43.0,
                            ),
                            SizedBox(height: Dimens.SPACE_10),
                            Text(
                              S.of(context).splash_screen_footer,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: Dimens.SPACE_12,
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                _controller.isJailBreak
                    ? Container(
                        child: Center(
                          child: AlertDialog(
                            backgroundColor: ColorsItem.black32373D,
                            content: Container(
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(Dimens.SPACE_20))),
                              child: Text(S.of(context).splash_jailbreak_warning,
                                  style:
                                      GoogleFonts.montserrat(fontSize: Dimens.SPACE_16, color: ColorsItem.whiteColor)),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => SystemNavigator.pop(),
                                  child: Text(S.of(context).label_ok,
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_16, color: ColorsItem.orangeFB9600)))
                            ],
                            elevation: Dimens.SPACE_25,
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ));
}
