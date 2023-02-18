import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/controller.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHead extends StatelessWidget {
  final ProfileController profileController;
  const ProfileHead({
    Key? key,
    required this.profileController,
  }) : super(key: key);

  Widget shimmerViews(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Shimmer.fromColors(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / Dimens.SPACE_13,
                backgroundColor: ColorsItem.grey606060,
              ),
              baseColor: ColorsItem.grey979797,
              highlightColor: ColorsItem.grey606060,
            )
          ],
        ),
        SizedBox(width: Dimens.SPACE_10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.SPACE_10),
                    color: ColorsItem.grey606060,
                  ),
                  width: Dimens.SPACE_130,
                  height: Dimens.SPACE_20,
                ),
                baseColor: ColorsItem.grey979797,
                highlightColor: ColorsItem.grey606060,
              ),
              SizedBox(height: Dimens.SPACE_10),
              Shimmer.fromColors(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorsItem.grey606060,
                  ),
                  width: Dimens.SPACE_130,
                  height: Dimens.SPACE_20,
                ),
                baseColor: ColorsItem.grey979797,
                highlightColor: ColorsItem.grey606060,
              ),
              SizedBox(height: Dimens.SPACE_10),
            ],
          ),
        ),
      ],
    );
  }

  Widget mainViews(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (profileController.isBlocked)
              Container(
                  width: MediaQuery.of(context).size.width / 6.3,
                  height: MediaQuery.of(context).size.width / 6.3,
                  foregroundDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(ImageItem.IC_SAD)),
            if (!profileController.isBlocked)
              CircleAvatar(
                radius: MediaQuery.of(context).size.width / 13,
                backgroundImage:
                    NetworkImage(profileController.profile.avatar!),
              )
          ],
        ),
        SizedBox(width: Dimens.SPACE_10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: Dimens.SPACE_6),
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: profileController.profile.getFullName(),
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16,
                      color: ColorsItem.grey666B73,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            " (${profileController.profile.name!.contains('(') ? profileController.profile.name!.split(' (').first : profileController.profile.name})",
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (profileController.isBlocked)
                Container(
                  padding: EdgeInsets.only(bottom: Dimens.SPACE_6),
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: S.of(context).user_blocked_terms,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                )
              else ...[
                if (profileController.profile.roles
                        .contains(AppConstants.USER_DISABLED) ||
                    !profileController.profile.roles
                        .contains(AppConstants.USER_APPROVED))
                  SingleChildScrollView(
                    child: Row(
                      children: [
                        // USER DISABLED
                        if (profileController.profile.roles
                            .contains(AppConstants.USER_DISABLED)) ...[
                          FaIcon(
                            FontAwesomeIcons.ban,
                            color: ColorsItem.redB43600,
                            size: Dimens.SPACE_14,
                          ),
                          SizedBox(width: Dimens.SPACE_4),
                          Text(
                            S.of(context).role_user_disabled,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.redB43600,
                                fontWeight: FontWeight.w700,
                                fontSize: Dimens.SPACE_14),
                          ),
                          SizedBox(width: Dimens.SPACE_6),
                        ],
                        // USER UNAPPROVED
                        if (!profileController.profile.roles
                            .contains(AppConstants.USER_APPROVED)) ...[
                          FaIcon(
                            FontAwesomeIcons.userClock,
                            color: ColorsItem.orangeFA8C16,
                            size: Dimens.SPACE_14,
                          ),
                          SizedBox(width: Dimens.SPACE_4),
                          Text(
                            S.of(context).role_unapproved,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.orangeFA8C16,
                                fontWeight: FontWeight.w700,
                                fontSize: Dimens.SPACE_14),
                          )
                        ],
                      ],
                    ),
                  ),
                // USER ACTIVE
                if (profileController.profile.roles
                        .contains(AppConstants.USER_APPROVED) &&
                    !profileController.profile.roles
                        .contains(AppConstants.USER_DISABLED))
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 6.0,
                        backgroundColor: profileController.profile.availability
                                .toLowerCase()
                                .contains("busy")
                            ? ColorsItem.orangeFB9600
                            : ColorsItem.green219653,
                      ),
                      SizedBox(width: Dimens.SPACE_4),
                      Text(
                        profileController.profile.availability.isNullOrBlank()
                            ? "Available"
                            : profileController.profile.availability.ucwords(),
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                      ),
                    ],
                  ),
                // USER REPORTED & UNVERIFIED
                if (profileController.isReported ||
                    !profileController.profile.roles
                        .contains(AppConstants.USER_EMAIL_VERIFIED) ||
                    !profileController.profile.roles
                        .contains(AppConstants.USER_APPROVED))
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: Dimens.SPACE_6,
                    ),
                    child: Row(
                      children: [
                        // USER REPORTED 25 April 2022: comment flag reported since not so essentially business wise needed
                        // if (profileController.isReported == true) ...[
                        //   FaIcon(
                        //     FontAwesomeIcons.solidFlag,
                        //     color: ColorsItem.redB43600,
                        //     size: Dimens.SPACE_14,
                        //   ),
                        //   SizedBox(width: Dimens.SPACE_4),
                        //   Text(
                        //     S.of(context).role_reported_user,
                        //     style: GoogleFonts.montserrat(
                        //         color: ColorsItem.redB43600,
                        //         fontWeight: FontWeight.w700,
                        //         fontSize: Dimens.SPACE_14),
                        //   ),
                        //   SizedBox(width: Dimens.SPACE_6)
                        // ],
                        // USER EMAIL UNVERIFIED
                        if (!profileController.profile.roles
                            .contains(AppConstants.USER_EMAIL_VERIFIED)) ...[
                          FaIcon(
                            FontAwesomeIcons.squareEnvelope,
                            color: ColorsItem.yellowF2C94C,
                            size: Dimens.SPACE_14,
                          ),
                          SizedBox(width: Dimens.SPACE_4),
                          Text(
                            S.of(context).role_email_unverified,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.yellowF2C94C,
                                fontWeight: FontWeight.w700,
                                fontSize: Dimens.SPACE_14),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: profileController.data?.user == null
            ? () {
                profileController.goToStatus();
              }
            : null,
        child: Container(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
            margin: EdgeInsets.symmetric(
                horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_20),
            child: profileController.isLoading
                ? shimmerViews(context)
                : mainViews(context)),
      ),
    );
  }
}
