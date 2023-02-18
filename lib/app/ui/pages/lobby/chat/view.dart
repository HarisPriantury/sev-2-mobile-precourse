import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:mobile_sev2/app/ui/assets/widget/bottomsheet/reaction_bottomsheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/chat_date.dart';
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/group_chat.dart';
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/private_chat.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:shimmer/shimmer.dart';

class RoomChatPage extends View {
  final Object? arguments;

  RoomChatPage({this.arguments});

  @override
  _LobbyRoomState createState() => _LobbyRoomState(
      AppComponent.getInjector().get<LobbyRoomController>(), arguments);
}

class _LobbyRoomState extends ViewState<RoomChatPage, LobbyRoomController> {
  LobbyRoomController _controller;

  _LobbyRoomState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<LobbyRoomController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              await _controller.callDispose();
              _controller.backPage();
              return true;
            },
            child: Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  prefix: IconButton(
                      icon: FaIcon(FontAwesomeIcons.chevronLeft),
                      onPressed: () {
                        _controller.backPage();
                      }),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _controller.room.name!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: Dimens.SPACE_20,
                            fontWeight: FontWeight.bold),
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
                  suffix: SizedBox(
                    width: Dimens.SPACE_40,
                  ),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(),
                child: _controller.isLoading
                    ? shimmer()
                    : Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: controller.isDeleteMultiple
                                  ? EdgeInsets.only(
                                      bottom: _controller.messageFieldSize +
                                          Dimens.SPACE_70)
                                  : EdgeInsets.only(
                                      bottom: _controller.messageFieldSize),
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
                                    controller:
                                        _controller.listScrollController,
                                    itemCount: _controller.chats.length,
                                    itemBuilder: (context, index) {
                                      Chat chat = _controller.chats[index];
                                      bool isReactable = chat.isFromSystem
                                          ? false
                                          : index > 0
                                              ? chat.id ==
                                                      _controller
                                                          .chats[index - 1].id
                                                  ? false
                                                  : true
                                              : true;
                                      return contentChat(chat, index,
                                          controller, isReactable, context);
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              bottomSheet: _controller.isLoading
                  ? shimmerTextField(context)
                  : createMessage(
                      controller,
                      context,
                    ),
            ),
          );
        }),
      );

  shimmerTextField(BuildContext context) {
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
              width: Dimens.SPACE_20,
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
          Shimmer.fromColors(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
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

  Container contentChat(Chat chat, int index, LobbyRoomController controller,
      bool isReactable, BuildContext context) {
    return Container(
      child: Column(
        children: [
          ChatDate(
            date: _controller.formatChatGroupDate(chat.createdAt),
            isShow: (index + 1) >= _controller.chats.length
                ? false
                : chat.createdAt
                        .isSameDate(_controller.chats[index + 1].createdAt)
                    ? false
                    : true,
          ),
          Container(
            child: chat.attachments == null
                ? GroupChat(
                    key: ValueKey(chat.id),
                    isReported:
                        _controller.recentlyReportedIds.contains(chat.id),
                    icon: controller.isDeleteMultiple
                        ? Theme(
                            child: Checkbox(
                              checkColor: Colors.black,
                              activeColor: ColorsItem.orangeFB9600,
                              onChanged: (_) {
                                controller.onSelectedItems(chat);
                              },
                              value: controller.selectedChatId.contains(chat),
                            ),
                            data: ThemeData(
                              unselectedWidgetColor: Colors.grey,
                            ),
                          )
                        : null,
                    author: chat.sender!.getFullName()!,
                    time: _controller.formatChatTime(chat.createdAt),
                    isSent: chat.isIdValid(),
                    reactionList: chat.reactions,
                    avatar: chat.sender!.avatar!,
                    isReactable: isReactable,
                    data: _controller.mapData[chat.id],
                    onPreviewDataFetched: (data) {
                      _controller.onGetPreviewData(chat.id, data);
                    },
                    onReact: () {
                      showReactionBottomSheet(
                          context: context,
                          reactions: _controller.reactions,
                          onReactionClicked: (reaction) {
                            _controller.sendReaction(
                              reaction.id,
                              chat.id,
                            );
                          });
                    },
                    onOpenLink: (url) {
                      _controller.onOpen(url);
                    },
                    onProfileTap: () {
                      if (chat.sender != null)
                        _controller.goToProfile(chat.sender!);
                    },
                    type: ChatContentType.text,
                    message: DataUtil.removeAllHtmlTags(chat.message),
                    onLongPress: (LongPressStartDetails details) {
                      controller.onLongPress(chat);
                    },
                    onLongTapReaction: (reactionData, reactionId) {
                      _controller.showAuthorsReaction(
                          chat.id, reactionData, reactionId);
                    },
                  )
                : chat.hasDocument()
                    ? GroupChat(
                        key: ValueKey(chat.id),
                        isReported:
                            _controller.recentlyReportedIds.contains(chat.id),
                        icon: controller.isDeleteMultiple
                            ? Theme(
                                child: Checkbox(
                                  checkColor: Colors.black,
                                  activeColor: ColorsItem.orangeFB9600,
                                  onChanged: (_) {
                                    controller.onSelectedItems(chat);
                                  },
                                  value:
                                      controller.selectedChatId.contains(chat),
                                ),
                                data: ThemeData(
                                  unselectedWidgetColor: Colors.grey,
                                ),
                              )
                            : null,
                        author: chat.sender!.getFullName()!,
                        time: _controller.formatChatTime(chat.createdAt),
                        isSent: chat.isIdValid(),
                        reactionList: chat.reactions,
                        avatar: chat.sender!.avatar!,
                        type: ChatContentType.document,
                        isReactable: isReactable,
                        onReact: () {
                          showReactionBottomSheet(
                              context: context,
                              reactions: _controller.reactions,
                              onReactionClicked: (reaction) {
                                _controller.sendReaction(
                                  reaction.id,
                                  chat.id,
                                );
                              });
                        },
                        onProfileTap: () {
                          if (chat.sender != null)
                            _controller.goToProfile(chat.sender!);
                        },
                        onTap: () {
                          _controller
                              .downloadOrOpenFile(chat.attachments!.first.url);
                        },
                        message: chat.attachments!.first.title,
                        onLongPress: (LongPressStartDetails details) {
                          controller.onLongPress(chat);
                        },
                      )
                    : chat.hasVideo()
                        ? GroupChat(
                            key: ValueKey(chat.id),
                            isReported: _controller.recentlyReportedIds
                                .contains(chat.id),
                            icon: controller.isDeleteMultiple
                                ? Theme(
                                    child: Checkbox(
                                      checkColor: Colors.black,
                                      activeColor: ColorsItem.orangeFB9600,
                                      onChanged: (_) {
                                        controller.onSelectedItems(chat);
                                      },
                                      value: controller.selectedChatId
                                          .contains(chat),
                                    ),
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.grey,
                                    ),
                                  )
                                : null,
                            author: chat.sender!.getFullName()!,
                            time: _controller.formatChatTime(chat.createdAt),
                            isSent: chat.isIdValid(),
                            reactionList: chat.reactions,
                            avatar: chat.sender!.avatar!,
                            isReactable: isReactable,
                            onReact: () {
                              showReactionBottomSheet(
                                  context: context,
                                  reactions: _controller.reactions,
                                  onReactionClicked: (reaction) {
                                    _controller.sendReaction(
                                      reaction.id,
                                      chat.id,
                                    );
                                  });
                            },
                            onProfileTap: () {
                              if (chat.sender != null)
                                _controller.goToProfile(chat.sender!);
                            },
                            onTap: () {
                              _controller.goToMediaDetail(
                                MediaType.video,
                                chat.attachments!.first.url,
                                _controller
                                    .chats[index].attachments!.first.title,
                              );
                            },
                            type: ChatContentType.video,
                            message: chat.attachments!.first.url,
                            onLongPress: (LongPressStartDetails details) {
                              controller.onLongPress(chat);
                            },
                          )
                        : GroupChat(
                            key: ValueKey(chat.id),
                            isReported: _controller.recentlyReportedIds
                                .contains(chat.id),
                            icon: controller.isDeleteMultiple
                                ? Theme(
                                    child: Checkbox(
                                      checkColor: Colors.black,
                                      activeColor: ColorsItem.orangeFB9600,
                                      onChanged: (_) {
                                        controller.onSelectedItems(chat);
                                      },
                                      value: controller.selectedChatId
                                          .contains(chat),
                                    ),
                                    data: ThemeData(
                                      unselectedWidgetColor: Colors.grey,
                                    ),
                                  )
                                : null,
                            author: chat.sender!.getFullName()!,
                            time: _controller.formatChatTime(chat.createdAt),
                            isSent: chat.isIdValid(),
                            reactionList: chat.reactions,
                            isReactable: isReactable,
                            onReact: () {
                              showReactionBottomSheet(
                                  context: context,
                                  reactions: _controller.reactions,
                                  onReactionClicked: (reaction) {
                                    _controller.sendReaction(
                                      reaction.id,
                                      chat.id,
                                    );
                                  });
                            },
                            onProfileTap: () {
                              if (chat.sender != null)
                                _controller.goToProfile(chat.sender!);
                            },
                            onTap: () {
                              _controller.goToMediaDetail(
                                MediaType.image,
                                chat.attachments!.first.url,
                                _controller
                                    .chats[index].attachments!.first.title,
                              );
                            },
                            avatar: chat.sender!.avatar!,
                            type: ChatContentType.image,
                            message: chat.attachments!.first.url,
                            onLongPress: (LongPressStartDetails details) {
                              controller.onLongPress(chat);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Container createMessage(
      LobbyRoomController controller, BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _controller.isUploading
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_25),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _controller.uploadedFiles.isNotEmpty && !_controller.isUploading
                  ? Container(
                      padding: EdgeInsets.all(Dimens.SPACE_12),
                      child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _controller.uploadedFiles.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: _controller
                                          .uploadedFiles[index].fileType ==
                                      FileType.image
                                  ? Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () => _controller
                                                  .cancelUpload(_controller
                                                      .uploadedFiles[index]),
                                              child: Icon(
                                                Icons.close,
                                                size: Dimens.SPACE_20,
                                              ),
                                            )),
                                        CachedNetworkImage(
                                          imageUrl: _controller
                                              .uploadedFiles[index].url,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              11,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                              onTap: () => _controller
                                                  .cancelUpload(_controller
                                                      .uploadedFiles[index]),
                                              child: Icon(
                                                Icons.close,
                                                size: Dimens.SPACE_20,
                                              ),
                                            )),
                                        Center(
                                          child: Container(
                                            padding:
                                                EdgeInsets.all(Dimens.SPACE_10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.SPACE_5)),
                                              border: Border.all(
                                                width: Dimens.SPACE_1,
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.article_outlined,
                                                  color: Colors.white,
                                                  size: Dimens.SPACE_30,
                                                ),
                                                SizedBox(
                                                  width: Dimens.SPACE_10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.8,
                                                      child: Text(
                                                          _controller
                                                              .uploadedFiles[
                                                                  index]
                                                              .title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  fontSize: Dimens
                                                                      .SPACE_12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ),
                                                    Text(
                                                        "${_controller.uploadedFiles[index].getFileSizeWording()}",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize:
                                                              Dimens.SPACE_12,
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            );
                          }),
                    )
                  : SizedBox(),
          controller.isDeleteMultiple
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  height: MediaQuery.of(context).size.height / 17,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimens.SPACE_12,
                    horizontal: Dimens.SPACE_12,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.SPACE_12)),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          if (controller.isAuthor) ...[
                            InkWell(
                                onTap: () {
                                  onDeletedMessage();
                                },
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.trashCan,
                                      color: ColorsItem.redDA1414,
                                      size: Dimens.SPACE_20,
                                    ),
                                    SizedBox(width: Dimens.SPACE_4),
                                    Text(
                                      "${_controller.selectedChatId.length > 0 ? _controller.selectedChatId.length : ""} ${S.of(context).label_delete}",
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_12,
                                      ),
                                    )
                                  ],
                                )),
                            SizedBox(width: Dimens.SPACE_20)
                          ],
                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: controller.selectedChatId
                                        .map((e) => e
                                                    .attachments?.first.idInt !=
                                                null
                                            ? "{F${e.attachments?.first.idInt}}"
                                            : e.message)
                                        .join(",\n")));
                                controller.onCancelSelectedChat();
                              },
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.copy,
                                    size: Dimens.SPACE_20,
                                  ),
                                  SizedBox(width: Dimens.SPACE_4),
                                  Text(
                                    S.of(context).copy_message,
                                    style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_12),
                                  ),
                                  SizedBox(width: Dimens.SPACE_20)
                                ],
                              )),
                          if (controller.selectedChatId.length == 1 &&
                              !_controller.recentlyReportedIds
                                  .contains(controller.selectedChatId[0].id))
                            InkWell(
                              onTap: () {
                                controller.onReportMessage();
                              },
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidFlag,
                                    color: ColorsItem.redDA1414,
                                    size: Dimens.SPACE_20,
                                  ),
                                  SizedBox(width: Dimens.SPACE_4),
                                  Text(
                                    S.of(context).report_this_message,
                                    style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_12),
                                  )
                                ],
                              ),
                            ),
                          if (controller.selectedChatId.length == 1 &&
                              _controller.recentlyReportedIds
                                  .contains(controller.selectedChatId[0].id))
                            InkWell(
                              onTap: () {
                                controller.removeReportedChatPHID(
                                    controller.selectedChatId[0].id);
                              },
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.eye,
                                    color: ColorsItem.redDA1414,
                                    size: Dimens.SPACE_20,
                                  ),
                                  SizedBox(width: Dimens.SPACE_4),
                                  Text(
                                    S.of(context).report_unhide_message,
                                    style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_12),
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                      InkWell(
                        onTap: () => _controller.onCancelSelectedChat(),
                        child: Icon(
                          Icons.close,
                          size: Dimens.SPACE_20,
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(),
          RichTextView.editor(
            containerPadding: EdgeInsets.symmetric(
              vertical: Dimens.SPACE_15,
              horizontal: Dimens.SPACE_10,
            ),
            containerWidth: double.infinity,
            onChanged: (value) {
              _controller.updateMessageFieldSize();
            },
            prefix: Container(
              padding: EdgeInsets.only(bottom: Dimens.SPACE_12),
              child: InkWell(
                onTap: () {
                  if (!_controller.isUploading) _settingModalBottomSheet();
                },
                child: SvgPicture.asset(
                  ImageItem.IC_URL,
                  color: ColorsItem.grey8D9299,
                ),
              ),
            ),
            suffix: Container(
              padding: EdgeInsets.only(bottom: Dimens.SPACE_12),
              child: InkWell(
                onTap: () {
                  if (!_controller.isSendingMessage && !_controller.isUploading)
                    _controller.sendMessage();
                },
                child: SvgPicture.asset(
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
              hintStyle: GoogleFonts.montserrat(color: ColorsItem.white9E9E9E),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 4,
            focusNode: _controller.focusNodeMsg,
            mentionSuggestions: _controller.userSuggestion,
            onSearchPeople: (term) async {
              return _controller.filterUserSuggestion(term);
            },
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
    );
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 375),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          height: Dimens.SPACE_4,
                          width: Dimens.SPACE_40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: Dimens.SPACE_1),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.SPACE_20,
                            vertical: Dimens.SPACE_10),
                        child: Center(
                          child: Text(S.of(context).chat_attach_title,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 0.2,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _controller.upload(FileType.image);
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(width: 0.5),
                                  ),
                                ),
                                margin: EdgeInsets.only(left: Dimens.SPACE_20),
                                padding: EdgeInsets.only(
                                    top: Dimens.SPACE_15,
                                    bottom: Dimens.SPACE_15,
                                    right: Dimens.SPACE_20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.images,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                14),
                                    SizedBox(
                                      width: Dimens.SPACE_10,
                                    ),
                                    Text(S.of(context).chat_attach_image_label,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_16)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _controller.upload(FileType.video);
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(width: 0.5),
                                  ),
                                ),
                                margin: EdgeInsets.only(left: Dimens.SPACE_20),
                                padding: EdgeInsets.only(
                                    top: Dimens.SPACE_15,
                                    bottom: Dimens.SPACE_15,
                                    right: Dimens.SPACE_20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.video,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                14),
                                    SizedBox(
                                      width: Dimens.SPACE_10,
                                    ),
                                    Text(S.of(context).chat_attach_video_label,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_16)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _controller.upload(FileType.document);
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                margin: EdgeInsets.only(left: Dimens.SPACE_20),
                                padding: EdgeInsets.only(
                                    top: Dimens.SPACE_15,
                                    bottom: Dimens.SPACE_15,
                                    right: Dimens.SPACE_20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.folderOpen,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                14),
                                    SizedBox(
                                      width: Dimens.SPACE_10,
                                    ),
                                    Text(
                                        S
                                            .of(context)
                                            .chat_attach_document_label,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_16)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        });
  }

  void onDeletedMessage() {
    showCustomAlertDialog(
        context: context,
        title: "${_controller.selectedChatId.length} Hapus",
        subtitle: S.of(context).delete_message_subtitle,
        cancelButtonText: S.of(context).label_cancel.toUpperCase(),
        confirmButtonText: S.of(context).label_delete.toUpperCase(),
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          _controller.deleteMessage();
          Navigator.pop(context);
        });
  }

  shimmer() {
    return Shimmer.fromColors(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                                width: 200,
                                height: Dimens.SPACE_16,
                              ),
                              SizedBox(height: Dimens.SPACE_6),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                                width: 230,
                                height: Dimens.SPACE_12,
                              ),
                              SizedBox(height: Dimens.SPACE_6),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
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
    );
  }
}
