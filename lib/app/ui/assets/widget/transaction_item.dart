import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:styled_text/styled_text.dart' as StyledText;
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class TransactionItem extends StatefulWidget {
  final String avatar;
  final String transactionAuthor;
  final String transactionContent;
  final String dateTime;
  final bool isReactable;
  final bool isActionable;
  final bool hasHeader;
  final String type;
  final String headerText;
  final Color? backgroundColor;
  final List<Reaction> reactionList;
  final List<File> attachments;
  final void Function()? onReact;
  final void Function(
    Map<String, List<Reaction>> reactionData,
    String reactionId,
  )? onLongTapReaction;
  final int? maxLines;
  final void Function(String url)? onOpenLink;
  final void Function(PreviewData data)? onPreviewDataFetched;
  final PreviewData? data;
  final void Function(int index)? onTap;

  const TransactionItem({
    Key? key,
    required this.avatar,
    required this.transactionAuthor,
    required this.transactionContent,
    required this.dateTime,
    this.isReactable = false,
    this.isActionable = false,
    this.hasHeader = false,
    this.type = "",
    this.headerText = "",
    this.backgroundColor,
    this.reactionList = const [],
    this.attachments = const [],
    this.onReact,
    this.onLongTapReaction,
    this.maxLines,
    this.onOpenLink,
    this.onPreviewDataFetched,
    this.data,
    this.onTap,
  }) : super(key: key);

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Map<String, List<Reaction>> _reactionData =
      Map<String, List<Reaction>>();

  @override
  Widget build(BuildContext context) {
    _mapReactionList();
    return Container(
      padding: EdgeInsets.only(left: Dimens.SPACE_20),
      color: widget.backgroundColor ?? null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: Dimens.SPACE_20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimens.SPACE_6),
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: Dimens.SPACE_1)),
                            child: CircleAvatar(
                              radius: Dimens.SPACE_20,
                              backgroundImage:
                                  CachedNetworkImageProvider(widget.avatar),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(width: Dimens.SPACE_12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.hasHeader
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          bottom: Dimens.SPACE_4,
                                        ),
                                        child: Text(
                                          widget.headerText,
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w400,
                                            fontSize: Dimens.SPACE_14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : SizedBox(height: Dimens.SPACE_4),
                                if (widget.type == 'document' ||
                                    widget.type == 'image' ||
                                    widget.type == 'video') ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StyledText.StyledText(
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14),
                                        text: widget.transactionAuthor,
                                        tags: {
                                          'bold': StyledText.StyledTextTag(
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          'highlight': StyledText.StyledTextTag(
                                              style: TextStyle(
                                                  color:
                                                      ColorsItem.blue3FB5ED)),
                                        },
                                      ),
                                      SizedBox(height: Dimens.SPACE_4),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(
                                            widget.attachments.length,
                                            (index) => Column(children: [
                                                  if (widget.attachments[index]
                                                          .fileType ==
                                                      FileType.document) ...[
                                                    SizedBox(
                                                        height: Dimens.SPACE_8),
                                                    InkWell(
                                                      onTap: () {
                                                        widget.onTap!(index);
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: Dimens
                                                                    .SPACE_4,
                                                                horizontal: Dimens
                                                                    .SPACE_8),
                                                        decoration: BoxDecoration(
                                                            color: ColorsItem
                                                                .grey666B73,
                                                            borderRadius: BorderRadius
                                                                .circular(Dimens
                                                                    .SPACE_4)),
                                                        child: Text(
                                                          widget
                                                              .attachments[
                                                                  index]
                                                              .title,
                                                          style: GoogleFonts.montserrat(
                                                              fontSize: Dimens
                                                                  .SPACE_14,
                                                              color: ColorsItem
                                                                  .whiteFEFEFE,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ] else if (widget
                                                          .attachments[index]
                                                          .fileType ==
                                                      FileType.image) ...[
                                                    SizedBox(
                                                        height: Dimens.SPACE_8),
                                                    GestureDetector(
                                                        onTap: () {
                                                          widget.onTap!(index);
                                                        },
                                                        child: Hero(
                                                            tag: widget
                                                                .attachments[
                                                                    index]
                                                                .url,
                                                            child: widget
                                                                    .attachments[
                                                                        index]
                                                                    .url
                                                                    .isEmpty
                                                                ? SizedBox()
                                                                : CachedNetworkImage(
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            SizedBox(),
                                                                    imageUrl: widget
                                                                        .attachments[
                                                                            index]
                                                                        .url))),
                                                  ] else if (widget
                                                          .attachments[index]
                                                          .fileType ==
                                                      FileType.video) ...[
                                                    SizedBox(
                                                        height: Dimens.SPACE_8),
                                                    InkWell(
                                                      onTap: () {
                                                        widget.onTap!(index);
                                                      },
                                                      child: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.22,
                                                        decoration: BoxDecoration(
                                                            color: ColorsItem
                                                                .black020202,
                                                            borderRadius: BorderRadius
                                                                .circular(Dimens
                                                                    .SPACE_12)),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            FaIcon(
                                                              FontAwesomeIcons
                                                                  .circlePlay,
                                                              color: ColorsItem
                                                                  .whiteE0E0E0,
                                                              size: Dimens
                                                                  .SPACE_40,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ])),
                                      ),
                                      if (DataUtil.deleteFileIdFromTransactionContent(
                                                  widget.attachments,
                                                  DataUtil.removeAllHtmlTags(
                                                      widget
                                                          .transactionContent))
                                              .length !=
                                          0) ...[
                                        SizedBox(height: Dimens.SPACE_8),
                                        LinkPreview(
                                          padding: EdgeInsets.all(0),
                                          enableAnimation: true,
                                          onPreviewDataFetched: (data) {
                                            if (widget.onPreviewDataFetched !=
                                                null)
                                              widget
                                                  .onPreviewDataFetched!(data);
                                          },
                                          onLinkPressed: (link) {
                                            if (widget.onOpenLink != null)
                                              widget.onOpenLink!(link);
                                          },
                                          previewData: widget.data,
                                          text: DataUtil
                                              .deleteFileIdFromTransactionContent(
                                                  widget.attachments,
                                                  DataUtil.removeAllHtmlTags(
                                                      widget
                                                          .transactionContent)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          textStyle: GoogleFonts.montserrat(
                                            color: ColorsItem.greyB8BBBF,
                                            fontSize: Dimens.SPACE_14,
                                          ),
                                          linkStyle: GoogleFonts.montserrat(
                                            fontStyle: FontStyle.italic,
                                            fontSize: Dimens.SPACE_14,
                                            color: ColorsItem.urlColor,
                                          ),
                                          metadataTitleStyle:
                                              GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14,
                                            color: ColorsItem.whiteFEFEFE,
                                          ),
                                          metadataTextStyle:
                                              GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_12,
                                            color: ColorsItem.grey666B73,
                                          ),
                                        )
                                      ]
                                    ],
                                  ),
                                ] else if (widget.isReactable ||
                                    widget.type == 'description') ...[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StyledText.StyledText(
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14),
                                        text: widget.transactionAuthor,
                                        tags: {
                                          'bold': StyledText.StyledTextTag(
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          'highlight': StyledText.StyledTextTag(
                                              style: TextStyle(
                                                  color:
                                                      ColorsItem.blue3FB5ED)),
                                        },
                                      ),
                                      SizedBox(height: Dimens.SPACE_4),
                                      widget.attachments.isEmpty
                                          ? LinkPreview(
                                              padding: EdgeInsets.all(0),
                                              enableAnimation: true,
                                              onPreviewDataFetched: (data) {
                                                if (widget
                                                        .onPreviewDataFetched !=
                                                    null)
                                                  widget.onPreviewDataFetched!(
                                                      data);
                                              },
                                              onLinkPressed: (link) {
                                                if (widget.onOpenLink != null)
                                                  widget.onOpenLink!(link);
                                              },
                                              previewData: widget.data,
                                              text: DataUtil.removeAllHtmlTags(
                                                  widget.transactionContent),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              textStyle: GoogleFonts.montserrat(
                                                color: ColorsItem.greyB8BBBF,
                                                fontSize: Dimens.SPACE_14,
                                              ),
                                              linkStyle: GoogleFonts.montserrat(
                                                fontStyle: FontStyle.italic,
                                                fontSize: Dimens.SPACE_14,
                                                color: ColorsItem.urlColor,
                                              ),
                                              metadataTitleStyle:
                                                  GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                color: ColorsItem.whiteFEFEFE,
                                              ),
                                              metadataTextStyle:
                                                  GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_12,
                                                color: ColorsItem.grey666B73,
                                              ),
                                            )
                                          : HtmlWidget(
                                              """${widget.transactionContent}""",
                                              textStyle: TextStyle(
                                                fontSize: Dimens.SPACE_12,
                                                color: ColorsItem.greyB8BBBF,
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                    ],
                                  )
                                ] else ...[
                                  StyledText.StyledText(
                                    style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14,
                                    ),
                                    text:
                                        "${widget.transactionAuthor} ${widget.transactionContent}",
                                    tags: {
                                      'bold': StyledText.StyledTextTag(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      'highlight': StyledText.StyledTextTag(
                                        style: TextStyle(
                                          color: ColorsItem.blue3FB5ED,
                                        ),
                                      ),
                                    },
                                    maxLines: widget.maxLines ?? null,
                                    overflow: widget.maxLines != null
                                        ? TextOverflow.ellipsis
                                        : TextOverflow.clip,
                                  ),
                                ],
                                SizedBox(height: Dimens.SPACE_4),
                                Text(
                                  widget.dateTime,
                                  style: GoogleFonts.montserrat(
                                      color: ColorsItem.grey666B73,
                                      fontSize: Dimens.SPACE_12),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                widget.isActionable
                    ? Padding(
                        padding: const EdgeInsets.only(top: Dimens.SPACE_12),
                        child: Row(
                          children: [
                            SizedBox(width: 52),
                            Expanded(
                              flex: 1,
                              child: ButtonDefault(
                                  buttonText: "Tolak".toUpperCase(),
                                  buttonTextColor: ColorsItem.whiteFEFEFE,
                                  buttonColor: Colors.transparent,
                                  buttonLineColor: ColorsItem.whiteFEFEFE,
                                  radius: Dimens.SPACE_8,
                                  fontSize: Dimens.SPACE_12,
                                  letterSpacing: 1.5,
                                  onTap: () {}),
                            ),
                            SizedBox(width: Dimens.SPACE_12),
                            Expanded(
                              flex: 1,
                              child: ButtonDefault(
                                  buttonText: "Join".toUpperCase(),
                                  buttonTextColor: ColorsItem.black020202,
                                  buttonColor: ColorsItem.orangeFB9600,
                                  buttonLineColor: Colors.transparent,
                                  radius: Dimens.SPACE_8,
                                  fontSize: Dimens.SPACE_12,
                                  letterSpacing: 1.5,
                                  onTap: () {}),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                widget.isReactable
                    ? Column(
                        children: [
                          SizedBox(height: Dimens.SPACE_8),
                          _buildReactionSection(),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
          SizedBox(height: Dimens.SPACE_8),
          Divider(color: ColorsItem.grey666B73)
        ],
      ),
    );
  }

  Padding _buildReactionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 52),
      child: _reactionData.isNotEmpty && widget.isReactable
          ? Wrap(
              spacing: Dimens.SPACE_8,
              runSpacing: Dimens.SPACE_6,
              children: List.generate(_reactionData.length + 1, (index) {
                if (index == _reactionData.length) {
                  return _buildReactAction();
                }
                String key = _reactionData.keys.elementAt(index);
                return InkWell(
                  onLongPress: widget.onLongTapReaction != null
                      ? () {
                          widget.onLongTapReaction!(
                            _reactionData,
                            _reactionData[key]!.first.id,
                          );
                        }
                      : () {},
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          _reactionData[key]!.first.emoticon!,
                          height: Dimens.SPACE_18,
                          width: Dimens.SPACE_18,
                        ),
                        // FaIcon(
                        //   _reactionData[key]?.first.emoticon,
                        //   color: _reactionData[key]?.first.color,
                        //   size: Dimens.SPACE_18,
                        // ),
                        SizedBox(width: Dimens.SPACE_4),
                        Text(
                          (_reactionData[key]?.length.toString() ?? "1"),
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14,
                              color: ColorsItem.whiteE0E0E0),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.SPACE_5, vertical: Dimens.SPACE_4),
                    decoration: BoxDecoration(
                      color: ColorsItem.black32373D,
                      borderRadius: BorderRadius.circular(Dimens.SPACE_8),
                    ),
                  ),
                );
              }),
            )
          : _buildReactAction(),
    );
  }

  Widget _buildReactAction() {
    if (widget.isReactable) {
      return InkWell(
        onTap: widget.onReact,
        child: Container(
          child: FaIcon(FontAwesomeIcons.faceSmile,
              color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_18),
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_5, vertical: Dimens.SPACE_4),
          decoration: BoxDecoration(
              color: ColorsItem.black32373D,
              borderRadius: BorderRadius.circular(Dimens.SPACE_8)),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  _mapReactionList() {
    _reactionData.clear();
    widget.reactionList.forEach((element) {
      if (_reactionData.keys.contains(element.id)) {
        _reactionData[element.id]?.add(element);
      } else {
        _reactionData[element.id] = [element];
      }
    });
  }
}
