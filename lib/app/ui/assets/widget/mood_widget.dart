import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class MoodWidget extends StatelessWidget {
  const MoodWidget({
    Key? key,
    required this.mood,
    required this.iconMood,
    required this.label,
  }) : super(key: key);

  final String mood;
  final String iconMood;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          iconMood,
          color: mood == label ? ColorsItem.orangeFB9600 : ColorsItem.greyB8BBBF,
        ),
        SizedBox(
          height: Dimens.SPACE_8,
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            color: mood == label ? ColorsItem.whiteFEFEFE : ColorsItem.grey8D9299,
            fontWeight: FontWeight.w500,
            fontSize: Dimens.SPACE_12,
          ),
        ),
      ],
    );
  }
}
