import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class CalendarEventItem extends StatelessWidget {
  final String day;
  final String date;
  final String dateTime;
  final String title;
  final void Function()? onTap;

  const CalendarEventItem(
      {Key? key,
      required this.day,
      required this.date,
      required this.dateTime,
      required this.title,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: Theme.of(context),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(top: Dimens.SPACE_12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                child: Text(day,
                    style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14)),
              ),
              SizedBox(height: Dimens.SPACE_4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(Dimens.SPACE_14),
                      decoration: BoxDecoration(
                          color: ColorsItem.blue38A1D3,
                          borderRadius: BorderRadius.circular(Dimens.SPACE_12)),
                      child: Text(date,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.whiteFEFEFE,
                              fontSize: Dimens.SPACE_16,
                              fontWeight: FontWeight.w400)),
                    ),
                    SizedBox(width: Dimens.SPACE_12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(title,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14)),
                          SizedBox(height: Dimens.SPACE_6),
                          Text(dateTime,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: Dimens.SPACE_12),
              Divider(color: ColorsItem.grey666B73, indent: Dimens.SPACE_20)
            ],
          ),
        ),
      ),
    );
  }
}
