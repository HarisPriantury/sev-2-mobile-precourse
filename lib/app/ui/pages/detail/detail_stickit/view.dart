import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/bottomsheet/reaction_bottomsheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/detail_head.dart';
import 'package:mobile_sev2/app/ui/assets/widget/transaction_item.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:rich_text_view/rich_text_view.dart';

import 'controller.dart';

class DetailStickitPage extends View {
  final Object? arguments;

  DetailStickitPage({this.arguments});

  @override
  _DetailStickitState createState() => _DetailStickitState(
      AppComponent.getInjector().get<DetailStickitController>(), arguments);
}

class _DetailStickitState
    extends ViewState<DetailStickitPage, DetailStickitController> {
  DetailStickitController _controller;

  _DetailStickitState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<DetailStickitController>(
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
                                        MediaQuery.of(context).size.height / 10,
                                    prefix: IconButton(
                                      icon:
                                          FaIcon(FontAwesomeIcons.chevronLeft),
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                    ),
                                    title: Text(
                                      "Detail ${S.of(context).label_stickit}",
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_16,
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    suffix: _popMenu(),
                                  ),
                                ),
                              ];
                            },
                            body: ListView(
                              children: [
                                SizedBox(height: Dimens.SPACE_20),
                                DetailHead(
                                    title: _controller.stickit?.name ?? ""),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_16,
                                  ),
                                  child: Wrap(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: Dimens.SPACE_6,
                                        ),
                                        child: Chip(
                                          label: Text(
                                            (() {
                                              switch (_controller
                                                  .stickit?.stickitType) {
                                                case Stickit.TYPE_MEMO:
                                                  return S
                                                      .of(context)
                                                      .stickit_type_announcement;
                                                case Stickit.TYPE_MOM:
                                                  return S
                                                      .of(context)
                                                      .stickit_type_mom;
                                                case Stickit.TYPE_PITCH:
                                                  return S
                                                      .of(context)
                                                      .stickit_type_pitch_idea;
                                                case Stickit.TYPE_PRAISE:
                                                  return S
                                                      .of(context)
                                                      .stickit_type_praise;
                                                default:
                                                  return "Stick it";
                                              }
                                            }()),
                                            style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Dimens.SPACE_10),
                                Divider(
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
                                            padding:
                                                EdgeInsets.all(Dimens.SPACE_16),
                                            margin: EdgeInsets.only(bottom: 27),
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
                                                  S.of(context).label_stickit,
                                                  style: GoogleFonts.montserrat(
                                                    color:
                                                        ColorsItem.grey666B73,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Dimens.SPACE_14,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: Dimens.SPACE_8),
                                                HtmlWidget(
                                                  """${_controller.expandableText.text}""",
                                                  textStyle: TextStyle(
                                                    fontSize: Dimens.SPACE_14,
                                                    letterSpacing: 0.2,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  onTapUrl: (url) =>
                                                      _controller.onOpen(url),
                                                ),
                                                SizedBox(
                                                    height: Dimens.SPACE_8),
                                              ],
                                            ),
                                          ),
                                          _controller
                                                  .expandableText.isAbleToExpand
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
                                                        _controller.expandableText
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
                                                                    .stickit
                                                                    ?.author
                                                                    .avatar ??
                                                                ""),
                                                    radius: Dimens.SPACE_14,
                                                  ),
                                                ),
                                                SizedBox(width: Dimens.SPACE_8),
                                                Flexible(
                                                  child: Text(
                                                    _controller.stickit?.author
                                                            .fullName ??
                                                        "",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: Dimens.SPACE_14,
                                                      letterSpacing: 0.2,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    // maxLines: null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: Dimens.SPACE_12),
                                            Text(
                                              S
                                                  .of(context)
                                                  .room_detail_seen_by_label,
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700,
                                                fontSize: Dimens.SPACE_14,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            SizedBox(height: Dimens.SPACE_8),
                                            Wrap(
                                              spacing: -8.0,
                                              children: List.generate(
                                                _controller.stickit?.spectators
                                                        ?.length ??
                                                    0,
                                                (index) => Container(
                                                  margin: EdgeInsets.only(
                                                      top: Dimens.SPACE_5),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      width: Dimens.SPACE_2,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            _controller
                                                                    .stickit
                                                                    ?.spectators?[
                                                                        index]
                                                                    .avatar ??
                                                                ""),
                                                    radius: Dimens.SPACE_14,
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
                                          ),
                                          SizedBox(width: Dimens.SPACE_14),
                                          Text(
                                            "Recent activities".toUpperCase(),
                                            style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14,
                                              fontWeight: FontWeight.w700,
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
                                        child: _controller.transactions![index]
                                                    .attachments!.length ==
                                                0
                                            ? TransactionItem(
                                                avatar: _controller
                                                    .transactions![index]
                                                    .actor
                                                    .avatar!,
                                                transactionAuthor:
                                                    "<bold>${_controller.transactions![index].actor.name}</bold>",
                                                onOpenLink: (url) {
                                                  _controller.onOpen(url);
                                                },
                                                data: _controller.mapData[
                                                    _controller
                                                        .transactions![index]
                                                        .id],
                                                onPreviewDataFetched: (data) {
                                                  _controller.onGetPreviewData(
                                                      _controller
                                                          .transactions![index]
                                                          .id,
                                                      data);
                                                },
                                                transactionContent:
                                                    "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                                                dateTime: _controller.parseTime(
                                                    _controller
                                                        .transactions![index]
                                                        .createdAt),
                                                onReact: () {
                                                  showReactionBottomSheet(
                                                    context: context,
                                                    reactions: [],
                                                    onReactionClicked:
                                                        (reaction) {
                                                      _controller.sendReaction(
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
                                                    (reactionData, reactionId) {
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
                                                attachments: _controller
                                                    .transactions![index]
                                                    .attachments!,
                                                transactionContent:
                                                    "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                                                dateTime: _controller.parseTime(
                                                    _controller
                                                        .transactions![index]
                                                        .createdAt),
                                                onReact: () {
                                                  showReactionBottomSheet(
                                                    context: context,
                                                    reactions: [],
                                                    onReactionClicked:
                                                        (reaction) {
                                                      _controller.sendReaction(
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
                                                    (reactionData, reactionId) {
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _controller.isUploading
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimens.SPACE_25),
                                      color: ColorsItem.black24282E,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : _controller.uploadedFiles.isNotEmpty &&
                                          !_controller.isUploading
                                      ? Container(
                                          padding:
                                              EdgeInsets.all(Dimens.SPACE_12),
                                          color: ColorsItem.black24282E,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount: _controller
                                                  .uploadedFiles.length,
                                              itemBuilder: (context, index) {
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
                                                                child: InkWell(
                                                                  onTap: () => _controller
                                                                      .cancelUpload(
                                                                          _controller
                                                                              .uploadedFiles[index]),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: Dimens
                                                                        .SPACE_20,
                                                                    color: ColorsItem
                                                                        .whiteFEFEFE,
                                                                  ),
                                                                )),
                                                            CachedNetworkImage(
                                                              imageUrl: _controller
                                                                  .uploadedFiles[
                                                                      index]
                                                                  .url,
                                                              height: MediaQuery.of(
                                                                          context)
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
                                                                child: InkWell(
                                                                  onTap: () => _controller
                                                                      .cancelUpload(
                                                                          _controller
                                                                              .uploadedFiles[index]),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: Dimens
                                                                        .SPACE_20,
                                                                    color: ColorsItem
                                                                        .whiteFEFEFE,
                                                                  ),
                                                                )),
                                                            Center(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .all(Dimens
                                                                        .SPACE_10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              Dimens.SPACE_5)),
                                                                  border: Border
                                                                      .all(
                                                                    color: ColorsItem
                                                                        .whiteColor,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.3,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .article_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          30.0,
                                                                    ),
                                                                    SizedBox(
                                                                      width: Dimens
                                                                          .SPACE_10,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 1.8,
                                                                          child: Text(
                                                                              _controller.uploadedFiles[index].title,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12, color: ColorsItem.whiteColor, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Text(
                                                                            "${_controller.uploadedFiles[index].getFileSizeWording()}",
                                                                            style:
                                                                                GoogleFonts.montserrat(
                                                                              fontSize: Dimens.SPACE_12,
                                                                              color: ColorsItem.greyB8BBBF,
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
                              Container(
                                child: RichTextView.editor(
                                  containerPadding: EdgeInsets.symmetric(
                                    vertical: Dimens.SPACE_15,
                                    horizontal: Dimens.SPACE_10,
                                  ),
                                  containerWidth: double.infinity,
                                  onChanged: (value) {
                                    // _controller.updateMessageFieldSize();
                                  },
                                  prefix: Container(
                                    padding: EdgeInsets.only(
                                        bottom: Dimens.SPACE_12),
                                    child: InkWell(
                                      onTap: () => _settingModalBottomSheet(),
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
                                    hintText:
                                        S.of(context).chat_message_box_hint,
                                    fillColor: Colors.grey,
                                    hintStyle: GoogleFonts.montserrat(
                                        color: ColorsItem.grey666B73),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 4,
                                  focusNode: _controller.isSendingMessage
                                      ? _controller.focusNodeMsg
                                      : null,
                                  mentionSuggestions:
                                      _controller.userSuggestion,
                                  onSearchPeople: (term) async {
                                    return _controller
                                        .filterUserSuggestion(term);
                                  },
                                  titleStyle: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                  ),
                                  subtitleStyle: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_12,
                                    color: ColorsItem.grey8D9299,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      );

  _popMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          _controller.goToEditPage();
        } else if (value == 2) {
          _controller.reportStickit();
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
        // PopupMenuItem(
        //   value: 0,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Container(
        //         width: Dimens.SPACE_25,
        //         child: FaIcon(
        //           FontAwesomeIcons.thumbtack,
        //
        //           size: Dimens.SPACE_16,
        //         ),
        //       ),
        //       Text(
        //         "${S.of(context).label_pin} ${S.of(context).label_stickit}",
        //         style: GoogleFonts.montserrat(
        //           color: ColorsItem.whiteE0E0E0,
        //           fontSize: Dimens.SPACE_14,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
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
                "${S.of(context).label_edit} ${S.of(context).label_stickit}",
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
                  FontAwesomeIcons.flag,
                  size: Dimens.SPACE_16,
                ),
              ),
              Text(
                "${S.of(context).label_report} ${S.of(context).label_stickit}",
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
              color: ColorsItem.black191C21,
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
                                color: ColorsItem.whiteFEFEFE.withOpacity(0.5)),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.SPACE_20,
                            vertical: Dimens.SPACE_10),
                        child: Center(
                          child: Text(S.of(context).chat_attach_title,
                              style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteColor,
                                  fontSize: Dimens.SPACE_20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 0.2,
                                color: ColorsItem.whiteFEFEFE.withOpacity(0.2)),
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
                                        color: ColorsItem.whiteFEFEFE
                                            .withOpacity(0.2)),
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
                                    SvgPicture.asset(
                                      ImageItem.IC_IMAGE,
                                      width: MediaQuery.of(context).size.width /
                                          12,
                                    ),
                                    SizedBox(
                                      width: Dimens.SPACE_10,
                                    ),
                                    Text(S.of(context).chat_attach_image_label,
                                        style: GoogleFonts.montserrat(
                                            color: ColorsItem.whiteColor,
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
                                        color: ColorsItem.whiteFEFEFE
                                            .withOpacity(0.2)),
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
                                    SvgPicture.asset(
                                      ImageItem.IC_VIDEO,
                                      width: MediaQuery.of(context).size.width /
                                          12,
                                    ),
                                    SizedBox(
                                      width: Dimens.SPACE_10,
                                    ),
                                    Text(S.of(context).chat_attach_video_label,
                                        style: GoogleFonts.montserrat(
                                            color: ColorsItem.whiteColor,
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
                                        color: ColorsItem.whiteFEFEFE
                                            .withOpacity(0.2)),
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
                                    SvgPicture.asset(
                                      ImageItem.IC_OPEN_FOLDER,
                                      width: MediaQuery.of(context).size.width /
                                          12,
                                    ),
                                    SizedBox(
                                      width: Dimens.SPACE_10,
                                    ),
                                    Text(
                                        S
                                            .of(context)
                                            .chat_attach_document_label,
                                        style: GoogleFonts.montserrat(
                                            color: ColorsItem.whiteColor,
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
