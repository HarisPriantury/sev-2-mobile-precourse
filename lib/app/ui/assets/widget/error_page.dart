import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/list/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.SPACE_20,
                        ),
                        child: Image.asset(
                          ImageItem.SERVER_ERROR,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.server,
                            color: ColorsItem.whiteFEFEFE,
                            size: Dimens.SPACE_16,
                          ),
                          SizedBox(width: Dimens.SPACE_10),
                          Text(
                            S.of(context).error_server_problem_title,
                            style: GoogleFonts.montserrat(
                              color: ColorsItem.whiteFEFEFE,
                              fontSize: Dimens.SPACE_16,
                              // height: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.SPACE_16),
                      Container(
                        child: Text(
                          S.of(context).error_server_problem_subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_16,
                            // height: 1.5,
                            color: ColorsItem.greyB8BBBF,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
                  child: Center(
                      child: ButtonDefault(
                    buttonText: S.of(context).label_back.toUpperCase(),
                    letterSpacing: 1.5,
                    buttonTextColor: ColorsItem.orangeFB9600,
                    buttonColor: Colors.transparent,
                    buttonLineColor: ColorsItem.orangeFB9600,
                    paddingHorizontal: Dimens.SPACE_80,
                    paddingVertical: Dimens.SPACE_14,
                    radius: Dimens.SPACE_8,
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      Pages.workspaceList,
                      arguments: WorkspaceListArgs(Pages.errorPage),
                    ),
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
