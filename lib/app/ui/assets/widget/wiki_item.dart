import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class WikiItem extends StatelessWidget {
  const WikiItem({
    required this.wikiName,
    required this.fileCreated,
    required this.onTap,
  }) : super();

  final String fileCreated;
  final void Function() onTap;
  final String wikiName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FaIcon(FontAwesomeIcons.wikipediaW, size: Dimens.SPACE_18),
                SizedBox(width: Dimens.SPACE_12),
                Expanded(
                  child: Text(
                    wikiName,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_16, color: ColorsItem.urlColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimens.SPACE_6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    fileCreated,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12,
                        color: ColorsItem.greyB8BBBF),
                  ),
                ),
              ],
            ),
            Divider(color: ColorsItem.grey666B73, height: Dimens.SPACE_30)
          ],
        ),
      ),
    );
  }
}
