import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class MainAppBar extends StatelessWidget {
  final String title;
  final String dest;
  final void Function()? ellipsisAction;
  final Widget? addWidget;

  const MainAppBar(
      {required this.title,
      required this.dest,
      this.ellipsisAction,
      this.addWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: ColorsItem.black191C21,
      foregroundColor: ColorsItem.green00A1B0,
      elevation: 0,
      toolbarHeight: MediaQuery.of(context).size.height / 10,
      flexibleSpace: Container(
        padding: EdgeInsets.only(left: Dimens.SPACE_20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_18,
                        color: ColorsItem.whiteEDEDED,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: Dimens.SPACE_4),
                Text(dest,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12,
                        color: ColorsItem.greyB8BBBF,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            ellipsisAction != null
                ? InkWell(
                    onTap: ellipsisAction,
                    child: FaIcon(
                      FontAwesomeIcons.ellipsisVertical,
                      color: ColorsItem.whiteFEFEFE,
                      size: 20.0,
                    ))
                : addWidget != null
                    ? addWidget!
                    : SizedBox()
          ],
        ),
      ),
    ));
  }
}
