import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/chat_date.dart';
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/group_chat.dart';
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/private_chat.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/controller.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:shimmer/shimmer.dart';

class PublicSpaceRoom extends View {
  final Object? arguments;

  PublicSpaceRoom({this.arguments});

  @override
  _PublicSpaceRoomState createState() => _PublicSpaceRoomState(
      AppComponent.getInjector().get<PublicSpaceRoomController>(), arguments);
}

class _PublicSpaceRoomState
    extends ViewState<PublicSpaceRoom, PublicSpaceRoomController> {
  PublicSpaceRoomController _controller;

  _PublicSpaceRoomState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<PublicSpaceRoomController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                prefix: IconButton(
                    icon: FaIcon(FontAwesomeIcons.chevronLeft),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _controller.workspace.name != null
                            ? Text(
                                _controller.workspace.name!,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Dimens.SPACE_16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: Dimens.SPACE_4),
                        Text(
                          _controller.workspace.description ?? '',
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_12),
                        ),
                        // _controller.room.memberCount != null
                        //     ? Text("${_controller.room.memberCount} ${S.of(context).room_detail_member_title}",
                        //         style: GoogleFonts.montserrat(color: ColorsItem.grey8D9299, fontSize: Dimens.SPACE_12))
                        //     : SizedBox(),
                      ],
                    ),
                    _controller.isLogin()
                        ? InkWell(
                            onTap: !_controller.isHasSubscribe
                                ? () {
                                    _controller.setIsHasSubscribe();
                                    _controller.showNotif(
                                        context,
                                        S
                                            .of(context)
                                            .label_subscribtion_has_added);
                                  }
                                : () {
                                    showCustomAlertDialog(
                                        context: context,
                                        title:
                                            "${S.of(context).label_unsubscribe} SEV-2",
                                        cancelButtonText: S
                                            .of(context)
                                            .label_back
                                            .toUpperCase(),
                                        confirmButtonText: S
                                            .of(context)
                                            .label_unsubscribe
                                            .toUpperCase(),
                                        confirmButtonTextColor:
                                            ColorsItem.black020202,
                                        confirmButtonColor:
                                            ColorsItem.orangeFB9600,
                                        onConfirm: () {
                                          _controller.setIsHasSubscribe();
                                          Navigator.pop(context);
                                        });
                                  },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: !_controller.isHasSubscribe
                                        ? ColorsItem.orangeFB9600
                                        : ColorsItem.white9E9E9E,
                                  )),
                              margin: EdgeInsets.only(right: Dimens.SPACE_20),
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.SPACE_4,
                                horizontal: Dimens.SPACE_16,
                              ),
                              child: Text(
                                !_controller.isHasSubscribe
                                    ? S.of(context).label_subscribe
                                    : S.of(context).label_subscribed,
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_10,
                                  fontWeight: FontWeight.w500,
                                  color: !_controller.isHasSubscribe
                                      ? ColorsItem.orangeFB9600
                                      : null,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(),
              child: _controller.isLoading
                  ? Shimmer.fromColors(
                      period: Duration(seconds: 1),
                      baseColor: ColorsItem.grey979797,
                      highlightColor: ColorsItem.grey606060,
                      child: Container(
                        margin: EdgeInsets.only(bottom: Dimens.SPACE_70),
                        child: ListView.builder(
                            reverse: true,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: 10,
                            itemBuilder: (_, __) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20,
                                  vertical: Dimens.SPACE_10,
                                ),
                                width: double.infinity,
                                height: Dimens.SPACE_100,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_10,
                                  vertical: Dimens.SPACE_6,
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: ColorsItem.black32373D,
                                              shape: BoxShape.circle,
                                            ),
                                            width: Dimens.SPACE_40,
                                            height: Dimens.SPACE_40,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Dimens.SPACE_20),
                                                decoration: BoxDecoration(
                                                  color: ColorsItem.black32373D,
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          const Radius.circular(
                                                              Dimens.SPACE_12)),
                                                ),
                                                width: 200,
                                                height: Dimens.SPACE_16,
                                              ),
                                              SizedBox(height: Dimens.SPACE_6),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Dimens.SPACE_20),
                                                decoration: BoxDecoration(
                                                  color: ColorsItem.black32373D,
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          const Radius.circular(
                                                              Dimens.SPACE_12)),
                                                ),
                                                width: 230,
                                                height: Dimens.SPACE_12,
                                              ),
                                              SizedBox(height: Dimens.SPACE_6),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Dimens.SPACE_20),
                                                decoration: BoxDecoration(
                                                  color: ColorsItem.black32373D,
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                          const Radius.circular(
                                                              Dimens.SPACE_12)),
                                                ),
                                                width: Dimens.SPACE_100,
                                                height: Dimens.SPACE_12,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: ColorsItem.grey606060,
                                      height: Dimens.SPACE_2,
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: Container(
                            margin: _controller.isLogin()
                                ? EdgeInsets.only(bottom: Dimens.SPACE_80)
                                : EdgeInsets.only(bottom: Dimens.SPACE_120),
                            child: SmartRefresher(
                              controller: _controller.refreshController,
                              onRefresh: _controller.onRefresh,
                              header: ClassicHeader(
                                completeText: "",
                                refreshingText: "",
                                completeIcon: null,
                                refreshingIcon: CupertinoActivityIndicator(
                                  radius: Dimens.SPACE_16,
                                ),
                              ),
                              child: ListView.builder(
                                  reverse: true,
                                  controller: _controller.listScrollController,
                                  itemCount: _controller.chats.length,
                                  itemBuilder: (context, index) {
                                    Chat chat = _controller.chats[index];
                                    return Container(
                                      child: Column(
                                        children: [
                                          ChatDate(
                                            date:
                                                _controller.formatChatGroupDate(
                                                    chat.createdAt),
                                            isShow: (index + 1) >=
                                                    _controller.chats.length
                                                ? false
                                                : chat.createdAt.isSameDate(
                                                        _controller
                                                            .chats[index + 1]
                                                            .createdAt)
                                                    ? false
                                                    : true,
                                          ),
                                          GroupChat(
                                            key: ValueKey(chat.id),
                                            isReported: _controller
                                                .recentlyReportedIds
                                                .contains(chat.id),
                                            onLongPress: (LongPressStartDetails
                                                details) {
                                              toogleSelectOption(
                                                  chat,
                                                  details.globalPosition,
                                                  controller,
                                                  _controller
                                                      .recentlyReportedIds
                                                      .contains(chat.id));
                                            },
                                            author: chat.sender!
                                                    .getFullName() ??
                                                _controller.getUsernameByRegex(
                                                    chat.htmlMessage),
                                            time: _controller
                                                .formatChatTime(chat.createdAt),
                                            avatar: chat.sender!.avatar!,
                                            isReactable: false,
                                            isSent: chat.isIdValid(),
                                            type: ChatContentType.text,
                                            onOpenLink: (url) {
                                              _controller.onOpen(url);
                                            },
                                            data: _controller.mapData[chat.id],
                                            onPreviewDataFetched: (data) {
                                              _controller.onGetPreviewData(
                                                  chat.id, data);
                                            },
                                            message: DataUtil.removeAllHtmlTags(
                                              chat.message,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            bottomSheet: _controller.isLoading
                ? shimmerTextField(context)
                : _controller.isLogin()
                    ? createMessage(context)
                    : loginButton(),
          );
        }),
      );

  Container shimmerTextField(BuildContext context) {
    return Container(
      height: Dimens.SPACE_80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: ColorsItem.grey666B73.withOpacity(0.5),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: Dimens.SPACE_15,
        horizontal: Dimens.SPACE_10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Shimmer.fromColors(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: Dimens.SPACE_40,
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
          Shimmer.fromColors(
            child: Container(
              width: Dimens.SPACE_30,
              height: Dimens.SPACE_30,
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
        ],
      ),
    );
  }

  Container createMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichTextView.editor(
              containerPadding: EdgeInsets.symmetric(
                vertical: Dimens.SPACE_15,
                horizontal: Dimens.SPACE_10,
              ),
              containerWidth: double.infinity,
              onChanged: (value) {
                // _controller.updateMessageFieldSize();
              },
              suffix: Container(
                padding: EdgeInsets.only(bottom: Dimens.SPACE_12),
                child: InkWell(
                  onTap: () {
                    if (!_controller.isSendingMessage)
                      _controller.sendMessage();
                  },
                  child: _controller.isSendingMessage
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : SvgPicture.asset(
                          ImageItem.IC_SEND,
                          color: ColorsItem.white9E9E9E,
                        ),
                ),
              ),
              separator: Dimens.SPACE_10,
              suggestionPosition: SuggestionPosition.top,
              style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_14,
              ),
              controller: _controller.textEditingController,
              decoration: InputDecoration(
                // isDense: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorsItem.black32373D,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ColorsItem.black32373D,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Dimens.SPACE_8,
                  vertical: Dimens.SPACE_16,
                ),
                hintText: S.of(context).chat_message_box_hint,
                fillColor: Colors.grey,
                hintStyle: GoogleFonts.montserrat(color: ColorsItem.grey666B73),
              ),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 4,
              // focusNode: _controller.focusNodeMsg,
              // mentionSuggestions: _controller.userSuggestion,
              // onSearchPeople: (term) async {
              // return _controller.filterUserSuggestion(term);
              // },
              titleStyle: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_14,
                color: ColorsItem.whiteFEFEFE,
              ),
              subtitleStyle: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_12,
                color: ColorsItem.grey8D9299,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container loginButton() {
    return Container(
        decoration: BoxDecoration(
            color: ColorsItem.black24282E,
            border: Border(
                top: BorderSide(
              width: Dimens.SPACE_1,
              color: ColorsItem.grey666B73,
            ))),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.SPACE_12,
            horizontal: Dimens.SPACE_40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.SPACE_40,
                ),
                child: Text(
                  S.of(context).label_enter_to_join_room,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.whiteFEFEFE,
                    fontSize: Dimens.SPACE_12,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimens.SPACE_12),
              ButtonDefault(
                buttonText: S.of(context).login_now_label.toUpperCase(),
                buttonTextColor: ColorsItem.black191C21,
                buttonColor: ColorsItem.orangeFB9600,
                buttonLineColor: ColorsItem.orangeFB9600,
                disabledTextColor: ColorsItem.black191C21,
                disabledButtonColor: ColorsItem.grey8C8C8C,
                disabledLineColor: Colors.transparent,
                letterSpacing: 1.5,
                paddingVertical: Dimens.SPACE_14,
                radius: Dimens.SPACE_8,
                onTap: () {
                  _controller.loginNow();
                },
              ),
            ],
          ),
        ));
  }

  void toogleSelectOption(
    Chat chat,
    Offset offset,
    PublicSpaceRoomController controller,
    bool isReported,
  ) async {
    double left = offset.dx;
    double top = offset.dy;
    final seletectedMenuItem = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      color: ColorsItem.black,
      items: [
        if (!isReported)
          PopupMenuItem<int>(
            value: 1,
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.flag,
                  color: ColorsItem.whiteColor,
                  size: Dimens.SPACE_16,
                ),
                SizedBox(width: Dimens.SPACE_8),
                Text(
                  S.of(context).report_this_message,
                  style: GoogleFonts.montserrat(
                      color: ColorsItem.whiteFEFEFE, fontSize: Dimens.SPACE_12),
                ),
              ],
            ),
          ),
        if (isReported)
          PopupMenuItem<int>(
            value: 2,
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.eye,
                  color: ColorsItem.whiteColor,
                  size: Dimens.SPACE_16,
                ),
                SizedBox(width: Dimens.SPACE_8),
                Text(
                  S.of(context).report_unhide_message,
                  style: GoogleFonts.montserrat(
                      color: ColorsItem.whiteFEFEFE, fontSize: Dimens.SPACE_12),
                ),
              ],
            ),
          ),
      ],
      elevation: 4,
    );

    if (seletectedMenuItem == 1) {
      controller.onReportMessage(chat);
    }

    if (seletectedMenuItem == 2) {
      controller.removeReportedChatPHID(chat.id);
    }
  }
}
