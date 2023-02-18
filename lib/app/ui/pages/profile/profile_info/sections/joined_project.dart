import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/project_list.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfileProjectJoined extends StatelessWidget {
  final ProfileController profileController;

  const ProfileProjectJoined({
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
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(color: ColorsItem.grey606060),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).profile_project_joined_label,
            style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_14,
                color: ColorsItem.grey666B73,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: profileController.project.length,
            itemBuilder: (context, index) {
              return ProjectList(
                onTap: () {
                  profileController
                      .goToProjectDetail(profileController.project[index]);
                },
                projectName: profileController.project[index].name!,
                joinDate: "",
                status: profileController.project[index].isArchived
                    ? S.of(context).label_archive
                    : S.of(context).status_task_open,
                index: index,
              );
            },
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
