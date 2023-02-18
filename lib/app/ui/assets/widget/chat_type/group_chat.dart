import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/chat_type/private_chat.dart';
import 'package:mobile_sev2/domain/reaction.dart';

class GroupChat extends StatefulWidget {
  final String author;
  final String time;
  final String avatar;
  final String message;
  final bool isSent;
  final ChatContentType type;
  final List<Reaction>? reactionList;
  final void Function()? onReact;
  final void Function()? onTap;
  final void Function(
          Map<String, List<Reaction>> reactionData, String reactionId)?
      onLongTapReaction;
  final void Function()? onProfileTap;
  final void Function(String url)? onOpenLink;
  final bool isReactable;
  final bool isReported;
  final void Function(PreviewData data)? onPreviewDataFetched;
  final PreviewData? data;
  final Function(LongPressStartDetails)? onLongPress;
  final Widget? icon;

  const GroupChat({
    Key? key,
    required this.author,
    required this.time,
    required this.avatar,
    required this.message,
    required this.type,
    this.isSent = true,
    this.reactionList = const [],
    this.onReact,
    this.onTap,
    this.onLongTapReaction,
    this.onProfileTap,
    this.onOpenLink,
    required this.isReactable,
    this.onPreviewDataFetched,
    this.data,
    this.onLongPress,
    this.icon,
    this.isReported = false,
  }) : super(key: key);

  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  late Map<String, List<Reaction>> _reactionData =
      Map<String, List<Reaction>>();

  @override
  Widget build(BuildContext context) {
    _mapReactionList();
    return GestureDetector(
        key: widget.key,
        behavior: HitTestBehavior.translucent,
        onLongPressStart: widget.onLongPress,
        child: _buildMainComponent());
  }

  Widget _buildMainComponent() {
    if (widget.type == ChatContentType.document) {
      return Container(
        padding: EdgeInsets.only(left: Dimens.SPACE_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.SPACE_6),
                  _buildHeaderComponent(),
                  if (widget.isReported == false)
                    Column(
                      children: [
                        SizedBox(height: Dimens.SPACE_8),
                        _buildReactionSection(),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: Dimens.SPACE_8),
            Divider(color: ColorsItem.grey666B73)
          ],
        ),
      );
    } else if (widget.type == ChatContentType.image) {
      return Container(
        padding: EdgeInsets.only(left: Dimens.SPACE_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.SPACE_6),
                  _buildHeaderComponent(),
                  if (widget.isReported == false)
                    Column(
                      children: [
                        SizedBox(height: Dimens.SPACE_8),
                        _buildReactionSection(),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: Dimens.SPACE_8),
            Divider(color: ColorsItem.grey666B73)
          ],
        ),
      );
    } else if (widget.type == ChatContentType.video) {
      return Container(
        padding: EdgeInsets.only(left: Dimens.SPACE_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.SPACE_6),
                  _buildHeaderComponent(),
                  SizedBox(height: Dimens.SPACE_4),
                  if (widget.isReported == false)
                    Column(
                      children: [
                        SizedBox(height: Dimens.SPACE_8),
                        _buildReactionSection(),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: Dimens.SPACE_8),
            Divider(color: ColorsItem.grey666B73)
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(left: Dimens.SPACE_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.SPACE_6),
                  _buildHeaderComponent(),
                  widget.data != null
                      ? SizedBox(height: Dimens.SPACE_6)
                      : SizedBox.shrink(),
                  if (widget.isReported == false) _buildReactionSection(),
                ],
              ),
            ),
            SizedBox(height: Dimens.SPACE_8),
            Divider(color: ColorsItem.grey666B73)
          ],
        ),
      );
    }
  }

  Widget _buildHeaderComponent() {
    return Row(
      children: [
        widget.icon != null ? widget.icon! : SizedBox(),
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: widget.onProfileTap,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: Colors.white)),
                  child: CircleAvatar(
                    radius: Dimens.SPACE_18,
                    backgroundImage: CachedNetworkImageProvider(widget.avatar),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(width: Dimens.SPACE_12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimens.SPACE_4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          " • ",
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.time,
                          style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_14,
                          ),
                        ),
                        SizedBox(width: Dimens.SPACE_6),
                        FaIcon(
                          widget.isSent
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.clock,
                          size: Dimens.SPACE_14,
                        )
                      ],
                    ),
                    if (widget.type == ChatContentType.document) ...[
                      SizedBox(height: Dimens.SPACE_4),
                      widget.isReported
                          ? Text(
                              S.of(context).chat_has_reported,
                              style: GoogleFonts.montserrat(
                                color: ColorsItem.greyB8BBBF,
                                fontSize: Dimens.SPACE_11,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : InkWell(
                              onTap: widget.isReported == false
                                  ? widget.onTap
                                  : () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimens.SPACE_4,
                                    horizontal: Dimens.SPACE_8),
                                decoration: BoxDecoration(
                                    color: ColorsItem.grey666B73,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.SPACE_4)),
                                child: Text(
                                  widget.message,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                    ] else if (widget.type == ChatContentType.image) ...[
                      SizedBox(height: Dimens.SPACE_8),
                      GestureDetector(
                        onTap:
                            widget.isReported == false ? widget.onTap : () {},
                        child: widget.isReported
                            ? Text(
                                S.of(context).chat_has_reported,
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.greyB8BBBF,
                                  fontSize: Dimens.SPACE_11,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Hero(
                                tag: widget.message,
                                child: CachedNetworkImage(
                                    imageUrl: widget.message),
                              ),
                      )
                    ] else if (widget.type == ChatContentType.video) ...[
                      SizedBox(height: Dimens.SPACE_8),
                      InkWell(
                        onTap:
                            widget.isReported == false ? widget.onTap : () {},
                        child: widget.isReported
                            ? Text(
                                S.of(context).chat_has_reported,
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.greyB8BBBF,
                                  fontSize: Dimens.SPACE_11,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.22,
                                decoration: BoxDecoration(
                                    color: ColorsItem.black020202,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.SPACE_12)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.circlePlay,
                                      size: Dimens.SPACE_40,
                                    )
                                  ],
                                ),
                              ),
                      )
                    ] else ...[
                      SizedBox(height: Dimens.SPACE_4),
                      LinkPreview(
                        padding: EdgeInsets.all(0),
                        enableAnimation: true,
                        onPreviewDataFetched: (data) {
                          if (widget.onPreviewDataFetched != null)
                            widget.onPreviewDataFetched!(data);
                        },
                        onLinkPressed: (link) {
                          if (widget.onOpenLink != null)
                            widget.onOpenLink!(link);
                        },
                        previewData: widget.data,
                        prefixes: const ['T', 'E'],
                        text: widget.isReported
                            ? S.of(context).chat_has_reported
                            : widget.message,
                        width: MediaQuery.of(context).size.width,
                        textStyle: GoogleFonts.montserrat(
                          fontSize: widget.isReported
                              ? Dimens.SPACE_11
                              : Dimens.SPACE_14,
                          fontStyle: widget.isReported
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                        linkStyle: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic,
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.urlColor,
                        ),
                        metadataTitleStyle: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_14,
                        ),
                        metadataTextStyle: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_12,
                          color: ColorsItem.grey666B73,
                        ),
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReactionSection() {
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
                              _reactionData, _reactionData[key]!.first.id);
                        }
                      : () {},
                  child: Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // FaIcon(
                        //   _reactionData[key]?.first.emoticon,
                        //   color: _reactionData[key]?.first.color,
                        //   size: Dimens.SPACE_18,
                        // ),
                        SvgPicture.asset(
                          _reactionData[key]!.first.emoticon!,
                          height: Dimens.SPACE_18,
                          width: Dimens.SPACE_18,
                        ),
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
    if (widget.reactionList != null) {
      _reactionData.clear();
      widget.reactionList!.forEach((element) {
        if (_reactionData.keys.contains(element.id)) {
          _reactionData[element.id]?.add(element);
        } else {
          _reactionData[element.id] = [element];
        }
      });
    }
  }
}
