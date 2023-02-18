import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

import 'button_default.dart';

Future<T?> showCustomAlertDialog<T>(
    {required BuildContext context,
    required String title,
    String? subtitle,
    Widget? subtitleWidget,
    required String cancelButtonText,
    String? confirmButtonText,
    Color? cancelButtonColor,
    Color? confirmButtonColor,
    Color? confirmButtonTextColor,
    double? heightBoxDialog,
    void Function()? onCancel,
    void Function()? onConfirm}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0.0,
          content: Container(
              height:
                  heightBoxDialog ?? MediaQuery.of(context).size.height / 4.5,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  subtitleWidget != null || subtitle != null
                      ? SizedBox(
                          height: Dimens.SPACE_10,
                        )
                      : SizedBox(
                          height: Dimens.SPACE_20,
                        ),
                  subtitleWidget != null
                      ? subtitleWidget
                      : subtitle != null
                          ? Text(
                              subtitle,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.0, color: ColorsItem.grey8D9299),
                              textAlign: TextAlign.center,
                            )
                          : SizedBox(),
                  SizedBox(
                    height: Dimens.SPACE_20,
                  ),
                  Row(
                    mainAxisAlignment: confirmButtonText != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.center,
                    children: [
                      ButtonDefault(
                          buttonText: cancelButtonText,
                          buttonTextColor:
                              cancelButtonColor ?? ColorsItem.orangeFB9600,
                          buttonColor: Colors.transparent,
                          buttonLineColor: ColorsItem.grey666B73,
                          radius: 10.0,
                          fontSize: Dimens.SPACE_12,
                          letterSpacing: 1.5,
                          paddingHorizontal: 0,
                          width: MediaQuery.of(context).size.width / 3.2,
                          onTap: onCancel == null
                              ? () {
                                  Navigator.pop(context);
                                }
                              : onCancel),
                      confirmButtonText != null
                          ? ButtonDefault(
                              buttonText: confirmButtonText,
                              buttonTextColor: confirmButtonTextColor != null
                                  ? confirmButtonTextColor
                                  : ColorsItem.whiteFEFEFE,
                              buttonColor: confirmButtonColor != null
                                  ? confirmButtonColor
                                  : ColorsItem.redDA1414,
                              buttonLineColor: Colors.transparent,
                              radius: 10.0,
                              fontSize: Dimens.SPACE_12,
                              letterSpacing: 1.5,
                              paddingHorizontal: 0,
                              width: MediaQuery.of(context).size.width / 3.2,
                              onTap: onConfirm)
                          : SizedBox(),
                    ],
                  )
                ],
              )),
        );
      });
}
