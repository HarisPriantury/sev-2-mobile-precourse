import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class BoardTicketItem extends StatelessWidget {
  final String code;
  final String title;
  final double? point;
  final String? avatar;
  final Function()? onTap;

  const BoardTicketItem({
    required this.code,
    required this.title,
    this.point,
    this.avatar,
    this.onTap,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimens.SPACE_16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(Dimens.SPACE_4),
              decoration: BoxDecoration(
                color: ColorsItem.grey666B73,
                borderRadius: BorderRadius.circular(Dimens.SPACE_4),
              ),
              child: Text(
                code,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: Dimens.SPACE_6),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                  // color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: Dimens.SPACE_6),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsItem.green219653,
              ),
              padding: EdgeInsets.all(Dimens.SPACE_7),
              child: Text(
                point.toString(),
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                  fontWeight: FontWeight.w700,
                  color: ColorsItem.whiteFEFEFE,
                ),
              ),
            ),
            // CircleAvatar(
            //   radius: Dimens.SPACE_12,
            //   backgroundColor: ColorsItem.green219653,
            //   child: Center(
            //     child: Text(
            //       "$point",
            //       textAlign: TextAlign.center,
            //       style: GoogleFonts.montserrat(
            //         fontSize: Dimens.SPACE_16,
            //         color: Colors.white,
            //         fontWeight: FontWeight.w600,
            //         letterSpacing: 1.5,
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(width: Dimens.SPACE_6),
            CircleAvatar(
              radius: Dimens.SPACE_15,
              backgroundImage: CachedNetworkImageProvider(avatar!),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: Dimens.SPACE_6),
          ],
        ),
      ),
    );
  }
}
