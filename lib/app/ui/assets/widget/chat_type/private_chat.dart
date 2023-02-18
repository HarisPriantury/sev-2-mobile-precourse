import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:percent_indicator/percent_indicator.dart';

class PrivateChat extends StatefulWidget {
  final BuildContext context;
  final String message;
  final String time;
  final bool isSent;
  final bool isAuthor;
  final ChatContentType type;
  final Color? backgroundColor;
  final void Function()? onTap;
  final void Function(String url)? onOpenLink;
  final void Function(PreviewData data)? onPreviewDataFetched;
  final PreviewData? data;
  final bool isAlreadyDownloaded;
  final DownloadTaskStatus? status;
  final int progress;
  final Function(LongPressStartDetails)? onLongPress;
  final Function(DragUpdateDetails)? onPanUpdate;
  final Widget? icon;
  final String? senderRepliedMessage;
  final String? repliedMessage;

  const PrivateChat({
    Key? key,
    required this.context,
    required this.message,
    required this.time,
    this.isSent = true,
    required this.isAuthor,
    required this.type,
    this.backgroundColor,
    this.onTap,
    this.onOpenLink,
    this.onPreviewDataFetched,
    this.data,
    this.isAlreadyDownloaded = true,
    this.status,
    this.progress = 0,
    this.onLongPress,
    this.icon,
    this.senderRepliedMessage,
    this.repliedMessage,
    this.onPanUpdate,
  }) : super(key: key);

  @override
  _PrivateChatState createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat>
    with SingleTickerProviderStateMixin {
  late final AnimationController controllerAnimation;
  @override
  void initState() {
    super.initState();
    controllerAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == ChatContentType.document) {
      return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 1) {
            controllerAnimation.forward().whenComplete(() {
              controllerAnimation.reverse();
              widget.onPanUpdate?.call(details);
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        onLongPressStart: widget.onLongPress,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.3, 0.0),
          ).animate(
            CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              parent: controllerAnimation,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: widget.isAuthor
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: widget.onTap,
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: EdgeInsets.symmetric(
                        vertical: Dimens.SPACE_20, horizontal: Dimens.SPACE_12),
                    decoration: BoxDecoration(
                        color: ColorsItem.greyCCECEF.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(Dimens.SPACE_12)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.icon != null
                            ? widget.isAuthor
                                ? Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [widget.icon!],
                                    ),
                                  )
                                : widget.icon!
                            : SizedBox(),
                        SizedBox(
                          child: widget.isAlreadyDownloaded
                              ? SizedBox()
                              : widget.status == DownloadTaskStatus.running
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          right: Dimens.SPACE_14),
                                      child: CircularPercentIndicator(
                                        radius: Dimens.SPACE_30,
                                        lineWidth: Dimens.SPACE_3,
                                        percent:
                                            (widget.progress / 100).toDouble(),
                                        center: Icon(
                                          FontAwesomeIcons.downLong,
                                          color: ColorsItem.orangeFA8C16,
                                          size: Dimens.SPACE_13,
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        backgroundColor: ColorsItem.grey858A93,
                                        progressColor: ColorsItem.orangeFA8C16,
                                      ),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(
                                          right: Dimens.SPACE_14),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: Dimens.SPACE_3,
                                              color: ColorsItem.grey858A93)),
                                      child: Padding(
                                        padding: EdgeInsets.all(Dimens.SPACE_6),
                                        child: Icon(
                                          FontAwesomeIcons.downLong,
                                          color: ColorsItem.orangeFA8C16,
                                          size: Dimens.SPACE_12,
                                        ),
                                      ),
                                    ),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.all(Dimens.SPACE_8),
                            decoration: BoxDecoration(
                                color: ColorsItem.grey666B73,
                                borderRadius:
                                    BorderRadius.circular(Dimens.SPACE_4)),
                            child: Text(
                              widget.message,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.whiteFEFEFE,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: Dimens.SPACE_10),
                        Text(
                          widget.time,
                          style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_12,
                            color: ColorsItem.grey666B73,
                          ),
                        ),
                        SizedBox(width: Dimens.SPACE_10),
                        FaIcon(
                          widget.isSent
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.clock,
                          color: ColorsItem.whiteFEFEFE,
                          size: Dimens.SPACE_14,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else if (widget.type == ChatContentType.video) {
      return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 1) {
            controllerAnimation.forward().whenComplete(() {
              controllerAnimation.reverse();
              widget.onPanUpdate?.call(details);
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        onLongPressStart: widget.onLongPress,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.3, 0.0),
          ).animate(
            CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              parent: controllerAnimation,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: widget.isAuthor
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                widget.icon != null
                    ? widget.isAuthor
                        ? Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [widget.icon!],
                            ),
                          )
                        : widget.icon!
                    : SizedBox(),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  padding: EdgeInsets.all(Dimens.SPACE_12),
                  decoration: BoxDecoration(
                    color: ColorsItem.greyCCECEF.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(Dimens.SPACE_12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: Dimens.SPACE_8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.time,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  color: ColorsItem.grey666B73),
                            ),
                            SizedBox(width: Dimens.SPACE_6),
                            FaIcon(
                              widget.isSent
                                  ? FontAwesomeIcons.check
                                  : FontAwesomeIcons.clock,
                              color: ColorsItem.whiteFEFEFE,
                              size: Dimens.SPACE_14,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_6),
                      InkWell(
                        onTap: widget.onTap,
                        child: Container(
                          decoration: BoxDecoration(
                              color: ColorsItem.black020202,
                              borderRadius:
                                  BorderRadius.circular(Dimens.SPACE_12)),
                          padding:
                              EdgeInsets.symmetric(vertical: Dimens.SPACE_50),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.circlePlay,
                                color: ColorsItem.whiteE0E0E0,
                                size: Dimens.SPACE_40,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (widget.type == ChatContentType.image) {
      return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 1) {
            controllerAnimation.forward().whenComplete(() {
              controllerAnimation.reverse();
              widget.onPanUpdate?.call(details);
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        onLongPressStart: widget.onLongPress,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.3, 0.0),
          ).animate(
            CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              parent: controllerAnimation,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: widget.isAuthor
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                widget.icon != null
                    ? widget.isAuthor
                        ? Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [widget.icon!],
                            ),
                          )
                        : widget.icon!
                    : SizedBox(),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  padding: EdgeInsets.all(Dimens.SPACE_12),
                  decoration: BoxDecoration(
                    color: ColorsItem.greyCCECEF.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(Dimens.SPACE_12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: widget.onTap,
                            child: Hero(
                                tag: widget.message,
                                child: CachedNetworkImage(
                                    imageUrl: widget.message))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: Dimens.SPACE_8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.time,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  color: ColorsItem.grey666B73),
                            ),
                            SizedBox(width: Dimens.SPACE_6),
                            FaIcon(
                              widget.isSent
                                  ? FontAwesomeIcons.check
                                  : FontAwesomeIcons.clock,
                              color: ColorsItem.whiteFEFEFE,
                              size: Dimens.SPACE_14,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 1) {
            controllerAnimation.forward().whenComplete(() {
              controllerAnimation.reverse();
              widget.onPanUpdate?.call(details);
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        onLongPressStart: widget.onLongPress,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 0.0),
            end: const Offset(0.3, 0.0),
          ).animate(
            CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              parent: controllerAnimation,
            ),
          ),
          child: Container(
            color: widget.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: widget.isAuthor
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                widget.icon != null
                    ? widget.isAuthor
                        ? Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [widget.icon!],
                            ),
                          )
                        : widget.icon!
                    : SizedBox(),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  padding: EdgeInsets.only(
                      left: Dimens.SPACE_12,
                      right: Dimens.SPACE_12,
                      top: Dimens.SPACE_12,
                      bottom: Dimens.SPACE_2),
                  decoration: BoxDecoration(
                      color: ColorsItem.greyCCECEF.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(Dimens.SPACE_12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.repliedMessage != null &&
                          widget.repliedMessage != "") ...[
                        Container(
                          padding: EdgeInsets.only(
                            left: Dimens.SPACE_8,
                            right: Dimens.SPACE_12,
                            top: Dimens.SPACE_4,
                            bottom: Dimens.SPACE_4,
                          ),
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          decoration: BoxDecoration(
                              color: ColorsItem.white9E9E9E.withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.circular(Dimens.SPACE_4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.senderRepliedMessage != null) ...[
                                Text(
                                  "${widget.senderRepliedMessage}",
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12),
                                ),
                              ],
                              Text(
                                widget.repliedMessage ?? "",
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.SPACE_8),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: LinkPreview(
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
                              text: widget.repliedMessage != ""
                                  ? widget.message.split("\n").last
                                  : widget.message,
                              width: MediaQuery.of(context).size.width,
                              textStyle: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14),
                              prefixes: const ['T', 'E'],
                              linkStyle: GoogleFonts.montserrat(
                                  fontStyle: FontStyle.italic,
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.urlColor),
                              metadataTitleStyle: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.whiteFEFEFE),
                              metadataTextStyle: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  color: ColorsItem.grey666B73),
                            ),
                          ),
                          SizedBox(height: Dimens.SPACE_4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.time,
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_12),
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
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

enum ChatContentType { text, document, image, video }
