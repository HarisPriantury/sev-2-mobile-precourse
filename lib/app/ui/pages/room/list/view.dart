import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/adaptive_listview.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/message_list_item.dart';
import 'package:mobile_sev2/app/ui/pages/room/list/controller.dart';
import 'package:shimmer/shimmer.dart';

class RoomsPage extends View {
  final Object? arguments;

  RoomsPage({this.arguments});

  @override
  _RoomsState createState() =>
      _RoomsState(AppComponent.getInjector().get<RoomsController>(), arguments);
}

class _RoomsState extends ViewState<RoomsPage, RoomsController> {
  RoomsController _controller;
  DateTime currentBackPressTime = DateTime.now();
  _RoomsState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<RoomsController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_10),
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  prefix: SizedBox(),
                  titleMargin: 0,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).main_chat_tab_title,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_18,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: Dimens.SPACE_4),
                      Text(
                        S.of(context).room_subtitle,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  suffix: InkWell(
                    onTap: () {
                      _controller.gotoUserList();
                    },
                    child: Container(
                        height: Dimens.SPACE_25,
                        width: Dimens.SPACE_25,
                        child: FaIcon(FontAwesomeIcons.solidPenToSquare,
                            color: ColorsItem.orangeFB9600,
                            size: Dimens.SPACE_18)),
                  ),
                ),
              ),
              body: _controller.isLoading
                  ? _shimmerRoomList()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(Dimens.SPACE_20),
                          child: SearchBar(
                            hintText: S.of(context).room_search_conversation,
                            border: Border.all(
                                color: ColorsItem.grey979797.withOpacity(0.5)),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.SPACE_40)),
                            innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                            outerPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_15),
                            controller: _controller.searchController,
                            focusNode: _controller.focusNodeSearch,
                            onChanged: (txt) {
                              _controller.streamController.add(txt);
                            },
                            clear: true,
                            clearTap: () => _controller.clearSearch(),
                            onTap: () => _controller.onSearch(true),
                            endIcon: FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: ColorsItem.greyB8BBBF,
                              size: Dimens.SPACE_18,
                            ),
                            textStyle: TextStyle(fontSize: 15.0),
                            hintStyle: TextStyle(color: ColorsItem.grey8D9299),
                            buttonText: 'Clear',
                          ),
                        ),
                        _controller.isSearch &&
                                _controller.searchController.text.isNotEmpty
                            ? Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimens.SPACE_20),
                                      child: RichText(
                                        text: TextSpan(
                                          text: S
                                              .of(context)
                                              .search_found_placeholder,
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14,
                                              color: ColorsItem.grey8D9299),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text:
                                                    '"${_controller.searchController.text}"',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_12),
                                    _controller.searchedRooms.isNotEmpty
                                        ? Expanded(
                                            child: ListView.builder(
                                                itemCount: _controller
                                                    .searchedRooms.length,
                                                itemBuilder: (context, index) {
                                                  var room = _controller
                                                      .searchedRooms[index];
                                                  return MessageListItem(
                                                    username: _controller
                                                        .getOtherMember(room)
                                                        .getFullName()!,
                                                    message: room.lastMessage!,
                                                    avatar: _controller
                                                        .getOtherMember(room)
                                                        .avatar!,
                                                    time: _controller
                                                        .formatChatTime(room
                                                            .lastMessageCreatedAt),
                                                    unreadMessageCount:
                                                        room.unreadChats,
                                                    statusColor: _controller
                                                        .getOtherMemberStatusColor(
                                                            room),
                                                    onTap: () {
                                                      _controller
                                                          .joinRoom(room);
                                                    },
                                                  );
                                                }),
                                          )
                                        : Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
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
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(
                                                    S
                                                        .of(context)
                                                        .search_data_not_found_description,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .grey8D9299),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: AdaptiveListview(
                                  onRefresh: () => _controller.reload(),
                                  item: (context, index) {
                                    var room = _controller.getRooms()[index];
                                    return MessageListItem(
                                      username: _controller
                                          .getOtherMember(room)
                                          .getFullName()!,
                                      message: room.lastMessage!,
                                      avatar: _controller
                                          .getOtherMember(room)
                                          .avatar!,
                                      time: _controller.formatChatTime(
                                          room.lastMessageCreatedAt),
                                      unreadMessageCount: room.unreadChats,
                                      statusColor: _controller
                                          .getOtherMemberStatusColor(room),
                                      onTap: () {
                                        _controller.joinRoom(room);
                                      },
                                    );
                                  },
                                  itemCount: _controller.getRooms().length,
                                ),
                              )
                      ],
                    ),
            ),
          );
        }),
      );

  Future<bool> showConfirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap Again To Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  // MARK: DELETE THIS WHEN MODULE POS WAS READY TO DEVELOP
  _popMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0)
          _controller.gotoShop();
        else
          _controller.goToFormAddProductLionParcel();
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
          child:
              FaIcon(FontAwesomeIcons.ellipsisVertical, size: Dimens.SPACE_18)),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.cartShopping, size: Dimens.SPACE_18),
                SizedBox(width: Dimens.SPACE_8),
                Expanded(
                  child: Text(
                    "GOTO FORM USER",
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_14,
                    ),
                  ),
                )
              ],
            )),
        PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.solidPenToSquare,
                    size: Dimens.SPACE_18),
                SizedBox(width: Dimens.SPACE_8),
                Expanded(
                  child: Text(
                    "GOTO FORM PRODUCT",
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_14,
                    ),
                  ),
                )
              ],
            )),
      ],
    );
  }

  _shimmerRoomList() {
    Container(
      color: ColorsItem.black1F2329,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              period: Duration(seconds: 1),
              child: Container(
                margin: EdgeInsets.all(Dimens.SPACE_20),
                width: double.infinity,
                height: Dimens.SPACE_35,
                decoration: BoxDecoration(
                  color: ColorsItem.black32373D,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.SPACE_40)),
                ),
              ),
              baseColor: ColorsItem.grey979797,
              highlightColor: ColorsItem.grey606060,
            ),
            SizedBox(height: Dimens.SPACE_15),
            Shimmer.fromColors(
              period: Duration(seconds: 1),
              baseColor: ColorsItem.grey979797,
              highlightColor: ColorsItem.grey606060,
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 10,
                  itemBuilder: (_, __) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimens.SPACE_20,
                          vertical: Dimens.SPACE_10),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: ColorsItem.black32373D,
                                shape: BoxShape.circle),
                            width: Dimens.SPACE_10,
                            height: Dimens.SPACE_10,
                          ),
                          SizedBox(width: Dimens.SPACE_20),
                          Container(
                            decoration: BoxDecoration(
                                color: ColorsItem.black32373D,
                                shape: BoxShape.circle),
                            width: Dimens.SPACE_40,
                            height: Dimens.SPACE_40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                period: Duration(seconds: 1),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Dimens.SPACE_20),
                                  decoration: BoxDecoration(
                                    color: ColorsItem.black32373D,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.SPACE_12)),
                                  ),
                                  width: 200,
                                  height: Dimens.SPACE_16,
                                ),
                                baseColor: ColorsItem.black32373D,
                                highlightColor: ColorsItem.grey606060,
                              ),
                              SizedBox(height: Dimens.SPACE_6),
                              Shimmer.fromColors(
                                period: Duration(seconds: 1),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Dimens.SPACE_20),
                                  decoration: BoxDecoration(
                                    color: ColorsItem.black32373D,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.SPACE_12)),
                                  ),
                                  width: Dimens.SPACE_100,
                                  height: Dimens.SPACE_12,
                                ),
                                baseColor: ColorsItem.black32373D,
                                highlightColor: ColorsItem.grey606060,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
