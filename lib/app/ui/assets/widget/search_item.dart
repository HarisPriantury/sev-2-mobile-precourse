import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class SearchItem extends StatelessWidget {
  final String title;
  final String? desc;
  final Widget? thisIcon;
  final double? verticalPadding;
  final void Function()? onOpen;
  final void Function()? onDownload;
  final bool isAlreadyDownload;
  final bool isFile;

  const SearchItem(
      {required this.title,
      this.desc,
      this.thisIcon,
      this.verticalPadding,
      this.onOpen,
      this.onDownload,
      this.isAlreadyDownload = false,
      this.isFile = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical:
              verticalPadding != null ? verticalPadding! : Dimens.SPACE_10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5),
        ),
      ),
      child: !isFile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                    color: ColorsItem.urlColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
                thisIcon != null || desc != null
                    ? SizedBox(height: Dimens.SPACE_4)
                    : SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    thisIcon != null
                        ? Container(
                            margin: EdgeInsets.only(right: Dimens.SPACE_4),
                            child: thisIcon!)
                        : SizedBox(),
                    desc != null
                        ? Text(
                            desc!,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ],
            )
          : InkWell(
              onTap: isAlreadyDownload ? onOpen : onDownload,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16,
                      color: ColorsItem.urlColor,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  thisIcon != null || desc != null
                      ? SizedBox(height: Dimens.SPACE_4)
                      : SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      thisIcon != null
                          ? Container(
                              margin: EdgeInsets.only(right: Dimens.SPACE_4),
                              child: thisIcon!)
                          : SizedBox(),
                      desc != null
                          ? Text(
                              desc!,
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
