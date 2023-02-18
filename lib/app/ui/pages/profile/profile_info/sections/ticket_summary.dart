import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSummary extends StatelessWidget {
  final ProfileController profileController;

  const ProfileSummary({
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
            height: MediaQuery.of(context).size.width * 0.3,
            padding: EdgeInsets.all(Dimens.SPACE_10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: ColorsItem.grey606060),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  period: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsItem.black32373D,
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_12)),
                    ),
                    width: Dimens.SPACE_100,
                    height: Dimens.SPACE_12,
                  ),
                  baseColor: ColorsItem.grey979797,
                  highlightColor: ColorsItem.grey606060,
                ),
                SizedBox(height: Dimens.SPACE_6),
                Shimmer.fromColors(
                  period: Duration(seconds: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsItem.black32373D,
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_12)),
                    ),
                    width: 200,
                    height: Dimens.SPACE_16,
                  ),
                  baseColor: ColorsItem.grey979797,
                  highlightColor: ColorsItem.grey606060,
                ),
                SizedBox(
                  height: Dimens.SPACE_20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Dimens.SPACE_80,
                      height: Dimens.SPACE_30,
                      padding: EdgeInsets.all(Dimens.SPACE_10),
                      decoration: BoxDecoration(
                        color: ColorsItem.black32373D,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    Container(
                      width: Dimens.SPACE_2,
                      height: Dimens.SPACE_30,
                      padding: EdgeInsets.all(Dimens.SPACE_10),
                      decoration: BoxDecoration(
                        color: ColorsItem.black32373D,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    Container(
                      width: Dimens.SPACE_80,
                      height: Dimens.SPACE_30,
                      padding: EdgeInsets.all(Dimens.SPACE_10),
                      decoration: BoxDecoration(
                        color: ColorsItem.black32373D,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          baseColor: ColorsItem.grey979797,
          highlightColor: ColorsItem.grey606060,
        ),
      ],
    );
  }

  Widget mainViews(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.SPACE_11,
        vertical: Dimens.SPACE_4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).label_summary,
            style: GoogleFonts.montserrat(
              fontSize: Dimens.SPACE_14,
              fontWeight: FontWeight.bold,
              color: ColorsItem.grey666B73,
            ),
          ),
          SizedBox(
            height: Dimens.SPACE_10,
          ),
          Row(
            children: [
              Text(
                profileController.getFirstDate(),
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                ),
              ),
              Text(
                "   .   ",
                style: GoogleFonts.montserrat(
                  fontSize: 16.0,
                  color: ColorsItem.grey555555,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profileController.getLastDate(),
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimens.SPACE_10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    profileController.totalSP.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: ColorsItem.orangeFB9600,
                    ),
                  ),
                  SizedBox(width: Dimens.SPACE_10),
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.SPACE_20),
                    child: Text(
                      "SP",
                      style: GoogleFonts.montserrat(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: ColorsItem.grey858A93,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 30,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1.0,
                      color: ColorsItem.grey666B73,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    profileController.totalHour.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      color: ColorsItem.orangeFB9600,
                    ),
                  ),
                  SizedBox(width: Dimens.SPACE_10),
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.SPACE_20),
                    child: Text(
                      "Hr",
                      style: GoogleFonts.montserrat(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: ColorsItem.grey858A93,
                      ),
                    ),
                  )
                ],
              ),
            ],
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
