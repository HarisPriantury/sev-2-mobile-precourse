import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/domain/stickit.dart';

class StickitItem extends StatelessWidget {
  final Stickit stickit;
  final void Function()? onTap;
  final bool isRead;

  const StickitItem({required this.stickit, this.onTap, this.isRead = false})
      : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimens.SPACE_16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: <Widget>[
                FaIcon(FontAwesomeIcons.calendarDay, size: Dimens.SPACE_18),
                !isRead
                    ? Positioned(
                        left: Dimens.SPACE_9,
                        bottom: Dimens.SPACE_11,
                        child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          constraints: BoxConstraints(
                            minWidth: Dimens.SPACE_8,
                            minHeight: Dimens.SPACE_8,
                          ),
                        ),
                      )
                    : SizedBox()
              ],
            ),
            SizedBox(width: Dimens.SPACE_12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stickit.name!,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_16,
                        color: ColorsItem.orangeFB9600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimens.SPACE_8),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.SPACE_10, vertical: Dimens.SPACE_4),
                    decoration: BoxDecoration(
                        color: ColorsItem.urlColor,
                        borderRadius: BorderRadius.circular(Dimens.SPACE_12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.eye,
                          size: Dimens.SPACE_16,
                        ),
                        SizedBox(width: Dimens.SPACE_6),
                        Text(
                          "${stickit.seenCount} people(s)",
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimens.SPACE_12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimens.SPACE_4),
                Text(
                  AppComponent.getInjector()
                      .get<DateUtil>()
                      .displayDateTimeFormat(stickit.createdAt),
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12, color: ColorsItem.white9E9E9E),
                ),
                SizedBox(height: Dimens.SPACE_4),
                Row(
                  children: [
                    Text(
                      "by: ",
                      style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_12,
                          color: ColorsItem.white9E9E9E),
                    ),
                    Text(
                      stickit.author.name!,
                      style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_12,
                          color: ColorsItem.urlColor),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
