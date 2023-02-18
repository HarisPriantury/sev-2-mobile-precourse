import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/domain/calendar.dart';

class CalendarItem extends StatelessWidget {
  final Calendar calendar;
  final void Function()? onTap;

  const CalendarItem({required this.calendar, this.onTap}) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimens.SPACE_16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FaIcon(FontAwesomeIcons.calendarDay, size: Dimens.SPACE_18),
            SizedBox(width: Dimens.SPACE_12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${calendar.code}",
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_14,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          overflow: TextOverflow.ellipsis,
                          " ${calendar.name!}",
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14,
                              color: ColorsItem.orangeFB9600),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.SPACE_6),
                  Text(
                    'Private',
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12, color: Colors.red),
                  ),
                  SizedBox(height: Dimens.SPACE_6),
                  Text(
                    AppComponent.getInjector()
                        .get<DateUtil>()
                        .displayDateTimeFormat(calendar.startTime),
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12,
                        color: ColorsItem.greyB8BBBF),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimens.SPACE_12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${S.of(context).room_hosted_by_label}: ",
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12, color: ColorsItem.greyB8BBBF),
                ),
                SizedBox(height: Dimens.SPACE_4),
                Text(
                  calendar.host.getFullName()!,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12, color: ColorsItem.urlColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
