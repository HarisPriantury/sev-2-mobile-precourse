import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class HistorySearch extends StatelessWidget {
  final String textHistory;
  final void Function() onTap;
  final void Function() delete;

  const HistorySearch({
    required this.textHistory,
    required this.onTap,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(Dimens.SPACE_20),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.clockRotateLeft,
                  size: Dimens.SPACE_18,
                ),
                SizedBox(
                  width: Dimens.SPACE_10,
                ),
                Expanded(
                  child: Text(
                    textHistory,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: delete,
                  child: FaIcon(
                    FontAwesomeIcons.xmark,
                    size: Dimens.SPACE_18,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          indent: Dimens.SPACE_20,
          height: 0,
          thickness: 1,
        )
      ],
    );
  }
}
