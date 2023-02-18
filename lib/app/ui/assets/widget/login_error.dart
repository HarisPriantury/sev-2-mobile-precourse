import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';

class LoginErrorPage extends StatelessWidget {
  const LoginErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsItem.black020202,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorsItem.black020202,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          ImageItem.EMAIL_NOT_REGISTERED,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: Dimens.SPACE_40),
                        Text(
                          S.of(context).login_email_not_registered,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.whiteFEFEFE,
                              fontSize: Dimens.SPACE_16,
                              height: 1.5,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: Dimens.SPACE_16),
                        Container(
                          child: Text(
                            S.of(context).login_unregistered_description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_16, height: 1.5, color: ColorsItem.greyB8BBBF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
                    child: Center(
                        child: ButtonDefault(
                                buttonText: S.of(context).label_back.toUpperCase(),
                                buttonTextColor: ColorsItem.orangeFB9600,
                                buttonColor: Colors.transparent,
                                buttonLineColor: ColorsItem.orangeFB9600,
                                letterSpacing: 1.5,
                                paddingHorizontal: Dimens.SPACE_80,
                                paddingVertical: Dimens.SPACE_14,
                                radius: 10.0,
                                onTap: () => Navigator.pop(context),
                              )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
