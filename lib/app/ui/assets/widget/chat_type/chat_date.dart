import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class ChatDate extends StatelessWidget {
  final String date;
  final bool isShow;

  const ChatDate({
    required this.date,
    this.isShow = true,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return isShow
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimens.SPACE_8, horizontal: Dimens.SPACE_16),
              decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: ColorsItem.white9E9E9E),
                borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.SPACE_20),
                ),
              ),
              child: Text(
                date,
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_10, fontWeight: FontWeight.w600),
              ),
            ),
          )
        : SizedBox();
  }
}
