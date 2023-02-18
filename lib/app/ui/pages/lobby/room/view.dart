import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/search_item.dart';
import 'package:mobile_sev2/app/ui/assets/widget/voice_avatar.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/calendar/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/member/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/stickit/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/ticket/args.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../pages.dart';
import 'controller.dart';

class LobbyRoomPage extends View {
  final Object? arguments;

  LobbyRoomPage({this.arguments});

  @override
  _LobbyRoomState createState() => _LobbyRoomState(
      AppComponent.getInjector().get<LobbyRoomController>(), arguments);
}

class _LobbyRoomState extends ViewState<LobbyRoomPage, LobbyRoomController> {
  LobbyRoomController _controller;

  _LobbyRoomState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<LobbyRoomController>(
            builder: (context, controller) {
          return ShowCaseWidget(
            onComplete: (index, key) {
              if (key == _controller.six) {
                _controller.userData.voiceTooltipFinished = true;
                _controller.userData.save();
              }
            },
            autoPlay: false,
            autoPlayLockEnable: false,
            builder: Builder(builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  if (_controller.isSearch) {
                    _controller.cancelSearch();
                    return false;
                  }
                  await _controller.callDispose();
                  Navigator.pop(context);
                  return true;
                },
                child: Scaffold(
                  key: globalKey,
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    toolbarHeight: MediaQuery.of(context).size.height / 10,
                    flexibleSpace: _controller.isSearch
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_20,
                                vertical: Dimens.SPACE_10),
                            height: MediaQuery.of(context).size.height / 10,
                            child: SearchBar(
                              hintText: S.of(context).label_search +
                                  " file, task, stickits or event",
                              border: Border.all(
                                  color:
                                      ColorsItem.grey979797.withOpacity(0.5)),
                              borderRadius: BorderRadius.all(
                                  const Radius.circular(Dimens.SPACE_40)),
                              innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                              outerPadding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_15),
                              controller: _controller.searchController,
                              focusNode: _controller.focusNodeSearch,
                              onChanged: (txt) {
                                _controller.streamController.add(txt);
                              },
                              clearTap: () {
                                _controller.cancelSearch();
                              },
                              onTap: () => _controller.onSearch(true),
                              endIcon: FaIcon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: ColorsItem.greyB8BBBF,
                                size: Dimens.SPACE_18,
                              ),
                              textStyle: TextStyle(fontSize: Dimens.SPACE_15),
                              hintStyle:
                                  TextStyle(color: ColorsItem.grey8D9299),
                              buttonText: 'Cancel',
                            ),
                          )
                        : SimpleAppBar(
                            toolbarHeight:
                                MediaQuery.of(context).size.height / 10,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            prefix: IconButton(
                              icon: FaIcon(FontAwesomeIcons.chevronLeft),
                              onPressed: () async {
                                if (_controller.pageController.page == 1) {
                                  _controller.pageController.previousPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.linear);
                                } else {
                                  await _controller.callDispose();
                                  Navigator.pop(context);
                                }
                              },
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () =>
                                      _controller.gotToChannelSetting(),
                                  child: Text(
                                    _controller.room.name!,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: Dimens.SPACE_20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: Dimens.SPACE_4),
                                _controller.room.memberCount != null
                                    ? Text(
                                        "${_controller.room.memberCount} ${S.of(context).room_detail_member_title}",
                                        style: GoogleFonts.montserrat(
                                            color: ColorsItem.grey8D9299,
                                            fontSize: Dimens.SPACE_12))
                                    : SizedBox(),
                              ],
                            ),
                            // suffix: SizedBox(
                            //   width: Dimens.SPACE_40,
                            //   child: InkWell(
                            //     onTap: () => _controller.onSearch(true),
                            //     child: Container(
                            //         child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                            //             color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_18)),
                            //   ),
                            // ),
                            suffix: Container(
                              padding: EdgeInsets.only(right: 24.0),
                              child: Row(
                                children: [
                                  PopupMenuButton(
                                    onSelected: (value) {
                                      if (value == 0) {
                                        _controller.onSearch(true);
                                      } else {
                                        showCustomAlertDialog(
                                            context: context,
                                            title: S
                                                .of(context)
                                                .room_delete_conversation_title,
                                            subtitle: S
                                                .of(context)
                                                .room_delete_conversation_subtitle,
                                            cancelButtonText: S
                                                .of(context)
                                                .label_cancel
                                                .toUpperCase(),
                                            confirmButtonText: S
                                                .of(context)
                                                .label_delete
                                                .toUpperCase(),
                                            onCancel: () =>
                                                Navigator.pop(context),
                                            onConfirm: () {
                                              _controller.deleteRoomChat();
                                              Navigator.pop(context);
                                            });
                                      }
                                    },
                                    child: FaIcon(
                                        FontAwesomeIcons.ellipsisVertical,
                                        size: Dimens.SPACE_18),
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                          value: 0,
                                          child: Row(
                                            children: [
                                              FaIcon(
                                                  FontAwesomeIcons
                                                      .magnifyingGlass,
                                                  size: Dimens.SPACE_18),
                                              SizedBox(width: Dimens.SPACE_8),
                                              Expanded(
                                                  child: Text(
                                                      S
                                                          .of(context)
                                                          .label_search,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: Dimens
                                                                  .SPACE_14)))
                                            ],
                                          )),
                                      PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              FaIcon(FontAwesomeIcons.trashCan,
                                                  size: Dimens.SPACE_18),
                                              SizedBox(width: Dimens.SPACE_8),
                                              Expanded(
                                                  child: Text(
                                                      S
                                                          .of(context)
                                                          .label_delete,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: Dimens
                                                                  .SPACE_14)))
                                            ],
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                  ),
                  body: _controller.isSearch
                      ? Container(
                          child: searchInRoom(),
                        )
                      : Container(
                          child: _controller.isLoading
                              ? Container(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1.0,
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: Dimens.SPACE_20,
                                        ),
                                        Expanded(
                                          // child: PageView(
                                          //   controller:
                                          //       _controller.pageController,
                                          //   onPageChanged: (int page) =>
                                          //       _controller.onPageChanged(page),
                                          //   children: getParticipantsPageView(),
                                          // ),
                                          child: _buildMemberPageView(),
                                        ),
                                        SizedBox(height: Dimens.SPACE_20),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimens.SPACE_20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              _controller.pageViewChildrenCount >
                                                      1
                                                  ? Container(
                                                      child: Row(children: [
                                                        for (int i = 0;
                                                            i <
                                                                _controller
                                                                    .pageViewChildrenCount;
                                                            i++)
                                                          i ==
                                                                  _controller
                                                                      .currentPage
                                                              ? _buildPageIndicator(
                                                                  i, true)
                                                              : _buildPageIndicator(
                                                                  i, false)
                                                      ]),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              Dimens.SPACE_50,
                                              Dimens.SPACE_25,
                                              Dimens.SPACE_50,
                                              Dimens.SPACE_25),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(
                                                    Dimens.SPACE_6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              Dimens.SPACE_40)),
                                                  border: Border.all(
                                                      color: ColorsItem
                                                          .white9E9E9E),
                                                ),
                                                child: IconButton(
                                                    icon: !_controller.isMuted
                                                        ? FaIcon(
                                                            FontAwesomeIcons
                                                                .microphoneLines,
                                                            size:
                                                                Dimens.SPACE_20)
                                                        : FaIcon(
                                                            FontAwesomeIcons
                                                                .microphoneLinesSlash,
                                                            size: Dimens
                                                                .SPACE_20),
                                                    onPressed: () {
                                                      _controller.setMute();
                                                    }),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(
                                                    Dimens.SPACE_6),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              Dimens.SPACE_40)),
                                                  border: Border.all(
                                                      color: ColorsItem
                                                          .white9E9E9E),
                                                ),
                                                child: IconButton(
                                                    icon: FaIcon(
                                                        !_controller
                                                                .isSpeakerEnabled
                                                            ? FontAwesomeIcons
                                                                .volumeHigh
                                                            : FontAwesomeIcons
                                                                .phoneVolume,
                                                        size: Dimens.SPACE_25),
                                                    onPressed: () {
                                                      _controller.setSpeaker();
                                                    }),
                                              ),
                                              // Container(
                                              //     padding: EdgeInsets.all(Dimens.SPACE_6),
                                              //     decoration: ShapeDecoration(
                                              //       color: ColorsItem.black191C21,
                                              //       shape: CircleBorder(),
                                              //     ),
                                              //     child: IconButton(
                                              //         icon: SvgPicture.asset(ImageItem.IC_SCREEN_SHARE,
                                              //             color: ColorsItem.grey8D9299),
                                              //         onPressed: () {})),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.all(Dimens.SPACE_25),
                                          child: Showcase(
                                            key: _controller.six,
                                            contentPadding:
                                                EdgeInsets.all(Dimens.SPACE_12),
                                            disableAnimation: true,
                                            animationDuration:
                                                Duration(seconds: 0),
                                            titleTextStyle:
                                                GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14,
                                              color: ColorsItem.whiteFEFEFE,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            descTextStyle:
                                                GoogleFonts.montserrat(
                                                    fontSize: Dimens.SPACE_12,
                                                    color:
                                                        ColorsItem.greyB8BBBF),
                                            title: S
                                                .of(context)
                                                .tooltip_voice_title_2,
                                            description: S
                                                .of(context)
                                                .tooltip_voice_description_2,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: Dimens.SPACE_20,
                                                vertical: Dimens.SPACE_15,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.SPACE_60),
                                                border: Border.all(
                                                    color:
                                                        ColorsItem.white9E9E9E),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Colors.black54,
                                                //     blurRadius: 8.0,
                                                //     spreadRadius: 1.0,
                                                //     offset: Offset(0,
                                                //         4.0), // shadow direction: bottom right
                                                //   )
                                                // ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                      onTap: () => _controller
                                                          .goToRoomChat(),
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .solidCommentDots,
                                                            ),
                                                            SizedBox(
                                                                height: Dimens
                                                                    .SPACE_8),
                                                            Text(
                                                              S
                                                                  .of(context)
                                                                  .main_chat_tab_title,
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                      fontSize:
                                                                          Dimens
                                                                              .SPACE_12),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                      onTap: () =>
                                                          Navigator.pushNamed(
                                                              context,
                                                              Pages.roomTicket,
                                                              arguments:
                                                                  RoomTicketArgs(
                                                                      _controller
                                                                          .room)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FaIcon(
                                                              FontAwesomeIcons
                                                                  .listCheck),
                                                          SizedBox(
                                                              height: Dimens
                                                                  .SPACE_8),
                                                          Text(
                                                            S
                                                                .of(context)
                                                                .main_task_tab_title,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize: Dimens
                                                                        .SPACE_12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                      onTap: () =>
                                                          Navigator.pushNamed(
                                                              context,
                                                              Pages
                                                                  .roomCalendar,
                                                              arguments:
                                                                  RoomCalendarArgs(
                                                                      _controller
                                                                          .room)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FaIcon(
                                                              FontAwesomeIcons
                                                                  .calendarDay),
                                                          SizedBox(
                                                              height: Dimens
                                                                  .SPACE_8),
                                                          Text(
                                                            S
                                                                .of(context)
                                                                .label_calendar,
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize: Dimens
                                                                        .SPACE_12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: InkWell(
                                                      onTap: () =>
                                                          _showMoreBottomSheet(),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FaIcon(
                                                            FontAwesomeIcons
                                                                .ellipsisVertical,
                                                          ),
                                                          SizedBox(
                                                              height: Dimens
                                                                  .SPACE_8),
                                                          Text(
                                                            "More",
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    fontSize: Dimens
                                                                        .SPACE_12),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                ),
              );
            }),
          );
        }),
      );

  _showMoreBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Dimens.SPACE_35),
                        topRight: Radius.circular(Dimens.SPACE_35))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(Dimens.SPACE_25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).room_detail_label,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_18,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: FaIcon(FontAwesomeIcons.xmark,
                                size: Dimens.SPACE_18),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                        color: ColorsItem.grey666B73, height: Dimens.SPACE_2),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Pages.roomStickit,
                                  arguments: RoomStickitArgs(_controller.room));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: Dimens.SPACE_12,
                                top: Dimens.SPACE_15,
                                bottom: Dimens.SPACE_15,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: Dimens.SPACE_50,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: <Widget>[
                                        FaIcon(FontAwesomeIcons.thumbtack),
                                        _controller.isUnRead
                                            ? Positioned(
                                                left: Dimens.SPACE_9,
                                                bottom: Dimens.SPACE_16,
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      Dimens.SPACE_2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.SPACE_7),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: Dimens.SPACE_1),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: Dimens.SPACE_10,
                                                    minHeight: Dimens.SPACE_10,
                                                  ),
                                                ),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                  Text(S.of(context).label_stickit,
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_18)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Pages.roomFile,
                                arguments: RoomFileArgs(
                                  room: _controller.room,
                                  isRoom: true,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: Dimens.SPACE_12,
                                top: Dimens.SPACE_15,
                                bottom: Dimens.SPACE_15,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: Dimens.SPACE_50,
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.paperclip),
                                  ),
                                  Text(S.of(context).room_detail_files_title,
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_18)),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Pages.roomMember,
                                  arguments: RoomMemberArgs(_controller.room));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: Dimens.SPACE_12,
                                top: Dimens.SPACE_15,
                                bottom: Dimens.SPACE_15,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: Dimens.SPACE_50,
                                    alignment: Alignment.center,
                                    child: FaIcon(FontAwesomeIcons.users),
                                  ),
                                  Text(S.of(context).room_member_label,
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_18)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _buildPageIndicator(int page, bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 375),
      margin: EdgeInsets.symmetric(horizontal: Dimens.SPACE_6),
      height: Dimens.SPACE_8,
      width: Dimens.SPACE_8,
      decoration: BoxDecoration(
        color: isCurrentPage ? ColorsItem.blue66C7D0 : ColorsItem.grey555555,
        borderRadius: BorderRadius.circular(Dimens.SPACE_12),
      ),
    );
  }

  Widget searchInRoom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.SPACE_10),
        _controller.isSearch && (_controller.searchController.text.isNotEmpty)
            ? Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      top: Dimens.SPACE_5,
                      bottom: Dimens.SPACE_20,
                      left: Dimens.SPACE_20,
                      right: Dimens.SPACE_20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _controller.isSearch &&
                              _controller.searchController.text.isNotEmpty
                          ? RichText(
                              text: TextSpan(
                                text: S.of(context).search_found_placeholder,
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    color: ColorsItem.grey8D9299),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '"${_controller.searchController.text}"',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorsItem.grey555555)),
                                ],
                              ),
                            )
                          : SizedBox(),
                      !_controller.isSearchFinished
                          ? Container(
                              margin: EdgeInsets.only(top: Dimens.SPACE_50),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _controller.searchResults.isNotEmpty &&
                                  _controller.isSearchFinished
                              ? Expanded(
                                  child: ListView.builder(
                                      controller:
                                          _controller.listScrollController,
                                      itemCount:
                                          _controller.searchResults.length,
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            _controller.searchResults.length) {
                                          return Center(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Dimens.SPACE_12),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                        var object =
                                            _controller.searchResults[index];
                                        if (object is Calendar) {
                                          return InkWell(
                                            onTap: () {
                                              _controller
                                                  .goToEventDetail(object);
                                            },
                                            child: SearchItem(
                                              title: object.getFullName()!,
                                              desc:
                                                  "Acara · ${_controller.dateUtil.format('d MMMM yyyy', object.startTime)}",
                                              verticalPadding: Dimens.SPACE_16,
                                              thisIcon: FaIcon(
                                                FontAwesomeIcons.calendarDay,
                                                color: ColorsItem.grey666B73,
                                                size: Dimens.SPACE_12,
                                              ),
                                            ),
                                          );
                                        } else if (object is Ticket) {
                                          return InkWell(
                                            onTap: () {
                                              _controller
                                                  .goToTicketDetail(object);
                                            },
                                            child: SearchItem(
                                              title: object.getFullName()!,
                                              desc:
                                                  "Tugas · ${object.ticketStatus.parseToString().ucwords()}",
                                              verticalPadding: Dimens.SPACE_16,
                                              thisIcon: FaIcon(
                                                FontAwesomeIcons.listCheck,
                                                color: ColorsItem.grey666B73,
                                                size: Dimens.SPACE_12,
                                              ),
                                            ),
                                          );
                                        } else if (object is Stickit) {
                                          return InkWell(
                                            onTap: () {
                                              _controller.goToDetail(object);
                                            },
                                            child: SearchItem(
                                              title: object.getFullName()!,
                                              desc:
                                                  "Stickit · ${object.stickitType}",
                                              verticalPadding: Dimens.SPACE_16,
                                              thisIcon: FaIcon(
                                                FontAwesomeIcons.listCheck,
                                                color: ColorsItem.grey666B73,
                                                size: Dimens.SPACE_12,
                                              ),
                                            ),
                                          );
                                        } else if (object is File) {
                                          return SearchItem(
                                            title: object.title,
                                            desc:
                                                "File · ${object.fileType.parseToString().ucwords()}",
                                            verticalPadding: Dimens.SPACE_16,
                                            isFile: true,
                                            isAlreadyDownload: _controller
                                                .downloader
                                                .isAlreadyDownloaded(
                                                    object.url),
                                            onOpen: () => _controller.downloader
                                                .openFile(object.url),
                                            onDownload: () => _controller
                                                .downloadOrOpenFile(object.url),
                                            thisIcon: FaIcon(
                                              FontAwesomeIcons.fileZipper,
                                              color: ColorsItem.grey666B73,
                                              size: Dimens.SPACE_12,
                                            ),
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      }),
                                )
                              : Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            S
                                                .of(context)
                                                .search_data_not_found_title,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            S
                                                .of(context)
                                                .search_data_not_found_description,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                color: ColorsItem.grey8D9299),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  getParticipantsPageView() {
    _controller.pageViewChildren.clear();

    for (int i = 0; i < _controller.pageViewChildrenCount; i++) {
      int start = i == 0 ? i : _controller.limitParticipantsPerPage * i;
      int end = i == 0 &&
              _controller.participants.length >=
                  _controller.limitParticipantsPerPage
          ? _controller.limitParticipantsPerPage
          : i == 1 &&
                  _controller.participants.length >
                      _controller.limitParticipantsPerPage
              ? _controller.limitParticipantsPerPage * 2
              : _controller.participants.length <=
                      _controller.limitParticipantsPerPage
                  ? _controller.participants.length
                  : _controller.participants.length;

      List<User> participantsInPageView =
          _controller.participants.sublist(start, end);
      print(
          "getParticipantsPageView: called $start $end ${participantsInPageView.length}");
      _controller.pageViewChildren.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_30),
          child: GridView.builder(
              itemCount: participantsInPageView.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                print(
                    "isMuted: ${_controller.checkIsMuted(participantsInPageView[index].id)}");
                return VoiceAvatar(
                  name: participantsInPageView[index].fullName!,
                  avatar: participantsInPageView[index].avatar!,
                  isMuted: _controller
                      .checkIsMuted(participantsInPageView[index].id),
                  isTalking: _controller.isTalking,
                  isRaisedHand: _controller.isRaisedHand,
                  isDeafen: _controller.isDeafen,
                );
              }),
        ),
      );
      print("getParticipantsPageView: called after addition");
    }
    return _controller.pageViewChildren;
  }

  Widget _buildMemberPageView() {
    // child: PageView(
    //   controller:
    //       _controller.pageController,
    //   onPageChanged: (int page) =>
    //       _controller.onPageChanged(page),
    //   children: getParticipantsPageView(),
    // ),
    return PageView.builder(
      itemCount: (_controller.participants.length /
              _controller.limitParticipantsPerPage)
          .ceil(),
      controller: _controller.pageController,
      onPageChanged: (int page) => _controller.onPageChanged(page),
      itemBuilder: (context, index) {
        int start = index * 6;
        int end = (index + 1) * 6;
        if (end > _controller.participants.length)
          end = _controller.participants.length;
        List<User> participantsInPageView = _controller.participants.sublist(
          start,
          end,
        );
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_30),
          child: GridView.builder(
              itemCount: participantsInPageView.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                return VoiceAvatar(
                  name: participantsInPageView[index].fullName!,
                  avatar: participantsInPageView[index].avatar!,
                  isMuted: _controller
                      .checkIsMuted(participantsInPageView[index].id),
                  isTalking: _controller.isTalking,
                  isRaisedHand: _controller.isRaisedHand,
                  isDeafen: _controller.isDeafen,
                );
              }),
        );
      },
    );
  }
}
