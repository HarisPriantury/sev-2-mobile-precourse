import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heatmap_calendar/heatmap_calendar.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfileContribution extends StatelessWidget {
  final ProfileController profileController;

  const ProfileContribution({
    Key? key,
    required this.profileController,
  }) : super(key: key);

  Widget shimmerViews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.5,
            padding: EdgeInsets.all(Dimens.SPACE_10),
            decoration: BoxDecoration(
              color: ColorsItem.grey606060,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: ColorsItem.grey606060),
            ),
          ),
          baseColor: ColorsItem.grey979797,
          highlightColor: ColorsItem.grey606060,
        ),
        SizedBox(
          height: Dimens.SPACE_15,
        ),
      ],
    );
  }

  Widget mainViews(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(Dimens.SPACE_10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: ColorsItem.grey606060),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).label_contribution,
            style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_14,
                color: ColorsItem.grey666B73,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Dimens.SPACE_15),
          HeatMapCalendar(
            input: profileController.contributionsLevel,
            colorThresholds: {
              0: ColorsItem.black32373D,
              1: ColorsItem.orangeFB9600.withOpacity(0.2),
              2: ColorsItem.orangeFB9600.withOpacity(0.6),
              3: ColorsItem.orangeFF7A00,
            },
            weekDaysLabels: profileController.getWeekDaysLabels(),
            monthsLabels: profileController.getMonthLabels(),
            squareSize: Dimens.SPACE_16,
            labelTextColor: Colors.blueGrey,
            dayTextColor: Colors.blue.shade500,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        child: profileController.isLoading
            ? shimmerViews(context)
            : mainViews(context));
  }
}
