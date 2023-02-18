import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class EmptyList extends StatelessWidget {
  final String title;
  final String descripton;

  const EmptyList({required this.title, required this.descripton}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: Dimens.TEXT_SIZE_H3),
              ),
              padding: const EdgeInsets.only(
                  left: Dimens.SPACE_40, right: Dimens.SPACE_40),
            ),
            SizedBox(height: Dimens.SPACE_6),
            Padding(
              child: Text(
                descripton,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14, color: ColorsItem.grey8D9299),
              ),
              padding: const EdgeInsets.only(
                  left: Dimens.SPACE_40, right: Dimens.SPACE_40),
            ),
          ],
        ));
  }
}
