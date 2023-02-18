import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_room_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/previous_room.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/sections/graphQl.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/sections/ip_daily_task.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/sections/ticket_outstanding.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/args.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

class LobbyContent extends StatelessWidget {
  final LobbyController lobbyController;

  LobbyContent({Key? key, required this.lobbyController}) : super(key: key);

  showRestoreRoomDialog(String roomId, BuildContext context) {
    showCustomAlertDialog(
        context: context,
        title: S.of(context).restoreRoom,
        subtitle: "",
        cancelButtonText: S.of(context).label_cancel.toUpperCase(),
        confirmButtonText: S.of(context).restore.toUpperCase(),
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          lobbyController.restoreRoom(roomId);
          Navigator.pop(context);
        });
  }

  _shimmerTicketOutstanding() {
    return Shimmer.fromColors(
      child: Container(
        width: double.infinity,
        height: Dimens.SPACE_170.h,
        padding: EdgeInsets.all(Dimens.SPACE_10.h),
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
                      horizontal: Dimens.SPACE_20.h,
                      vertical: Dimens.SPACE_10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        period: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsItem.black32373D,
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.SPACE_12.h)),
                          ),
                          width: Dimens.SPACE_30.h,
                          height: Dimens.SPACE_30.h,
                        ),
                        baseColor: ColorsItem.grey979797,
                        highlightColor: ColorsItem.grey606060,
                      ),
                      SizedBox(width: Dimens.SPACE_10.h),
                      Expanded(
                        child: Shimmer.fromColors(
                          period: Duration(seconds: 1),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorsItem.black32373D,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.SPACE_12.h)),
                            ),
                            height: Dimens.SPACE_30.h,
                          ),
                          baseColor: ColorsItem.grey979797,
                          highlightColor: ColorsItem.grey606060,
                        ),
                      ),
                    ],
                  ));
            }),
      ),
      baseColor: ColorsItem.grey979797,
      highlightColor: ColorsItem.grey606060,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_15.h),
                child: InkWell(
                  onTap: () => lobbyController.goToSearch(),
                  child: SearchBar(
                    hintText: S.of(context).label_search +
                        " " +
                        S.of(context).label_something,
                    border: Border.all(
                        color: ColorsItem.grey979797.withOpacity(0.5)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        Dimens.SPACE_40.h,
                      ),
                    ),
                    innerPadding: EdgeInsets.all(Dimens.SPACE_10.h),
                    outerPadding:
                        EdgeInsets.symmetric(horizontal: Dimens.SPACE_15.h),
                    controller: lobbyController.searchController,
                    focusNode: lobbyController.focusNodeSearch,
                    onChanged: (txt) {
                      lobbyController.streamController.add(txt);
                    },
                    onTap: () => lobbyController.goToSearch(),
                    endIcon: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: ColorsItem.greyB8BBBF,
                      size: Dimens.SPACE_18.h,
                    ),
                    textStyle: TextStyle(
                        color: Colors.white, fontSize: Dimens.SPACE_15.sp),
                    hintStyle: TextStyle(color: ColorsItem.grey8D9299),
                    buttonText: 'Clear',
                  ),
                ),
              ),
              SizedBox(height: Dimens.SPACE_5.h),
              lobbyController.isSearch &&
                      lobbyController.searchController.text.isNotEmpty
                  ? lobbyController.rooms.isNotEmpty ||
                          lobbyController.searchFoundInHQ
                      ? Center(
                          child: RichText(
                              text: TextSpan(
                                  text: S.of(context).lobby_search_result,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: ColorsItem.whiteFEFEFE,
                                    fontSize: Dimens.SPACE_12.sp,
                                  ),
                                  children: <TextSpan>[
                                TextSpan(
                                    text:
                                        "\"${lobbyController.searchController.text}\"",
                                    style: GoogleFonts.montserrat(
                                        color: ColorsItem.grey8D9299))
                              ])),
                        )
                      : Text(
                          S.of(context).label_search_empty,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.whiteFEFEFE,
                              fontSize: Dimens.SPACE_14.sp),
                        )
                  : SizedBox()
            ],
          ),
          // Container(
          //   height: 50,
          //   child: GraphQlCountries(lobbyController.countries),
          // ),
          lobbyController.isOutstandingTicketLoading
              ? _shimmerTicketOutstanding()
              : Column(
                  children: [
                    Container(
                      height: lobbyController.userTickets.isNotEmpty
                          ? MediaQuery.of(context).size.height / 2.3
                          : MediaQuery.of(context).size.height / 2.6,
                      child: PageView.builder(
                          controller: lobbyController.pageController2,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              lobbyController.userTickets.isNotEmpty ? 2 : 1,
                          onPageChanged: lobbyController.changePage,
                          itemBuilder: (context, index) {
                            if (lobbyController.userTickets.isNotEmpty) {
                              switch (index) {
                                case 0:
                                  return TicketOutstanding(
                                    onTap: (ticket) => lobbyController
                                        .goToTicketDetail(ticket),
                                    outstandingTicket:
                                        lobbyController.userTickets,
                                    onMoveToProject: () {
                                      lobbyController.gotoPorjectTab();
                                    },
                                    onSelectAllTicket: () {
                                      lobbyController.filterTicketOutstanding(
                                          Ticket.STATUS_LOW);
                                    },
                                    onSelectUnbreakTicket: () {
                                      lobbyController.filterTicketOutstanding(
                                          Ticket.STATUS_UNBREAK);
                                    },
                                    onSelectHighTicket: () {
                                      lobbyController.filterTicketOutstanding(
                                          Ticket.STATUS_HIGH);
                                    },
                                    onSelectNormalTicket: () {
                                      lobbyController.filterTicketOutstanding(
                                          Ticket.STATUS_NORMAL);
                                    },
                                    lobbyController: lobbyController,
                                  );
                                default:
                                  return IpDailyTask(
                                      lobbyController: lobbyController);
                              }
                            } else {
                              return IpDailyTask(
                                  lobbyController: lobbyController);
                            }
                          }),
                    ),
                    if (lobbyController.userTickets.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          2,
                          (index) {
                            return Container(
                              margin: EdgeInsets.only(right: Dimens.SPACE_5),
                              alignment: Alignment.bottomCenter,
                              height: Dimens.SPACE_9,
                              width: Dimens.SPACE_9,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lobbyController.currentPage == index
                                    ? ColorsItem.orangeCC6000
                                    : ColorsItem.whiteF2F2F2,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
          SizedBox(height: Dimens.SPACE_10.h),
          lobbyController.previousRoom != null &&
                  lobbyController.previousRoom?.name != null
              ? PreviousRoom(
                  previousRoom: lobbyController.previousRoom!,
                  onTap: (room) {
                    lobbyController.joinRoom(room);
                  },
                )
              : SizedBox(),
          SizedBox(height: Dimens.SPACE_10.h),
          lobbyController.isSearch &&
                  lobbyController.searchController.text.isNotEmpty &&
                  !lobbyController.searchFoundInHQ
              ? SizedBox()
              : lobbyController.roomHQ == null
                  ? SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              S.of(context).lobby_pilot_label,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsItem.grey858A93),
                            ),
                            Spacer(),
                            Showcase(
                                key: lobbyController.two,
                                showArrow: false,
                                disableAnimation: true,
                                contentPadding:
                                    EdgeInsets.all(Dimens.SPACE_12.h),
                                showcaseBackgroundColor: ColorsItem.black32373D,
                                titleTextStyle: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14.sp,
                                    color: ColorsItem.whiteFEFEFE,
                                    fontWeight: FontWeight.bold),
                                descTextStyle: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_12.sp,
                                    color: ColorsItem.greyB8BBBF),
                                onToolTipClick: () {
                                  lobbyController.pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                },
                                onTargetClick: () {
                                  lobbyController.pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                },
                                disposeOnTap: false,
                                animationDuration: Duration(seconds: 0),
                                title: S.of(context).tooltip_lobby_title_2,
                                description:
                                    S.of(context).tooltip_lobby_description_2,
                                child: SizedBox())
                          ],
                        ),
                        SizedBox(
                          height: Dimens.SPACE_15.h,
                        ),
                        Showcase(
                          key: lobbyController.one,
                          contentPadding: EdgeInsets.all(Dimens.SPACE_12.h),
                          disableAnimation: true,
                          animationDuration: Duration(seconds: 0),
                          showcaseBackgroundColor: ColorsItem.black32373D,
                          titleTextStyle: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14.sp,
                              color: ColorsItem.whiteFEFEFE,
                              fontWeight: FontWeight.bold),
                          descTextStyle: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12.sp,
                              color: ColorsItem.greyB8BBBF),
                          title: S.of(context).tooltip_lobby_title_1,
                          description:
                              S.of(context).tooltip_lobby_description_1,
                          child: DefaultRoomList(
                            roomName: lobbyController.roomHQ!.name!,
                            memberCount: lobbyController.roomHQ!.memberCount,
                            directJoin: () => lobbyController
                                .joinRoom(lobbyController.roomHQ),
                            canJoin: true,
                            canEdit: false,
                            isBookmarked: lobbyController
                                .isBookmarked(lobbyController.roomHQ!),
                            currentChannel: lobbyController.user.currentChannel,
                            userList: lobbyController.roomHQ!.participants!,
                            unreadChatsCount:
                                lobbyController.roomHQ!.unreadChats,
                            onCreateFlag: () {
                              lobbyController
                                  .addBookmark(lobbyController.roomHQ!);
                            },
                            onDeleteFlag: () {
                              lobbyController
                                  .removeBookmark(lobbyController.roomHQ!);
                            },
                            onReportRoom: () {
                              lobbyController
                                  .reportRoom(lobbyController.roomHQ!);
                            },
                          ),
                        ),
                        SizedBox(
                          height: Dimens.SPACE_20.h,
                        ),
                      ],
                    ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        S.of(context).lobby_workspace_label,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_14.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsItem.grey858A93),
                      ),
                      SizedBox(height: Dimens.SPACE_8.h),
                      lobbyController.isSearch
                          ? SizedBox()
                          : DropdownButton<RoomsFilterType>(
                              alignment: AlignmentDirectional.centerStart,
                              value: lobbyController.roomsFilterType,
                              isDense: true,
                              underline: Container(
                                height: 2.0,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: ColorsItem.urlColor,
                                      width: 0.0,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownColor: ColorsItem.black020202,
                              iconEnabledColor: ColorsItem.urlColor,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsItem.green00A1B0),
                              items: <RoomsFilterType>[
                                RoomsFilterType.All,
                                RoomsFilterType.Favorite,
                                RoomsFilterType.Active,
                                RoomsFilterType.Joined,
                                RoomsFilterType.Archive
                              ].map((RoomsFilterType value) {
                                return DropdownMenuItem<RoomsFilterType>(
                                  value: value,
                                  child: Container(
                                    child: Text(value.toString().split('.')[1]),
                                  ),
                                );
                              }).toList(),
                              onChanged: (type) {
                                lobbyController.filter(type!);
                              },
                            )
                    ],
                  ),
                  ButtonDefault(
                    buttonIcon: Icon(
                      Icons.add,
                      color: ColorsItem.black020202,
                    ),
                    buttonText: S.of(context).label_room,
                    buttonTextColor: ColorsItem.black020202,
                    buttonColor: ColorsItem.green00A1B0,
                    buttonLineColor: ColorsItem.green00A1B0,
                    paddingHorizontal: Dimens.SPACE_14.h,
                    paddingVertical: Dimens.SPACE_6.h,
                    onTap: () {
                      lobbyController.goToForm(FormType.create);
                    },
                  ),
                ],
              ),
              lobbyController.rooms.isNotEmpty
                  ? ListView.builder(
                      itemCount: lobbyController.rooms.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height: Dimens.SPACE_15.h),
                            DefaultRoomList(
                              roomName: lobbyController.rooms[index].name!,
                              memberCount:
                                  lobbyController.rooms[index].memberCount,
                              directJoin: () => lobbyController
                                  .joinRoom(lobbyController.rooms[index]),
                              canJoin: lobbyController
                                  .canJoinRoom(lobbyController.rooms[index]),
                              canEdit: lobbyController
                                  .canJoinRoom(lobbyController.rooms[index]),
                              currentChannel:
                                  lobbyController.user.currentChannel,
                              userList:
                                  lobbyController.rooms[index].participants,
                              unreadChatsCount:
                                  lobbyController.rooms[index].unreadChats,
                              isBookmarked: lobbyController
                                  .isBookmarked(lobbyController.rooms[index]),
                              isDeleted: lobbyController.rooms[index].isDeleted,
                              restoreRoom: () => showRestoreRoomDialog(
                                  lobbyController.rooms[index].id, context),
                              onEditRoom: () {
                                lobbyController.goToForm(
                                  FormType.edit,
                                  room: lobbyController.rooms[index],
                                );
                              },
                              onCreateFlag: () {
                                lobbyController
                                    .addBookmark(lobbyController.rooms[index]);
                              },
                              onDeleteFlag: () {
                                lobbyController.removeBookmark(
                                    lobbyController.rooms[index]);
                              },
                              onReportRoom: () {
                                lobbyController
                                    .reportRoom(lobbyController.rooms[index]);
                              },
                            ),
                            index == lobbyController.rooms.length - 1
                                ? SizedBox(height: Dimens.SPACE_15.h)
                                : SizedBox(),
                          ],
                        );
                      })
                  : SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
