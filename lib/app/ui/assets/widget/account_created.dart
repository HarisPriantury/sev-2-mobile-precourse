import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';

class AccountCreatedPage extends StatelessWidget {
  const AccountCreatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageItem.BG_MILKY_WAY),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        ImageItem.WAITING_IMAGE,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: Dimens.SPACE_40),
                      Text(
                        S.of(context).register_account_success_title,
                        style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE,
                            fontSize: Dimens.SPACE_16,
                            height: 1.5,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: Dimens.SPACE_16),
                      Container(
                        child: Text(
                          S.of(context).register_account_success_subtitle,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_16,
                              height: 1.5,
                              color: ColorsItem.greyB8BBBF),
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
                    buttonTextColor: ColorsItem.black191C21,
                    buttonColor: ColorsItem.orangeFB9600,
                    buttonLineColor: ColorsItem.orangeFB9600,
                    letterSpacing: 1.5,
                    paddingHorizontal: Dimens.SPACE_80,
                    paddingVertical: Dimens.SPACE_14,
                    radius: Dimens.SPACE_8,
                    onTap: () => Navigator.pop(context),
                  )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
