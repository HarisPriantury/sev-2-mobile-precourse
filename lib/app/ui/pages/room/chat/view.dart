import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/chat_date.dart';
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/private_chat.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/voice_avatar_large.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';

class ChatPage extends View {
  final Object? arguments;

  ChatPage({this.arguments});

  @override
  _ChatState createState() =>
      _ChatState(AppComponent.getInjector().get<ChatController>(), arguments);
}

class _ChatState extends ViewState<ChatPage, ChatController>
    with SingleTickerProviderStateMixin {
  ChatController _controller;

  _ChatState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }
  @override
  void initState() {
    super.initState();
    _controller.animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ChatController>(
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
                flexibleSpace: _controller.isSearch
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10.0),
                        height: MediaQuery.of(context).size.height / 10,
                        child: SearchBar(
                          hintText: S.of(context).room_search_conversation,
                          border: Border.all(
                              color: ColorsItem.grey979797.withOpacity(0.5)),
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(Dimens.SPACE_40)),
                          innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                          outerPadding:
                              EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
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
                          textStyle: TextStyle(
                            fontSize: 15.0,
                          ),
                          hintStyle: TextStyle(color: ColorsItem.grey8D9299),
                          buttonText: 'Clear',
                        ),
                      )
                    : SimpleAppBar(
                        toolbarHeight: MediaQuery.of(context).size.height / 10,
                        prefix: IconButton(
                          icon: FaIcon(FontAwesomeIcons.chevronLeft),
                          onPressed: () async {
                            await _controller.callDispose();
                            _controller.backPage();
                          },
                        ),
                        title: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: ColorsItem.whiteColor,
                                    width: 2.0,
                                  )),
                              child: CircleAvatar(
                                radius: Dimens.SPACE_16,
                                backgroundImage: CachedNetworkImageProvider(
                                  _controller.roomAvatar,
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            SizedBox(width: Dimens.SPACE_12),
                            Expanded(
                              child: Text(
                                _controller.roomName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        suffix: Container(
                          padding: EdgeInsets.only(right: 24.0),
                          child: Row(
                            children: [
                              _controller.isVoice
                                  ? InkWell(
                                      onTap: () {
                                        _controller.setVoiceMode(false);
                                      },
                                      child: FaIcon(
                                          FontAwesomeIcons.solidCommentDots,
                                          size: Dimens.SPACE_20),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        _controller.setVoiceMode(true);
                                      },
                                      child: FaIcon(FontAwesomeIcons.phoneFlip,
                                          size: Dimens.SPACE_18),
                                    ),
                              SizedBox(width: Dimens.SPACE_25),
                              PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 0) {
                                    _controller.onSearch(true);
                                  } else if (value == 1) {
                                    _controller.openDocument();
                                  } else {
                                    controller.onDeleteMultipleChat();
                                  }
                                },
                                child: FaIcon(FontAwesomeIcons.ellipsisVertical,
                                    size: Dimens.SPACE_18),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                      value: 0,
                                      child: Row(
                                        children: [
                                          FaIcon(
                                              FontAwesomeIcons.magnifyingGlass,
                                              size: Dimens.SPACE_18),
                                          SizedBox(width: Dimens.SPACE_8),
                                          Expanded(
                                              child: Text(
                                            S.of(context).label_search,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14),
                                          ))
                                        ],
                                      )),
                                  PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.circleInfo,
                                              size: Dimens.SPACE_18),
                                          SizedBox(width: Dimens.SPACE_8),
                                          Expanded(
                                            child: Text(
                                              S.of(context).label_info,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: Dimens.SPACE_14),
                                            ),
                                          )
                                        ],
                                      )),
                                  PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.trashCan,
                                              size: Dimens.SPACE_18),
                                          SizedBox(width: Dimens.SPACE_8),
                                          Expanded(
                                            child: Text(
                                              S.of(context).label_delete,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: Dimens.SPACE_14),
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                      ),
              ),
              body: _controller.isVoice
                  ? Column(
                      children: [
                        Center(
                            child: VoiceAvatarLarge(
                                avatar:
                                    _controller.getOtherMember().avatar ?? "",
                                isRaisedHand: false,
                                isDeafen: false,
                                isMuted: _controller.checkIsMuted(),
                                isTalking: false)),
                      ],
                    )
                  : Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: _controller.isLoading
                                  ? shimmer(context)
                                  : Container(
                                      margin: controller.isDeleteMultiple ||
                                              controller.isActiveReply
                                          ? EdgeInsets.only(
                                              bottom:
                                                  _controller.messageFieldSize +
                                                      Dimens.SPACE_70)
                                          : EdgeInsets.only(
                                              bottom:
                                                  _controller.messageFieldSize),
                                      child: ScrollablePositionedList.builder(
                                          reverse: true,
                                          itemScrollController:
                                              _controller.itemScrollController,
                                          itemPositionsListener:
                                              _controller.itemPositionListener,
                                          itemCount: _controller.chats.length,
                                          initialScrollIndex:
                                              _controller.isScroll
                                                  ? _controller.chats.length - 1
                                                  : 0,
                                          itemBuilder: (context, index) {
                                            Chat chat =
                                                _controller.chats[index];
                                            return Column(
                                              children: [
                                                ChatDate(
                                                  date: _controller
                                                      .formatChatGroupDate(
                                                          chat.createdAt),
                                                  isShow: (index + 1) >=
                                                          _controller
                                                              .chats.length
                                                      ? false
                                                      : chat.createdAt.isSameDate(
                                                              _controller
                                                                  .chats[
                                                                      index + 1]
                                                                  .createdAt)
                                                          ? false
                                                          : true,
                                                ),
                                                chat.attachments == null
                                                    ? PrivateChat(
                                                        onPanUpdate:
                                                            (DragUpdateDetails
                                                                details) {
                                                          _controller
                                                              .setActiveReply(
                                                                  chat);
                                                        },
                                                        icon: controller
                                                                .isDeleteMultiple
                                                            ? Theme(
                                                                child: Checkbox(
                                                                  checkColor:
                                                                      Colors
                                                                          .black,
                                                                  activeColor:
                                                                      ColorsItem
                                                                          .orangeFB9600,
                                                                  onChanged:
                                                                      (_) {
                                                                    controller
                                                                        .onSelectedItems(
                                                                            chat);
                                                                  },
                                                                  value: controller
                                                                      .selectedChatId
                                                                      .contains(
                                                                          chat),
                                                                ),
                                                                data: ThemeData(
                                                                  unselectedWidgetColor:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              )
                                                            : null,
                                                        context: context,
                                                        message: DataUtil
                                                            .removeAllHtmlTags(
                                                                chat.message),
                                                        time: _controller
                                                            .formatChatTime(
                                                                chat.createdAt),
                                                        backgroundColor: _controller
                                                                    .searchedFocusedIndex() ==
                                                                index
                                                            ? ColorsItem
                                                                .greyCCECEF
                                                                .withOpacity(
                                                                    0.1)
                                                            : null,
                                                        isAuthor:
                                                            chat.sender?.id ==
                                                                _controller
                                                                    .userData
                                                                    .id,
                                                        isSent:
                                                            chat.isIdValid(),
                                                        data: _controller
                                                                .linkPreviewData[
                                                            chat.id],
                                                        onPreviewDataFetched:
                                                            (data) {
                                                          _controller
                                                              .onGetPreviewData(
                                                                  chat.id,
                                                                  data);
                                                        },
                                                        type: ChatContentType
                                                            .text,
                                                        onOpenLink: (link) {
                                                          _controller
                                                              .onOpen(link);
                                                        },
                                                        onLongPress:
                                                            (LongPressStartDetails
                                                                details) {
                                                          toogleSelectOption(
                                                              details
                                                                  .globalPosition,
                                                              chat.sender?.id ==
                                                                  _controller
                                                                      .userData
                                                                      .id,
                                                              chat);
                                                        },
                                                        repliedMessage: _controller
                                                            .getRepliedMessage(
                                                                chat),
                                                        // senderRepliedMessage : chat.sender?.fullName,
                                                      )
                                                    : chat.hasDocument()
                                                        ? PrivateChat(
                                                            onPanUpdate:
                                                                (DragUpdateDetails
                                                                    details) {
                                                              _controller
                                                                  .setActiveReply(
                                                                      chat);
                                                            },
                                                            icon:
                                                                controller
                                                                        .isDeleteMultiple
                                                                    ? Theme(
                                                                        child:
                                                                            Checkbox(
                                                                          checkColor:
                                                                              Colors.black,
                                                                          activeColor:
                                                                              ColorsItem.orangeFB9600,
                                                                          onChanged:
                                                                              (_) {
                                                                            controller.onSelectedItems(chat);
                                                                          },
                                                                          value: controller
                                                                              .selectedChatId
                                                                              .contains(chat),
                                                                        ),
                                                                        data:
                                                                            ThemeData(
                                                                          unselectedWidgetColor:
                                                                              Colors.grey,
                                                                        ),
                                                                      )
                                                                    : null,
                                                            context: context,
                                                            message: chat
                                                                .attachments!
                                                                .first
                                                                .title,
                                                            time: _controller.formatChatTime(
                                                                chat.createdAt),
                                                            isAuthor:
                                                                chat.sender?.id ==
                                                                    _controller
                                                                        .userData
                                                                        .id,
                                                            isSent: chat
                                                                .isIdValid(),
                                                            type: ChatContentType
                                                                .document,
                                                            isAlreadyDownloaded: _controller
                                                                .downloader
                                                                .isAlreadyDownloaded(chat
                                                                    .attachments!
                                                                    .first
                                                                    .url),
                                                            status: _controller
                                                                    .linkDownloadData[chat.id]
                                                                    ?.status ??
                                                                null,
                                                            progress: _controller.linkDownloadData[chat.id]?.progress ?? 0,
                                                            onTap: () {
                                                              _controller
                                                                  .downloadFile(
                                                                      chat
                                                                          .attachments!
                                                                          .first
                                                                          .url,
                                                                      chat.id);
                                                            },
                                                            onLongPress: (LongPressStartDetails details) {
                                                              // controller
                                                              //     .onLongPress(
                                                              //         chat);
                                                              toogleSelectOption(
                                                                  details
                                                                      .globalPosition,
                                                                  chat.sender
                                                                          ?.id ==
                                                                      _controller
                                                                          .userData
                                                                          .id,
                                                                  chat);
                                                            })
                                                        : chat.hasVideo()
                                                            ? PrivateChat(
                                                                onPanUpdate: (DragUpdateDetails details) {
                                                                  _controller
                                                                      .setActiveReply(
                                                                          chat);
                                                                },
                                                                icon: controller.isDeleteMultiple
                                                                    ? Theme(
                                                                        child:
                                                                            Checkbox(
                                                                          checkColor:
                                                                              Colors.black,
                                                                          activeColor:
                                                                              ColorsItem.orangeFB9600,
                                                                          onChanged:
                                                                              (_) {
                                                                            controller.onSelectedItems(chat);
                                                                          },
                                                                          value: controller
                                                                              .selectedChatId
                                                                              .contains(chat),
                                                                        ),
                                                                        data:
                                                                            ThemeData(
                                                                          unselectedWidgetColor:
                                                                              Colors.grey,
                                                                        ),
                                                                      )
                                                                    : null,
                                                                context: context,
                                                                message: chat.attachments!.first.url,
                                                                time: _controller.formatChatTime(chat.createdAt),
                                                                isAuthor: chat.sender?.id == _controller.userData.id,
                                                                isSent: chat.isIdValid(),
                                                                onTap: () {
                                                                  _controller
                                                                      .goToMediaDetail(
                                                                    MediaType
                                                                        .video,
                                                                    chat
                                                                        .attachments!
                                                                        .first
                                                                        .url,
                                                                    chat
                                                                        .attachments!
                                                                        .first
                                                                        .title,
                                                                  );
                                                                },
                                                                type: ChatContentType.video,
                                                                onLongPress: (LongPressStartDetails details) {
                                                                  // controller
                                                                  //     .onLongPress(
                                                                  //         chat);
                                                                  toogleSelectOption(
                                                                      details
                                                                          .globalPosition,
                                                                      chat.sender
                                                                              ?.id ==
                                                                          _controller
                                                                              .userData
                                                                              .id,
                                                                      chat);
                                                                })
                                                            : PrivateChat(
                                                                onPanUpdate:
                                                                    (DragUpdateDetails
                                                                        details) {
                                                                  _controller
                                                                      .setActiveReply(
                                                                          chat);
                                                                },
                                                                icon: controller
                                                                        .isDeleteMultiple
                                                                    ? Theme(
                                                                        child:
                                                                            Checkbox(
                                                                          checkColor:
                                                                              Colors.black,
                                                                          activeColor:
                                                                              ColorsItem.orangeFB9600,
                                                                          onChanged:
                                                                              (_) {
                                                                            controller.onSelectedItems(chat);
                                                                          },
                                                                          value: controller
                                                                              .selectedChatId
                                                                              .contains(chat),
                                                                        ),
                                                                        data:
                                                                            ThemeData(
                                                                          unselectedWidgetColor:
                                                                              Colors.grey,
                                                                        ),
                                                                      )
                                                                    : null,
                                                                context:
                                                                    context,
                                                                message: chat
                                                                    .attachments!
                                                                    .first
                                                                    .url,
                                                                time: _controller
                                                                    .formatChatTime(
                                                                        chat.createdAt),
                                                                isAuthor: chat
                                                                        .sender
                                                                        ?.id ==
                                                                    _controller
                                                                        .userData
                                                                        .id,
                                                                isSent: chat
                                                                    .isIdValid(),
                                                                onTap: () {
                                                                  _controller
                                                                      .goToMediaDetail(
                                                                    MediaType
                                                                        .image,
                                                                    chat
                                                                        .attachments!
                                                                        .first
                                                                        .url,
                                                                    chat
                                                                        .attachments!
                                                                        .first
                                                                        .title,
                                                                  );
                                                                },
                                                                type:
                                                                    ChatContentType
                                                                        .image,
                                                                onLongPress:
                                                                    (LongPressStartDetails
                                                                        details) {
                                                                  // controller
                                                                  //     .onLongPress(
                                                                  //         chat);
                                                                  toogleSelectOption(
                                                                      details
                                                                          .globalPosition,
                                                                      chat.sender
                                                                              ?.id ==
                                                                          _controller
                                                                              .userData
                                                                              .id,
                                                                      chat);
                                                                },
                                                              ),
                                                index == 0
                                                    ? SizedBox(
                                                        height: Dimens.SPACE_8)
                                                    : chat.sender?.id ==
                                                            _controller
                                                                .chats[
                                                                    index - 1]
                                                                .sender
                                                                ?.id //if previous chat is the same sender
                                                        ? SizedBox(
                                                            height:
                                                                Dimens.SPACE_4)
                                                        : SizedBox(
                                                            height:
                                                                Dimens.SPACE_8)
                                              ],
                                            );
                                          })),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: _controller.isSearch
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1.0,
                                          color: ColorsItem.grey666B73
                                              .withOpacity(0.5)),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: Dimens.SPACE_15,
                                    horizontal: Dimens.SPACE_20,
                                  ),
                                  width: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      InkWell(
                                          onTap: () {
                                            _controller.scrollPrevious();
                                          },
                                          child: FaIcon(
                                            FontAwesomeIcons.chevronDown,
                                            size: Dimens.SPACE_20,
                                          )),
                                      SizedBox(width: Dimens.SPACE_20),
                                      InkWell(
                                        onTap: () {
                                          _controller.scrollNext();
                                        },
                                        child: FaIcon(
                                            FontAwesomeIcons.chevronUp,
                                            size: Dimens.SPACE_20),
                                      ),
                                      SizedBox(width: Dimens.SPACE_30),
                                      _controller.searchedIndex.isEmpty
                                          ? SizedBox()
                                          : Flexible(
                                              child: Text(
                                              "${_controller.searchedIndex.length} Match",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: Dimens.SPACE_16),
                                            )),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    _controller.isUploading
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Dimens.SPACE_25),
                                            color: ColorsItem.black24282E,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : _controller
                                                    .uploadedFiles.isNotEmpty &&
                                                !_controller.isUploading
                                            ? Container(
                                                padding: EdgeInsets.all(
                                                    Dimens.SPACE_12),
                                                color: ColorsItem.black24282E,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: _controller
                                                        .uploadedFiles.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        child: _controller
                                                                    .uploadedFiles[
                                                                        index]
                                                                    .fileType ==
                                                                FileType.image
                                                            ? Column(
                                                                children: [
                                                                  Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child:
                                                                          InkWell(
                                                                        onTap: () =>
                                                                            _controller.cancelUpload(_controller.uploadedFiles[index]),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              Dimens.SPACE_20,
                                                                          color:
                                                                              ColorsItem.whiteFEFEFE,
                                                                        ),
                                                                      )),
                                                                  CachedNetworkImage(
                                                                    imageUrl: _controller
                                                                        .uploadedFiles[
                                                                            index]
                                                                        .url,
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
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child:
                                                                          InkWell(
                                                                        onTap: () =>
                                                                            _controller.cancelUpload(_controller.uploadedFiles[index]),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .close,
                                                                          size:
                                                                              Dimens.SPACE_20,
                                                                          color:
                                                                              ColorsItem.whiteFEFEFE,
                                                                        ),
                                                                      )),
                                                                  Center(
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.all(
                                                                          Dimens
                                                                              .SPACE_10),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(Dimens.SPACE_5)),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              ColorsItem.whiteColor,
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.3,
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.article_outlined,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                30.0,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                Dimens.SPACE_10,
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Container(
                                                                                width: MediaQuery.of(context).size.width / 1.8,
                                                                                child: Text(
                                                                                  _controller.uploadedFiles[index].title,
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: GoogleFonts.montserrat(
                                                                                    fontSize: Dimens.SPACE_12,
                                                                                    color: ColorsItem.whiteColor,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                "${_controller.uploadedFiles[index].getFileSizeWording()}",
                                                                                style: GoogleFonts.montserrat(
                                                                                  fontSize: Dimens.SPACE_12,
                                                                                  color: ColorsItem.greyB8BBBF,
                                                                                ),
                                                                              ),
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
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 12),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                17,
                                            padding: EdgeInsets.symmetric(
                                                vertical: Dimens.SPACE_12,
                                                horizontal: Dimens.SPACE_12),
                                            decoration: BoxDecoration(
                                                color: ColorsItem.greyCCECEF
                                                    .withOpacity(0.07),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.SPACE_12)),
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    if (controller
                                                        .isAuthor) ...[
                                                      InkWell(
                                                          onTap: () {
                                                            onDeletedMessage();
                                                          },
                                                          child: Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .trashCan,
                                                                color: ColorsItem
                                                                    .redDA1414,
                                                                size: Dimens
                                                                    .SPACE_20,
                                                              ),
                                                              SizedBox(
                                                                  width: Dimens
                                                                      .SPACE_4),
                                                              Text(
                                                                "${_controller.selectedChatId.length > 0 ? _controller.selectedChatId.length : ""} Hapus",
                                                                style: GoogleFonts.montserrat(
                                                                    color: ColorsItem
                                                                        .whiteFEFEFE,
                                                                    fontSize: Dimens
                                                                        .SPACE_12),
                                                              )
                                                            ],
                                                          )),
                                                      SizedBox(
                                                          width:
                                                              Dimens.SPACE_45)
                                                    ],
                                                    InkWell(
                                                        onTap: () {
                                                          Clipboard.setData(ClipboardData(
                                                              text: controller
                                                                  .selectedChatId
                                                                  .map((e) => e
                                                                              .attachments
                                                                              ?.first
                                                                              .idInt !=
                                                                          null
                                                                      ? "{F${e.attachments?.first.idInt}}"
                                                                      : e.message)
                                                                  .join(",\n")));
                                                          controller
                                                              .onCancelSelectedChat();
                                                        },
                                                        child: Row(
                                                          children: [
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .copy,
                                                              color: ColorsItem
                                                                  .whiteColor,
                                                              size: Dimens
                                                                  .SPACE_20,
                                                            ),
                                                            SizedBox(
                                                                width: Dimens
                                                                    .SPACE_4),
                                                            Text(
                                                              S
                                                                  .of(context)
                                                                  .copy_message,
                                                              style: GoogleFonts.montserrat(
                                                                  color: ColorsItem
                                                                      .whiteFEFEFE,
                                                                  fontSize: Dimens
                                                                      .SPACE_12),
                                                            )
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () => _controller
                                                      .onCancelSelectedChat(),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: Dimens.SPACE_20,
                                                    color:
                                                        ColorsItem.whiteFEFEFE,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : controller.isActiveReply
                                            ? onReplyChat(_controller
                                                .selectedChatId.first)
                                            : SizedBox(),
                                    _controller.isLoading
                                        ? Container(
                                            height: Dimens.SPACE_80,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  width: 1.0,
                                                  color: ColorsItem.grey666B73
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              vertical: Dimens.SPACE_15,
                                              horizontal: Dimens.SPACE_10,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Shimmer.fromColors(
                                                  child: Container(
                                                    width: Dimens.SPACE_20,
                                                    height: Dimens.SPACE_30,
                                                    padding: EdgeInsets.all(
                                                        Dimens.SPACE_10),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorsItem.grey979797,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      border: Border.all(
                                                          color: ColorsItem
                                                              .grey979797),
                                                    ),
                                                  ),
                                                  baseColor:
                                                      ColorsItem.grey979797,
                                                  highlightColor:
                                                      ColorsItem.grey606060,
                                                ),
                                                Shimmer.fromColors(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    height: Dimens.SPACE_40,
                                                    padding: EdgeInsets.all(
                                                        Dimens.SPACE_10),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorsItem.grey979797,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      border: Border.all(
                                                          color: ColorsItem
                                                              .grey979797),
                                                    ),
                                                  ),
                                                  baseColor:
                                                      ColorsItem.grey979797,
                                                  highlightColor:
                                                      ColorsItem.grey606060,
                                                ),
                                                Shimmer.fromColors(
                                                  child: Container(
                                                    width: Dimens.SPACE_30,
                                                    height: Dimens.SPACE_30,
                                                    padding: EdgeInsets.all(
                                                        Dimens.SPACE_10),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorsItem.grey979797,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      border: Border.all(
                                                          color: ColorsItem
                                                              .grey979797),
                                                    ),
                                                  ),
                                                  baseColor:
                                                      ColorsItem.grey979797,
                                                  highlightColor:
                                                      ColorsItem.grey606060,
                                                ),
                                              ],
                                            ),
                                          )
                                        : RichTextView.editor(
                                            containerPadding:
                                                EdgeInsets.symmetric(
                                              vertical: Dimens.SPACE_7,
                                              horizontal: Dimens.SPACE_10,
                                            ),
                                            containerWidth: double.infinity,
                                            onChanged: (value) {
                                              _controller
                                                  .updateMessageFieldSize();
                                            },
                                            prefix: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: Dimens.SPACE_12),
                                              child: InkWell(
                                                onTap: () {
                                                  if (!_controller.isUploading)
                                                    _settingModalBottomSheet();
                                                },
                                                child: SvgPicture.asset(
                                                  ImageItem.IC_URL,
                                                  color: ColorsItem.grey8D9299,
                                                ),
                                              ),
                                            ),
                                            suffix: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: Dimens.SPACE_12),
                                              child: InkWell(
                                                onTap: () {
                                                  if (!_controller
                                                          .isSendingMessage &&
                                                      !_controller.isUploading)
                                                    _controller.sendMessage();
                                                },
                                                child: SvgPicture.asset(
                                                  ImageItem.IC_SEND,
                                                  color: ColorsItem.grey666B73,
                                                ),
                                              ),
                                            ),
                                            separator: Dimens.SPACE_10,
                                            suggestionPosition:
                                                SuggestionPosition.top,
                                            style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14,
                                            ),
                                            controller: _controller
                                                .textEditingController,
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
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                horizontal: Dimens.SPACE_8,
                                                vertical: Dimens.SPACE_16,
                                              ),
                                              hintText: S
                                                  .of(context)
                                                  .chat_message_box_hint,
                                              fillColor: Colors.grey,
                                              hintStyle: GoogleFonts.montserrat(
                                                  color:
                                                      ColorsItem.white9E9E9E),
                                            ),
                                            keyboardType:
                                                TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: 4,
                                            focusNode: _controller.focusNodeMsg,
                                            mentionSuggestions:
                                                _controller.userSuggestion,
                                            onSearchPeople: (term) async {
                                              return _controller
                                                  .filterUserSuggestion(term);
                                            },
                                            titleStyle: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14,
                                              color: ColorsItem.whiteFEFEFE,
                                            ),
                                            subtitleStyle:
                                                GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_12,
                                              color: ColorsItem.grey8D9299,
                                            ),
                                          ),
                                  ],
                                ),
                        ),
                      ],
                    ),
              bottomNavigationBar: _controller.isVoice
                  ? BottomAppBar(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: Dimens.SPACE_50),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(Dimens.SPACE_6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.SPACE_40)),
                                border:
                                    Border.all(color: ColorsItem.white9E9E9E),
                              ),
                              child: IconButton(
                                  icon: !_controller.isMuted
                                      ? FaIcon(FontAwesomeIcons.microphoneLines,
                                          size: Dimens.SPACE_20)
                                      : FaIcon(
                                          FontAwesomeIcons.microphoneLinesSlash,
                                          size: Dimens.SPACE_20),
                                  onPressed: () {
                                    _controller.setMute();
                                  }),
                            ),
                            SizedBox(width: Dimens.SPACE_16),
                            Container(
                              padding: EdgeInsets.all(Dimens.SPACE_6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.SPACE_40)),
                                border:
                                    Border.all(color: ColorsItem.white9E9E9E),
                              ),
                              child: IconButton(
                                  icon: FaIcon(
                                      !_controller.isSpeakerEnabled
                                          ? FontAwesomeIcons.volumeHigh
                                          : FontAwesomeIcons.phoneVolume,
                                      size: Dimens.SPACE_25),
                                  onPressed: () {
                                    _controller.setSpeaker();
                                  }),
                            ),
                            SizedBox(width: Dimens.SPACE_16),
                            Container(
                              padding: EdgeInsets.all(Dimens.SPACE_6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.SPACE_40)),
                                border:
                                    Border.all(color: ColorsItem.white9E9E9E),
                              ),
                              child: IconButton(
                                icon: FaIcon(FontAwesomeIcons.share),
                                onPressed: () {},
                              ),
                              // onPressed: () {}
                            ),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          );
        }),
      );

  Container shimmer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
      margin: EdgeInsets.only(
        bottom: Dimens.SPACE_90,
      ),
      child: Shimmer.fromColors(
        child: ListView(
          reverse: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_6),
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: Dimens.SPACE_40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.SPACE_12),
                      ),
                      color: ColorsItem.black32373D,
                    ))
              ],
            ),
            SizedBox(height: Dimens.SPACE_6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_6),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: Dimens.SPACE_20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.SPACE_12),
                      ),
                      color: ColorsItem.black32373D,
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_6),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimens.SPACE_6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_6),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_6),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_6),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: Dimens.SPACE_40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: Dimens.SPACE_20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.SPACE_12),
                    ),
                    color: ColorsItem.black32373D,
                  ),
                ),
              ],
            ),
          ],
        ),
        baseColor: ColorsItem.grey979797,
        highlightColor: ColorsItem.grey606060,
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
                  new Column(
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
                            color: ColorsItem.grey666B73,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1.0,
                            ),
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

  void onDeletedMessage({Chat? chat}) {
    showCustomAlertDialog(
        context: context,
        title: chat != null
            ? "Hapus Pesan"
            : "${_controller.selectedChatId.length} Hapus",
        subtitle: S.of(context).delete_message_subtitle,
        cancelButtonText: S.of(context).label_cancel.toUpperCase(),
        confirmButtonText: S.of(context).label_delete.toUpperCase(),
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          if (chat != null) {
            _controller.deleteSelectedMessage(chat);
          } else {
            _controller.deleteMessage();
          }
        });
  }

  void toogleSelectOption(Offset offset, bool isAuthor, Chat chat) async {
    if (_controller.isActiveReply) _controller.setIsActiveReply();
    final seletectedMenuItem = await showMenu<int>(
      context: context,
      position:
          RelativeRect.fromLTRB(isAuthor ? offset.dx : 0, offset.dy, 0, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      color: ColorsItem.grey2E353A,
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.reply,
                color: ColorsItem.whiteFEFEFE,
                size: Dimens.SPACE_20,
              ),
              SizedBox(width: Dimens.SPACE_13),
              Text(
                "Reply",
                style: GoogleFonts.montserrat(
                    color: ColorsItem.whiteFEFEFE, fontSize: Dimens.SPACE_12),
              )
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.copy,
                color: ColorsItem.whiteFEFEFE,
                size: Dimens.SPACE_20,
              ),
              SizedBox(width: Dimens.SPACE_13),
              Text(
                S.of(context).copy_message,
                style: GoogleFonts.montserrat(
                    color: ColorsItem.whiteFEFEFE, fontSize: Dimens.SPACE_12),
              )
            ],
          ),
        ),
        if (isAuthor)
          PopupMenuItem<int>(
            value: 3,
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: ColorsItem.whiteFEFEFE,
                  size: Dimens.SPACE_20,
                ),
                SizedBox(width: Dimens.SPACE_13),
                Text(
                  S.of(context).label_delete,
                  style: GoogleFonts.montserrat(
                      color: ColorsItem.whiteFEFEFE, fontSize: Dimens.SPACE_12),
                )
              ],
            ),
          ),
      ],
      elevation: 4,
    );

    if (seletectedMenuItem == 1) {
      _controller.setActiveReply(chat);
    } else if (seletectedMenuItem == 2) {
      Clipboard.setData(ClipboardData(text: chat.message));
    } else if (seletectedMenuItem == 3) {
      // _controller.onLongPress(chat);
      onDeletedMessage(chat: chat);
    }
  }

  Widget onReplyChat(Chat chat) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.SPACE_12, horizontal: Dimens.SPACE_12),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(Dimens.SPACE_12)),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                InkWell(
                  child: FaIcon(
                    FontAwesomeIcons.reply,
                    size: Dimens.SPACE_20,
                  ),
                ),
                SizedBox(width: Dimens.SPACE_17),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${chat.sender?.fullName}",
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_12),
                      ),
                      SizedBox(width: Dimens.SPACE_4),
                      Text(
                        // chat.message.split("\n").first.contains(RegExp(">|> "))
                        //     ? chat.message.split("\n").last
                        //     : chat.message,
                        _controller.repliedMessage,
                        maxLines: 10,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_12),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _controller.setActiveReply(chat),
            child: Icon(
              Icons.close,
              size: Dimens.SPACE_20,
            ),
          )
        ],
      ),
    );
  }
}
