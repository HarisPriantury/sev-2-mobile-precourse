import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

showOnLoading(BuildContext context, String? label) {
  double widthDialog = MediaQuery.of(context).size.width * 0.90;
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SimpleDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
          elevation: 0,
          children: [
            Container(
              width: widthDialog,
              padding: EdgeInsets.symmetric(
                vertical: Dimens.SPACE_35,
                horizontal: Dimens.SPACE_14,
              ),
              child: Column(
                children: [
                  Center(
                      child: CupertinoActivityIndicator(
                    animating: true,
                    radius: Dimens.SPACE_24,
                  )),
                  SizedBox(
                    height: Dimens.SPACE_25,
                  ),
                  Text(
                    label ?? "Loading...",
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
