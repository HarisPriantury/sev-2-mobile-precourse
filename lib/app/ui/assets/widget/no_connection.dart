import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/events/connection.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';

class NoConnection extends StatelessWidget {
  final GlobalKey<State<StatefulWidget>> globalKey;

  NoConnection(this.globalKey);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        key: globalKey,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      ImageItem.IC_NO_CONNECTION,
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                  SizedBox(height: Dimens.SPACE_40),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(ImageItem.IC_WIFI_SLASH),
                        SizedBox(
                          width: Dimens.SPACE_10,
                        ),
                        Text(
                          S.of(context).no_connection_title,
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_16, height: 1.5, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.SPACE_10),
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                      child: Text(
                        S.of(context).no_connection_description,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_16, height: 1.5, color: ColorsItem.greyB8BBBF),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 110.0,
                  ),
                  Center(
                      child: ButtonDefault(
                    buttonText: S.of(context).no_btn_retry_label,
                    buttonTextColor: ColorsItem.orangeFB9600,
                    buttonColor: Colors.transparent,
                    buttonLineColor: ColorsItem.orangeFB9600,
                    paddingHorizontal: Dimens.SPACE_25,
                    onTap: () {
                      // ugly but necessary
                      AppComponent.getInjector().get<EventBus>().fire(RetryConnectionEvent());
                    },
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
