import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class MessageListItem extends StatefulWidget {
  final String username;
  final String message;
  final String avatar;
  final String time;
  final int unreadMessageCount;
  final bool? isUser;
  final Color? statusColor;
  final void Function()? onTap;

  const MessageListItem(
      {Key? key,
      required this.username,
      required this.message,
      required this.avatar,
      required this.time,
      this.unreadMessageCount = 0,
      this.isUser = true,
      this.statusColor,
      this.onTap})
      : super(key: key);

  @override
  _MessageListItemState createState() => _MessageListItemState();
}

class _MessageListItemState extends State<MessageListItem> {
  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: Theme.of(context),
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.isUser!
                      ? CircleAvatar(
                          radius: Dimens.SPACE_5,
                          backgroundColor:
                              widget.statusColor ?? ColorsItem.grey606060,
                        )
                      : SizedBox(),
                  SizedBox(width: Dimens.SPACE_12),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: ColorsItem.white9E9E9E,
                            width: Dimens.SPACE_2)),
                    child: CircleAvatar(
                      radius: Dimens.SPACE_20,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.avatar,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: Dimens.SPACE_12),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.username,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Text(
                              widget.time,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.grey666B73),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.SPACE_4),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.message,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    color: ColorsItem.grey666B73),
                              ),
                            ),
                            widget.unreadMessageCount > 0
                                ? Container(
                                    padding: EdgeInsets.all(Dimens.SPACE_6),
                                    decoration: BoxDecoration(
                                        color: ColorsItem.blue38A1D3,
                                        shape: BoxShape.circle),
                                    child: Text(
                                      widget.unreadMessageCount > 5
                                          ? "5+"
                                          : widget.unreadMessageCount
                                              .toString(),
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_10,
                                          color: ColorsItem.black1F2329),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: ColorsItem.grey666B73, indent: Dimens.SPACE_20)
          ],
        ),
      ),
    );
  }
}
