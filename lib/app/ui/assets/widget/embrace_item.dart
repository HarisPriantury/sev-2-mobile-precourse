import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/domain/reaction.dart';

class EmbraceItem extends StatefulWidget {
  final String owner;
  final String avatar;
  final String date;
  final String projectTitle;
  final String embraceType;
  final String embraceTitle;
  final String embraceDescription;
  final List<Reaction> reactionList;
  final List<String> commentList;
  final bool hasImage;
  final void Function()? onTap;
  final void Function()? onReact;

  const EmbraceItem(
      {Key? key,
      required this.owner,
      required this.avatar,
      required this.embraceType,
      required this.embraceTitle,
      required this.embraceDescription,
      required this.reactionList,
      required this.commentList,
      required this.date,
      required this.projectTitle,
      this.hasImage = false,
      this.onTap,
      this.onReact})
      : super(key: key);

  @override
  _EmbraceItemState createState() => _EmbraceItemState();
}

class _EmbraceItemState extends State<EmbraceItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
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
                          widget.owner,
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14, color: ColorsItem.whiteFEFEFE, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: Dimens.SPACE_4),
                        Text(
                          widget.embraceType,
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12, color: ColorsItem.grey666B73, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: Dimens.SPACE_6),
                        Text(
                          "${widget.date}・${widget.projectTitle}",
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12, color: ColorsItem.grey666B73, fontWeight: FontWeight.w500),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: Dimens.SPACE_14),
                widget.hasImage
                    ? Container(
                        width: double.infinity, child: SvgPicture.asset(ImageItem.EMBRACE_PARTY, fit: BoxFit.contain))
                    : SizedBox(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimens.SPACE_8),
                      border: Border.all(width: 1.5, color: ColorsItem.grey666B73.withOpacity(0.5))),
                  padding: EdgeInsets.all(Dimens.SPACE_14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.embraceTitle,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_14, color: ColorsItem.whiteFEFEFE, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: Dimens.SPACE_20),
                      Text(
                        widget.embraceDescription,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_14, color: ColorsItem.greyB8BBBF, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
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
                                padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_5, vertical: Dimens.SPACE_4),
                                decoration: BoxDecoration(
                                    color: ColorsItem.black32373D, borderRadius: BorderRadius.circular(Dimens.SPACE_8)),
                              )),
                    ),
                    widget.reactionList.isEmpty ? SizedBox() : SizedBox(width: Dimens.SPACE_12),
                    InkWell(
                      onTap: widget.onReact,
                      child: Container(
                        child: FaIcon(FontAwesomeIcons.faceSmile, color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_18),
                        padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_5, vertical: Dimens.SPACE_4),
                        decoration: BoxDecoration(
                            color: ColorsItem.black32373D, borderRadius: BorderRadius.circular(Dimens.SPACE_8)),
                      ),
                    )
                  ],
                ),
                widget.commentList.isNotEmpty ? SizedBox(height: Dimens.SPACE_8) : SizedBox(),
                widget.commentList.isNotEmpty
                    ? Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Divider(color: ColorsItem.grey666B73, height: Dimens.SPACE_2),
                          Padding(
                            padding: const EdgeInsets.only(left: Dimens.SPACE_30),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_6, horizontal: Dimens.SPACE_8),
                              decoration: BoxDecoration(
                                  color: ColorsItem.grey666B73, borderRadius: BorderRadius.circular(Dimens.SPACE_20)),
                              child: Text(
                                "${widget.commentList.length} Comments",
                                style: GoogleFonts.montserrat(
                                    color: ColorsItem.black1F2329,
                                    fontSize: Dimens.SPACE_12,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
          Divider(color: ColorsItem.grey666B73, height: Dimens.SPACE_2, indent: Dimens.SPACE_20)
        ],
      ),
    );
  }
}
