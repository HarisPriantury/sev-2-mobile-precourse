import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class DetailHead extends StatelessWidget {
  final Widget? icon;
  final Widget? popupMenu;
  final String title;
  final String? subtitle;

  const DetailHead({
    this.icon,
    required this.title,
    this.subtitle,
    this.popupMenu,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: Dimens.SPACE_2),
                      child: icon!,
                    )
                  : SizedBox(),
              icon != null ? SizedBox(width: Dimens.SPACE_12) : SizedBox(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_6),
                    subtitle != null
                        ? Text(
                            subtitle!,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12,
                              color: ColorsItem.grey666B73,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              SizedBox(width: Dimens.SPACE_4),
              popupMenu != null ? popupMenu! : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
