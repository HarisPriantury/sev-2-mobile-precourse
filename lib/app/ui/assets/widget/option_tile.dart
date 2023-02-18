import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class OptionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? endIcon;
  final double paddingValue;
  final void Function()? onTap;
  final double subtitleMargin;

  const OptionTile(
      {Key? key,
      required this.title,
      this.subtitle,
      this.endIcon,
      this.paddingValue = Dimens.SPACE_20,
      this.onTap,
      this.subtitleMargin = Dimens.SPACE_8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(paddingValue),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14),
                    ),
                    subtitle != null
                        ? SizedBox(height: subtitleMargin)
                        : SizedBox(),
                    subtitle != null
                        ? subtitle!.isNotEmpty
                            ? Text(
                                subtitle!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    color: ColorsItem.grey666B73,
                                    fontSize: Dimens.SPACE_14),
                              )
                            : SizedBox()
                        : SizedBox()
                  ],
                )),
                endIcon != null ? endIcon! : SizedBox(),
              ],
            ),
          ),
          Divider(
            height: 0,
            color: ColorsItem.grey666B73,
            indent: paddingValue,
          )
        ],
      ),
    );
  }
}
