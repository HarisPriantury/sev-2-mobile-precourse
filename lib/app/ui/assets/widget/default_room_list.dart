import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/misc/utils.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/domain/user.dart';

class DefaultRoomList extends StatelessWidget {
  final String roomName;
  final String? memberCount;
  final void Function()? directJoin;
  final bool canJoin;
  final bool canEdit;
  final String? currentChannel;
  final List<User>? userList;
  final int unreadChatsCount;
  final void Function()? restoreRoom;
  final bool? isDeleted;
  final bool isBookmarked;
  final void Function()? onCreateFlag;
  final void Function()? onDeleteFlag;
  final void Function()? onEditRoom;
  final void Function() onReportRoom;

  const DefaultRoomList({
    required this.roomName,
    required this.memberCount,
    required this.directJoin,
    required this.canJoin,
    required this.canEdit,
    required this.currentChannel,
    required this.userList,
    required this.unreadChatsCount,
    required this.onReportRoom,
    this.isDeleted = false,
    this.restoreRoom,
    this.isBookmarked = false,
    this.onCreateFlag,
    this.onDeleteFlag,
    this.onEditRoom,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: Theme.of(context),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(Dimens.SPACE_20.h),
              decoration: BoxDecoration(
                color: ColorsItem.grey979797,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimens.SPACE_10.h),
                  topRight: Radius.circular(
                    Dimens.SPACE_10.h,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isBookmarked
                      ? FaIcon(
                          FontAwesomeIcons.solidStar,
                          color: ColorsItem.orangeFB9600,
                          size: Dimens.SPACE_16.h,
                        )
                      : SizedBox(),
                  SizedBox(width: isBookmarked ? Dimens.SPACE_4.h : null),
                  Expanded(
                    child: Container(
                      child: Text(
                        roomName,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  isDeleted!
                      ? InkWell(
                          onTap: restoreRoom,
                          child: Text(
                            S.of(context).restoreRoom,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12.sp,
                              color: ColorsItem.orangeFB9600,
                            ),
                          ),
                        )
                      : Text(
                          "${memberCount ?? "0/0"} ${S.of(context).rooms_member_label}",
                          style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_13.sp,
                          ),
                        ),
                  SizedBox(width: Dimens.SPACE_4.h),
                  _popMenu(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(Dimens.SPACE_15.h),
              decoration: BoxDecoration(
                border:
                    Border.all(color: ColorsItem.grey979797.withOpacity(0.5)),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Dimens.SPACE_10.h),
                  bottomRight: Radius.circular(
                    Dimens.SPACE_10.h,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: Dimens.SPACE_15.h),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: ColorsItem.grey979797),
                      ),
                    ),
                    child: userList == null
                        ? Center(
                            child: Text(
                              S.of(context).label_participant_empty,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14.sp,
                                  color: ColorsItem.whiteFEFEFE),
                            ),
                          )
                        : userList!.isNotEmpty
                            ? Wrap(
                                alignment: WrapAlignment.end,
                                textDirection: TextDirection.rtl,
                                spacing: -15.0,
                                children: List.generate(
                                    userList!.length > 11
                                        ? 12
                                        : userList!.length,
                                    (idx) => Container(
                                        margin: EdgeInsets.only(
                                            top: Dimens.SPACE_5.h,
                                            left: idx == 16 ? 15.0 : 0.0),
                                        decoration: BoxDecoration(
                                          color: ColorsItem.grey606060,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: Dimens.SPACE_2.h,
                                              color: ColorsItem.whiteFEFEFE),
                                        ),
                                        child: idx == 16
                                            ? Padding(
                                                padding: const EdgeInsets.all(
                                                    Dimens.SPACE_12),
                                                child: Text(
                                                  "${(userList!.length - 15)}+",
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        ColorsItem.whiteFEFEFE,
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  userList![idx].avatar!,
                                                ),
                                                radius: Utils.isTablet()
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        20.5.h
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        20.5.w,
                                              ))),
                              )
                            : Center(
                                child: Text(
                                  S.of(context).label_participant_empty,
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14.sp,
                                    color: ColorsItem.whiteFEFEFE,
                                  ),
                                ),
                              ),
                  ),
                  SizedBox(height: Dimens.SPACE_10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: Dimens.SPACE_5.h,
                            backgroundColor: isDeleted!
                                ? ColorsItem.grey8C8C8C
                                : userList == null
                                    ? ColorsItem.redDA1414
                                    : userList!.isNotEmpty
                                        ? ColorsItem.green219653
                                        : ColorsItem.redDA1414,
                          ),
                          SizedBox(
                            width: Dimens.SPACE_5.h,
                          ),
                          Text(
                            isDeleted!
                                ? S.of(context).label_archive
                                : userList == null
                                    ? S.of(context).lobby_inactive_label
                                    : userList!.isEmpty
                                        ? S.of(context).lobby_inactive_label
                                        : currentChannel == roomName
                                            ? S.of(context).lobby_joining_label
                                            : S.of(context).lobby_active_label,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12.sp,
                            ),
                          )
                        ],
                      ),
                      unreadChatsCount > 0 && canJoin
                          ? Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: !isDeleted!
                                    ? Text(
                                        "${unreadChatsCount > 5 ? "5+" : unreadChatsCount} new messages",
                                        style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_12.sp,
                                          color: ColorsItem.yellowFFA600,
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                            )
                          : SizedBox(),
                      if (!isDeleted!)
                        ButtonDefault(
                          buttonText: S.of(context).lobby_enter_label,
                          buttonTextColor: canJoin
                              ? ColorsItem.black
                              : ColorsItem.grey8D9299,
                          buttonColor: canJoin
                              ? ColorsItem.orangeFB9600
                              : ColorsItem.grey606060,
                          buttonLineColor: Colors.transparent,
                          onTap: canJoin ? directJoin : null,
                          paddingHorizontal: Dimens.SPACE_10.h,
                          radius: Dimens.SPACE_20.h,
                        )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _popMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          if (isBookmarked && onDeleteFlag != null) {
            onDeleteFlag!();
          } else if (!isBookmarked && onCreateFlag != null) {
            onCreateFlag!();
          }
        } else if (value == 1) {
          if (onEditRoom != null) {
            onEditRoom!();
          }
        } else if (value == 2) {
          onReportRoom();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: Dimens.SPACE_20.h),
        child: FaIcon(
          FontAwesomeIcons.ellipsisVertical,
          size: Dimens.SPACE_18.h,
        ),
      ),
      itemBuilder: (context) => _generatePopUp(context),
    );
  }

  List<PopupMenuEntry<int>> _generatePopUp(BuildContext context) {
    List<PopupMenuEntry<int>> popup = [];
    popup.add(
      PopupMenuItem(
        value: 0,
        child: Text(
          isBookmarked
              ? S.of(context).lobby_remove_bookmark_room
              : S.of(context).lobby_add_bookmark_room,
          style: GoogleFonts.montserrat(
            fontSize: Dimens.SPACE_14.sp,
          ),
        ),
      ),
    );

    if (canEdit) {
      popup.add(
        PopupMenuItem(
          value: 1,
          child: Text(
            S.of(context).lobby_edit_room,
            style: GoogleFonts.montserrat(
              fontSize: Dimens.SPACE_14.sp,
            ),
          ),
        ),
      );
    }
    // 22 April 2022: Hide Report Room
    // popup.add(
    //   PopupMenuItem(
    //     value: 2,
    //     child: Text(
    //       "${S.of(context).label_report} Room",
    //       style: GoogleFonts.montserrat(
    //         color: ColorsItem.whiteE0E0E0,
    //         fontSize: Dimens.SPACE_14.sp,
    //       ),
    //     ),
    //   ),
    // );
    return popup;
  }
}
