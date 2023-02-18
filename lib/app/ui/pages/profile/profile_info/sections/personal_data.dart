import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePersonalData extends StatelessWidget {
  final ProfileController profileController;

  const ProfilePersonalData({
    Key? key,
    required this.profileController,
  }) : super(key: key);

  Widget shimmerViews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.width * 0.5,
            padding: EdgeInsets.all(Dimens.SPACE_10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(Dimens.SPACE_10)),
              border: Border.all(color: ColorsItem.grey606060),
            ),
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: 3,
                itemBuilder: (_, __) {
                  return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimens.SPACE_20,
                          vertical: Dimens.SPACE_10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorsItem.black32373D,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_12)),
                              ),
                              width: 200,
                              height: Dimens.SPACE_16,
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
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_12)),
                              ),
                              width: Dimens.SPACE_100,
                              height: Dimens.SPACE_12,
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                        ],
                      ));
                }),
          ),
          baseColor: ColorsItem.grey979797,
          highlightColor: ColorsItem.grey606060,
        ),
      ],
    );
  }

  Widget mainViews(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(Dimens.SPACE_10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.SPACE_10)),
        border: Border.all(color: ColorsItem.black32373D),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).profile_join_date_label,
            style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_14,
                color: ColorsItem.grey666B73,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Dimens.SPACE_10),
          Text(
            profileController.dateUtil.format(
                'dd MMMM y',
                profileController.profile.registeredAt ??
                    profileController.userData.registeredAt),
            style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
          ),
          SizedBox(height: Dimens.SPACE_15),
          profileController.team != null
              ? Text(
                  S.of(context).profile_team_label,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_14,
                      color: ColorsItem.grey666B73,
                      fontWeight: FontWeight.bold),
                )
              : SizedBox(),
          SizedBox(
            height: profileController.team != null ? Dimens.SPACE_10 : 0.0,
          ),
          profileController.team != null
              ? Text(
                  profileController.team!.name!,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                )
              : SizedBox(),
          SizedBox(
            height: profileController.team != null ? Dimens.SPACE_15 : 0.0,
          ),
          Text(
            S.of(context).setting_account_email,
            style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_14,
                color: ColorsItem.grey666B73,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: Dimens.SPACE_10),
          Text(
            profileController.profile.email,
            style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
          ),
          // MARK : TEMP COMMENT, WAITING FROM BE
          // SizedBox(height: Dimens.SPACE_10),
          // Text(
          //   S.of(context).profile_stackoverflow_url,
          //   style: GoogleFonts.montserrat(
          //       fontSize: Dimens.SPACE_14,
          //       color: ColorsItem.grey666B73,
          //       fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: Dimens.SPACE_10),
          // Text(
          //   profileController.learningScore?.stackoverflowScore.toString() ??
          //       "-",
          //   style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
          // ),
          // SizedBox(height: Dimens.SPACE_10),
          // Text(
          //   S.of(context).profile_hackerrank_url,
          //   style: GoogleFonts.montserrat(
          //       fontSize: Dimens.SPACE_14,
          //       color: ColorsItem.grey666B73,
          //       fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: Dimens.SPACE_10),
          // Text(
          //   profileController.learningScore?.hackkerrankScore.toString() ?? "-",
          //   style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
          // ),
          // SizedBox(height: Dimens.SPACE_10),
          // Text(
          //   S.of(context).profile_duolingo_url,
          //   style: GoogleFonts.montserrat(
          //       fontSize: Dimens.SPACE_14,
          //       color: ColorsItem.grey666B73,
          //       fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: Dimens.SPACE_10),
          // Text(
          //   profileController.learningScore?.duolingoScore.toString() ?? "-",
          //   style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
          // ),
          // SizedBox(height: Dimens.SPACE_10),
          // Text(
          //   S.of(context).label_typing_speed,
          //   style: GoogleFonts.montserrat(
          //       fontSize: Dimens.SPACE_14,
          //       color: ColorsItem.grey666B73,
          //       fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: Dimens.SPACE_10),
          // Text(
          //   profileController.learningScore?.typingSpeedScore.toString() ?? "-",
          //   style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
          // ),
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
