import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/domain/reaction.dart';

class CommentItem extends StatefulWidget {
  final String avatar;
  final String user;
  final String comment;
  final String date;
  final List<Reaction> reactionList;
  final void Function()? onReact;

  const CommentItem(
      {Key? key,
      required this.avatar,
      required this.user,
      required this.comment,
      required this.date,
      required this.reactionList,
      this.onReact})
      : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(Dimens.SPACE_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2.0, color: Colors.white)),
                    child: CircleAvatar(
                      radius: Dimens.SPACE_20,
                      backgroundImage: CachedNetworkImageProvider(widget.avatar),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: Dimens.SPACE_8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_13, color: ColorsItem.whiteFEFEFE, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: Dimens.SPACE_4),
                      Text(
                        widget.comment,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_14, color: ColorsItem.greyB8BBBF, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: Dimens.SPACE_6),
                      Text(
                        widget.date,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_12, color: ColorsItem.grey666B73, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: Dimens.SPACE_12),
                      Row(
                        children: [
                          Wrap(
                            spacing: Dimens.SPACE_12,
                            children: List.generate(
                                widget.reactionList.length,
                                (index) => Container(
                                      child: Row(
                                        children: [
                                          // FaIcon(widget.reactionList[index].emoticon,
                                          //     color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_18),
                                          SvgPicture.asset(
                                            widget.reactionList[index].emoticon!,
                                            height: Dimens.SPACE_18,
                                            width: Dimens.SPACE_18,
                                          ),
                                          SizedBox(width: Dimens.SPACE_4),
                                          Text(
                                            "2", //TODO: count the same reaction
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_18, color: ColorsItem.whiteE0E0E0),
                                          ),
                                        ],
                                      ),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_5, vertical: Dimens.SPACE_4),
                                      decoration: BoxDecoration(
                                          color: ColorsItem.black32373D,
                                          borderRadius: BorderRadius.circular(Dimens.SPACE_8)),
                                    )),
                          ),
                          widget.reactionList.isEmpty ? SizedBox() : SizedBox(width: Dimens.SPACE_12),
                          InkWell(
                            onTap: widget.onReact,
                            child: Container(
                              child:
                                  FaIcon(FontAwesomeIcons.faceSmile, color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_18),
                              padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_5, vertical: Dimens.SPACE_4),
                              decoration: BoxDecoration(
                                  color: ColorsItem.black32373D, borderRadius: BorderRadius.circular(Dimens.SPACE_8)),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(color: ColorsItem.grey666B73, height: Dimens.SPACE_2, indent: Dimens.SPACE_20)
      ],
    );
  }
}
