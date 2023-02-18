import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/ticket_item.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfileTicketInfo extends StatelessWidget {
  final ProfileController profileController;

  ProfileTicketInfo({
    Key? key,
    required this.profileController,
  }) : super(key: key);

  Widget shimmerViews(BuildContext context) {
    return Shimmer.fromColors(
      child: Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: 6,
            itemBuilder: (_, __) {
              return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                      horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_10),
                  child: Row(
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
                          width: Dimens.SPACE_200,
                          height: Dimens.SPACE_20,
                        ),
                        baseColor: ColorsItem.grey979797,
                        highlightColor: ColorsItem.grey606060,
                      ),
                      Spacer(),
                      Shimmer.fromColors(
                        period: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsItem.black32373D,
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(Dimens.SPACE_12)),
                          ),
                          width: Dimens.SPACE_20,
                          height: Dimens.SPACE_20,
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
    );
  }

  Widget mainViews(BuildContext context) {
    return (profileController.unbreakTickets.isEmpty &&
            profileController.triageTickets.isEmpty &&
            profileController.highTickets.isEmpty &&
            profileController.normalTickets.isEmpty &&
            profileController.lowTickets.isEmpty &&
            profileController.wishlistTickets.isEmpty)
        ? EmptyList(
            title: S.of(context).room_empty_task_title,
            descripton: S.of(context).room_empty_task_description)
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Dimens.SPACE_20),
                profileController.unbreakTickets.isEmpty
                    ? SizedBox()
                    : Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: Dimens.SPACE_10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimens.SPACE_10),
                            border: Border.all(
                                color: ColorsItem.grey979797.withOpacity(0.5))),
                        child: ExpandablePanel(
                          theme: ExpandableThemeData(
                            iconColor: ColorsItem.grey606060,
                            iconSize: Dimens.SPACE_35,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              child: Text(
                                "Unbreak Now! (${profileController.unbreakTickets.length} ${S.of(context).label_ticket})",
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_16),
                              )),
                          collapsed: SizedBox(),
                          expanded: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount:
                                  profileController.unbreakTickets.length,
                              itemBuilder: (context, index) {
                                return TicketItem(
                                    onTap: () {
                                      profileController.goToTicketDetail(
                                        profileController.unbreakTickets[index],
                                      );
                                    },
                                    ticket:
                                        profileController.unbreakTickets[index],
                                    iconColor: Colors.pink);
                              }),
                        ),
                      ),
                profileController.triageTickets.isEmpty
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.fromLTRB(Dimens.SPACE_10,
                            Dimens.SPACE_10, Dimens.SPACE_10, 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimens.SPACE_10),
                            border: Border.all(
                                color: ColorsItem.grey979797.withOpacity(0.5))),
                        child: ExpandablePanel(
                          theme: ExpandableThemeData(
                            iconColor: ColorsItem.grey606060,
                            iconSize: Dimens.SPACE_35,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              child: Text(
                                "Needs Triage (${profileController.triageTickets.length} ${S.of(context).label_ticket})",
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_16,
                                ),
                              )),
                          collapsed: SizedBox(),
                          expanded: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: profileController.triageTickets.length,
                              itemBuilder: (context, index) {
                                return TicketItem(
                                    onTap: () {
                                      profileController.goToTicketDetail(
                                        profileController.triageTickets[index],
                                      );
                                    },
                                    ticket:
                                        profileController.triageTickets[index],
                                    iconColor: Colors.purple);
                              }),
                        ),
                      ),
                profileController.highTickets.isEmpty
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.fromLTRB(Dimens.SPACE_10,
                            Dimens.SPACE_10, Dimens.SPACE_10, 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimens.SPACE_10),
                            border: Border.all(
                                color: ColorsItem.grey979797.withOpacity(0.5))),
                        child: ExpandablePanel(
                          theme: ExpandableThemeData(
                            iconColor: ColorsItem.grey606060,
                            iconSize: Dimens.SPACE_35,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              child: Text(
                                "High (${profileController.highTickets.length} ${S.of(context).label_ticket})",
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_16,
                                ),
                              )),
                          collapsed: SizedBox(),
                          expanded: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: profileController.highTickets.length,
                              itemBuilder: (context, index) {
                                return TicketItem(
                                    onTap: () {
                                      profileController.goToTicketDetail(
                                        profileController.highTickets[index],
                                      );
                                    },
                                    ticket:
                                        profileController.highTickets[index],
                                    iconColor: Colors.red);
                              }),
                        ),
                      ),
                profileController.normalTickets.isEmpty
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.fromLTRB(Dimens.SPACE_10,
                            Dimens.SPACE_10, Dimens.SPACE_10, 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimens.SPACE_10),
                            border: Border.all(
                                color: ColorsItem.grey979797.withOpacity(0.5))),
                        child: ExpandablePanel(
                          theme: ExpandableThemeData(
                            iconColor: ColorsItem.grey606060,
                            iconSize: Dimens.SPACE_35,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              child: Text(
                                "Normal (${profileController.normalTickets.length} ${S.of(context).label_ticket})",
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_16,
                                ),
                              )),
                          collapsed: SizedBox(),
                          expanded: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: profileController.normalTickets.length,
                              itemBuilder: (context, index) {
                                return TicketItem(
                                    onTap: () {
                                      profileController.goToTicketDetail(
                                        profileController.normalTickets[index],
                                      );
                                    },
                                    ticket:
                                        profileController.normalTickets[index],
                                    iconColor: Colors.orange);
                              }),
                        ),
                      ),
                profileController.lowTickets.isEmpty
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.fromLTRB(Dimens.SPACE_10,
                            Dimens.SPACE_10, Dimens.SPACE_10, 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimens.SPACE_10),
                            border: Border.all(
                                color: ColorsItem.grey979797.withOpacity(0.5))),
                        child: ExpandablePanel(
                          theme: ExpandableThemeData(
                            iconColor: ColorsItem.grey606060,
                            iconSize: Dimens.SPACE_35,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              child: Text(
                                "Low (${profileController.lowTickets.length} ${S.of(context).label_ticket})",
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_16,
                                ),
                              )),
                          collapsed: SizedBox(),
                          expanded: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: profileController.lowTickets.length,
                              itemBuilder: (context, index) {
                                return TicketItem(
                                    onTap: () {
                                      profileController.goToTicketDetail(
                                        profileController.lowTickets[index],
                                      );
                                    },
                                    ticket: profileController.lowTickets[index],
                                    iconColor: Colors.yellow);
                              }),
                        ),
                      ),
                profileController.wishlistTickets.isEmpty
                    ? SizedBox()
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimens.SPACE_10),
                            border: Border.all(
                                color: ColorsItem.grey979797.withOpacity(0.5))),
                        child: ExpandablePanel(
                          theme: ExpandableThemeData(
                            iconColor: ColorsItem.grey606060,
                            iconSize: Dimens.SPACE_35,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              child: Text(
                                "Wishlist (${profileController.wishlistTickets.length} ${S.of(context).label_ticket})",
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_16,
                                ),
                              )),
                          collapsed: SizedBox(),
                          expanded: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount:
                                  profileController.wishlistTickets.length,
                              itemBuilder: (context, index) {
                                return TicketItem(
                                    onTap: () {
                                      profileController.goToTicketDetail(
                                        profileController
                                            .wishlistTickets[index],
                                      );
                                    },
                                    ticket: profileController
                                        .wishlistTickets[index],
                                    iconColor: Colors.lightBlueAccent);
                              }),
                        ),
                      ),
                
                SizedBox(height: Dimens.SPACE_12),
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
