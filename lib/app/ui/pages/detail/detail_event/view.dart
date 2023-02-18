import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/bottomsheet/reaction_bottomsheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/assets/widget/detail_head.dart';
import 'package:mobile_sev2/app/ui/assets/widget/transaction_item.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:rich_text_view/rich_text_view.dart';

class DetailEventPage extends View {
  DetailEventPage({
    this.arguments,
  });

  final Object? arguments;

  @override
  _DetailEventState createState() => _DetailEventState(
      AppComponent.getInjector().get<DetailEventController>(), arguments);
}

class _DetailEventState
    extends ViewState<DetailEventPage, DetailEventController> {
  _DetailEventState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  DetailEventController _controller;

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<DetailEventController>(
          builder: (context, controller) {
            return Scaffold(
                key: globalKey,
                body: _controller.isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(this.context).size.height / 10,
                            ),
                            child: NestedScrollView(
                              floatHeaderSlivers: true,
                              headerSliverBuilder: (
                                BuildContext context,
                                bool innerBoxIsScrolled,
                              ) {
                                return [
                                  SliverAppBar(
                                    automaticallyImplyLeading: false,
                                    floating: true,
                                    snap: true,
                                    toolbarHeight:
                                        MediaQuery.of(context).size.height / 10,
                                    flexibleSpace: SimpleAppBar(
                                      toolbarHeight:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      prefix: IconButton(
                                        icon: FaIcon(
                                            FontAwesomeIcons.chevronLeft),
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                      ),
                                      title: Text(
                                        "Detail ${S.of(context).label_agenda}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_16,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimens.SPACE_10),
                                      suffix: _popMenu(),
                                    ),
                                  ),
                                ];
                              },
                              body: ListView(
                                children: [
                                  _detailHead(),
                                  SizedBox(height: Dimens.SPACE_4),
                                  _buildChips(),
                                  SizedBox(height: Dimens.SPACE_12),
                                  Divider(
                                    color: ColorsItem.white9E9E9E,
                                    height: Dimens.SPACE_2,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(Dimens.SPACE_20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.circleInfo,
                                              size: Dimens.SPACE_16,
                                              color: ColorsItem.grey858A93,
                                            ),
                                            SizedBox(width: Dimens.SPACE_14),
                                            Text(
                                              "information".toUpperCase(),
                                              style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                fontWeight: FontWeight.w700,
                                                color: ColorsItem.grey858A93,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: Dimens.SPACE_20),
                                        Stack(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(
                                                  Dimens.SPACE_16),
                                              margin:
                                                  EdgeInsets.only(bottom: 27),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1,
                                                  color: ColorsItem.black32373D,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    Dimens.SPACE_8,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    S
                                                        .of(context)
                                                        .room_detail_description_label,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: ColorsItem
                                                          .white9E9E9E,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: Dimens.SPACE_14,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: Dimens.SPACE_8),
                                                  Linkify(
                                                    style: GoogleFonts
                                                        .montserrat(),
                                                    text: _controller
                                                        .expandableText.text,
                                                    onOpen: (link) {
                                                      _controller
                                                          .onOpen(link.url);
                                                    },
                                                  ),
                                                  SizedBox(
                                                      height: Dimens.SPACE_8),
                                                ],
                                              ),
                                            ),
                                            _controller.expandableText
                                                    .isAbleToExpand
                                                ? Positioned(
                                                    bottom: 0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (_controller
                                                            .expandableText
                                                            .isCollapsed) {
                                                          _controller
                                                              .expandContent();
                                                        } else {
                                                          _controller
                                                              .collapseContent();
                                                        }
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            Dimens.SPACE_15),
                                                        child: FaIcon(
                                                          _controller
                                                                  .expandableText
                                                                  .isCollapsed
                                                              ? FontAwesomeIcons
                                                                  .circleChevronDown
                                                              : FontAwesomeIcons
                                                                  .circleChevronUp,
                                                          color: ColorsItem
                                                              .green00A1B0,
                                                          size: Dimens.SPACE_24,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                        Container(
                                          width: double.infinity,
                                          padding:
                                              EdgeInsets.all(Dimens.SPACE_16),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: ColorsItem.black32373D,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(Dimens.SPACE_8),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                S
                                                    .of(context)
                                                    .room_detail_written_by_label,
                                                style: GoogleFonts.montserrat(
                                                  color: ColorsItem.white9E9E9E,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: Dimens.SPACE_14,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              SizedBox(height: Dimens.SPACE_8),
                                              Row(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: Dimens.SPACE_5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        width: Dimens.SPACE_2,
                                                        color: ColorsItem
                                                            .whiteFEFEFE,
                                                      ),
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              _controller
                                                                      .event
                                                                      ?.host
                                                                      .avatar ??
                                                                  ""),
                                                      radius: Dimens.SPACE_14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_8),
                                                  Flexible(
                                                    child: Text(
                                                      _controller.event?.host
                                                              .fullName ??
                                                          "",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_14,
                                                        letterSpacing: 0.2,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: Dimens.SPACE_12),
                                              Text(
                                                S
                                                    .of(context)
                                                    .room_detail_invited_by_label,
                                                style: GoogleFonts.montserrat(
                                                  color: ColorsItem.white9E9E9E,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: Dimens.SPACE_14,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              SizedBox(height: Dimens.SPACE_8),
                                              Wrap(
                                                spacing: -8.0,
                                                children: List.generate(
                                                  _controller.event!.invitees!
                                                              .length >
                                                          11
                                                      ? 12
                                                      : _controller.event!
                                                          .invitees!.length,
                                                  (index) => Container(
                                                    margin: EdgeInsets.only(
                                                        top: Dimens.SPACE_5),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorsItem.grey606060,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        width: Dimens.SPACE_2,
                                                        color: ColorsItem
                                                            .whiteFEFEFE,
                                                      ),
                                                    ),
                                                    child: index == 11
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .all(Dimens
                                                                    .SPACE_7),
                                                            child: Text(
                                                              "${(_controller.event!.invitees!.length - 10)}+",
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: ColorsItem
                                                                    .whiteFEFEFE,
                                                              ),
                                                            ),
                                                          )
                                                        : CircleAvatar(
                                                            backgroundImage:
                                                                CachedNetworkImageProvider(_controller
                                                                        .event
                                                                        ?.invitees?[
                                                                            index]
                                                                        .avatar ??
                                                                    ""),
                                                            radius:
                                                                Dimens.SPACE_14,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: Dimens.SPACE_20),
                                        Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.circleInfo,
                                              size: Dimens.SPACE_16,
                                              color: ColorsItem.grey858A93,
                                            ),
                                            SizedBox(width: Dimens.SPACE_14),
                                            Text(
                                              "Recent activities".toUpperCase(),
                                              style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                fontWeight: FontWeight.w700,
                                                color: ColorsItem.grey858A93,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    itemCount: _controller.transactions?.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          child: _controller
                                                      .transactions![index]
                                                      .attachments!
                                                      .length ==
                                                  0
                                              ? TransactionItem(
                                                  avatar: _controller
                                                      .transactions![index]
                                                      .actor
                                                      .avatar!,
                                                  transactionAuthor:
                                                      "<bold>${_controller.transactions![index].actor.name}</bold>",
                                                  type: 'text',
                                                  onOpenLink: (url) {
                                                    _controller.onOpen(url);
                                                  },
                                                  data: _controller.mapData[
                                                      _controller
                                                          .transactions![index]
                                                          .id],
                                                  onPreviewDataFetched: (data) {
                                                    _controller
                                                        .onGetPreviewData(
                                                            _controller
                                                                .transactions![
                                                                    index]
                                                                .id,
                                                            data);
                                                  },
                                                  transactionContent:
                                                      "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                                                  dateTime: _controller
                                                      .parseTime(_controller
                                                          .transactions![index]
                                                          .createdAt),
                                                  onReact: () {
                                                    showReactionBottomSheet(
                                                      context: context,
                                                      reactions: [],
                                                      onReactionClicked:
                                                          (reaction) {
                                                        _controller
                                                            .sendReaction(
                                                          reaction.id,
                                                          _controller
                                                              .transactions![
                                                                  index]
                                                              .id,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  onLongTapReaction:
                                                      (reactionData,
                                                          reactionId) {
                                                    _controller
                                                        .showAuthorsReaction(
                                                      _controller
                                                          .transactions![index]
                                                          .id,
                                                      reactionData,
                                                      reactionId,
                                                    );
                                                  },
                                                  isReactable: _controller
                                                      .transactions![index]
                                                      .isReactable(),
                                                  reactionList: _controller
                                                          .transactions![index]
                                                          .reactions ??
                                                      [],
                                                )
                                              : TransactionItem(
                                                  avatar: _controller
                                                      .transactions![index]
                                                      .actor
                                                      .avatar!,
                                                  transactionAuthor:
                                                      "<bold>${_controller.transactions![index].actor.name}</bold>",
                                                  type: 'document',
                                                  onOpenLink: (url) {
                                                    _controller.onOpen(url);
                                                  },
                                                  data: _controller.mapData[
                                                      _controller
                                                          .transactions![index]
                                                          .id],
                                                  onPreviewDataFetched: (data) {
                                                    _controller
                                                        .onGetPreviewData(
                                                            _controller
                                                                .transactions![
                                                                    index]
                                                                .id,
                                                            data);
                                                  },
                                                  attachments: _controller
                                                      .transactions![index]
                                                      .attachments!,
                                                  transactionContent:
                                                      "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                                                  dateTime: _controller
                                                      .parseTime(_controller
                                                          .transactions![index]
                                                          .createdAt),
                                                  onReact: () {
                                                    showReactionBottomSheet(
                                                      context: context,
                                                      reactions: [],
                                                      onReactionClicked:
                                                          (reaction) {
                                                        _controller
                                                            .sendReaction(
                                                          reaction.id,
                                                          _controller
                                                              .transactions![
                                                                  index]
                                                              .id,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  onLongTapReaction:
                                                      (reactionData,
                                                          reactionId) {
                                                    _controller
                                                        .showAuthorsReaction(
                                                      _controller
                                                          .transactions![index]
                                                          .id,
                                                      reactionData,
                                                      reactionId,
                                                    );
                                                  },
                                                  onTap: (fileIndex) {
                                                    _controller
                                                                .transactions![
                                                                    index]
                                                                .attachments![
                                                                    fileIndex]
                                                                .fileType ==
                                                            FileType.document
                                                        ? _controller
                                                            .downloadOrOpenFile(
                                                                _controller
                                                                    .transactions![
                                                                        index]
                                                                    .attachments![
                                                                        fileIndex]
                                                                    .url)
                                                        : _controller
                                                                    .transactions![
                                                                        index]
                                                                    .attachments![
                                                                        fileIndex]
                                                                    .fileType ==
                                                                FileType.video
                                                            ? _controller
                                                                .goToMediaDetail(
                                                                MediaType.video,
                                                                _controller
                                                                    .transactions![
                                                                        index]
                                                                    .attachments![
                                                                        fileIndex]
                                                                    .url,
                                                                _controller
                                                                    .transactions![
                                                                        index]
                                                                    .attachments![
                                                                        fileIndex]
                                                                    .title,
                                                              )
                                                            : _controller
                                                                .goToMediaDetail(
                                                                MediaType.image,
                                                                _controller
                                                                    .transactions![
                                                                        index]
                                                                    .attachments![
                                                                        fileIndex]
                                                                    .url,
                                                                _controller
                                                                    .transactions![
                                                                        index]
                                                                    .attachments![
                                                                        fileIndex]
                                                                    .title,
                                                              );
                                                  },
                                                  isReactable: _controller
                                                      .transactions![index]
                                                      .isReactable(),
                                                  reactionList: _controller
                                                          .transactions![index]
                                                          .reactions ??
                                                      [],
                                                ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            left: 0.0,
                            right: 0.0,
                            child: createMessage(controller, context),
                          ),
                        ],
                      ));
          },
        ),
      );

  Container createMessage(
      DetailEventController controller, BuildContext context) {
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
                                                color: ColorsItem.whiteFEFEFE,
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
                                                color: ColorsItem.whiteFEFEFE,
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
                                                color: ColorsItem.whiteColor,
                                                width: 1.0,
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
                                                  size: 30.0,
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
                                                          style: GoogleFonts.montserrat(
                                                              fontSize: Dimens
                                                                  .SPACE_12,
                                                              color: ColorsItem
                                                                  .whiteColor,
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
                                                          color: ColorsItem
                                                              .greyB8BBBF,
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
          RichTextView.editor(
            containerPadding: EdgeInsets.symmetric(
              vertical: Dimens.SPACE_15,
              horizontal: Dimens.SPACE_10,
            ),
            containerWidth: double.infinity,
            onChanged: (value) {},
            prefix: Container(
              padding: EdgeInsets.only(bottom: Dimens.SPACE_12),
              child: InkWell(
                onTap: () => _settingModalBottomSheet(),
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
                  if (!_controller.isSendingMessage) _controller.sendMessage();
                },
                child: _controller.isSendingMessage
                    ? SizedBox(
                        width: Dimens.SPACE_24,
                        height: Dimens.SPACE_24,
                        child: CircularProgressIndicator(
                          color: ColorsItem.grey8D9299,
                          strokeWidth: 2,
                        ),
                      )
                    : SvgPicture.asset(
                        ImageItem.IC_SEND,
                        color: ColorsItem.grey8D9299,
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
              hintText: S.of(context).chat_comment_box_hint,
              fillColor: Colors.grey,
              hintStyle: GoogleFonts.montserrat(color: ColorsItem.white9E9E9E),
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 4,
            focusNode:
                _controller.isSendingMessage ? _controller.focusNodeMsg : null,
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

  Widget _detailHead() {
    return DetailHead(
      title: "E${_controller.event?.intId} : ${_controller.event?.name}",
      icon: CircleAvatar(
        backgroundColor: ColorsItem.green219653,
        radius: Dimens.SPACE_8,
      ),
      subtitle:
          "${_controller.parseTime(_controller.event?.startTime ?? DateTime.now())} - ${_controller.parseTime(_controller.event?.endTime ?? DateTime.now())}",
    );
  }

  Widget _buildChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_16, vertical: Dimens.SPACE_4),
          child: Wrap(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                child: Chip(
                  label: Text(
                    _controller.getCalendarStatus(),
                    style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                child: Chip(
                  avatar: FaIcon(FontAwesomeIcons.businessTime,
                      size: Dimens.SPACE_12),
                  label: Text(
                    _controller.getCalendarPolicy(),
                    style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12),
                  ),
                ),
              ),
              if (_controller.isJoinedOrDeclined(true) ||
                  _controller.isJoinedOrDeclined(false))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                  child: Chip(
                    avatar: FaIcon(
                        _controller.isJoinedOrDeclined(true)
                            ? FontAwesomeIcons.check
                            : FontAwesomeIcons.xmark,
                        size: Dimens.SPACE_12),
                    label: Text(
                      _controller.isJoinedOrDeclined(true)
                          ? S.of(context).room_detail_attended_label
                          : S.of(context).room_detail_declined_label,
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12),
                    ),
                  ),
                )
            ],
          ),
        ),
        _controller.isJoinedOrDeclined(true) ||
                _controller.isJoinedOrDeclined(false)
            ? SizedBox()
            : SizedBox(height: Dimens.SPACE_12),
        _controller.isJoinedOrDeclined(true) ||
                _controller.isJoinedOrDeclined(false)
            ? SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonDefault(
                      buttonText: S.of(context).label_no.toUpperCase(),
                      buttonColor: Colors.transparent,
                      buttonLineColor: ColorsItem.grey858A93,
                      onTap: () => _controller.onCalendarAct(false),
                      width: MediaQuery.of(context).size.width / 2.5,
                      buttonIcon: Icon(Icons.close, size: Dimens.SPACE_12),
                      paddingVertical: Dimens.SPACE_6,
                      isVisible: _controller.isInvited(),
                    ),
                    ButtonDefault(
                      buttonText: S.of(context).lobby_join_label.toUpperCase(),
                      buttonTextColor: ColorsItem.orangeFB9600,
                      buttonColor: Colors.transparent,
                      buttonLineColor: ColorsItem.orangeFB9600,
                      onTap: () => _controller.onCalendarAct(true),
                      width: MediaQuery.of(context).size.width / 2.5,
                      buttonIcon: Icon(Icons.check,
                          color: ColorsItem.orangeFB9600,
                          size: Dimens.SPACE_12),
                      paddingVertical: Dimens.SPACE_6,
                    )
                  ],
                ),
              )
      ],
    );
  }

  _popMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          _controller.goToEditPage();
        } else if (value == 2) {
          _controller.goToEditParticipantPage();
        } else if (value == 3) {
          _controller.reportEvent();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
        child: FaIcon(
          FontAwesomeIcons.ellipsisVertical,
          size: Dimens.SPACE_18,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Dimens.SPACE_25,
                child: FaIcon(
                  FontAwesomeIcons.solidPenToSquare,
                  size: Dimens.SPACE_16,
                ),
              ),
              Text(
                "${S.of(context).label_edit} ${S.of(context).label_agenda}",
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Dimens.SPACE_25,
                child: FaIcon(
                  FontAwesomeIcons.userPen,
                  size: Dimens.SPACE_16,
                ),
              ),
              Text(
                "${S.of(context).label_edit} ${S.of(context).label_participant}",
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Dimens.SPACE_25,
                child: FaIcon(
                  FontAwesomeIcons.flag,
                  size: Dimens.SPACE_16,
                ),
              ),
              Text(
                "${S.of(context).label_report} ${S.of(context).label_agenda}",
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                ),
              ),
            ],
          ),
        ),
      ],
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
                            color: ColorsItem.white9E9E9E,
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
                                    FaIcon(FontAwesomeIcons.folderOpen,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                14),
                                    SizedBox(width: Dimens.SPACE_10),
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
}
