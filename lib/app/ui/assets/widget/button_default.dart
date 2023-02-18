import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class ButtonDefault extends StatelessWidget {
  final String buttonText;
  final Color? buttonTextColor;
  final Color buttonColor;
  final Color buttonLineColor;
  final void Function()? onTap;
  final bool isDisabled;
  final bool isVisible;
  final Color disabledTextColor;
  final Color disabledButtonColor;
  final Color disabledLineColor;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final double? width;
  final double? fontSize;
  final Widget? buttonIcon;
  final Widget? rightIcon;
  final double radius;
  final double? letterSpacing;

  const ButtonDefault({
    required this.buttonText,
    this.buttonTextColor,
    required this.buttonColor,
    required this.buttonLineColor,
    required this.onTap,
    this.width,
    this.fontSize,
    this.paddingHorizontal,
    this.paddingVertical,
    this.isDisabled = false,
    this.disabledTextColor = const Color(0xff666B73),
    this.disabledButtonColor = const Color(0xff1F2329),
    this.disabledLineColor = const Color(0xff1F2329),
    this.buttonIcon,
    this.rightIcon,
    this.radius = Dimens.SPACE_20,
    this.isVisible = true,
    this.letterSpacing,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Visibility(
        visible: isVisible,
        child: Container(
          width: width,
          decoration: BoxDecoration(
              border: Border.all(
                color: isDisabled ? disabledLineColor : buttonLineColor,
                width: Dimens.SPACE_1,
              ),
              color: isDisabled ? disabledButtonColor : buttonColor,
              borderRadius: BorderRadius.all(Radius.circular(radius))),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: paddingVertical == null
                    ? Dimens.SPACE_12
                    : paddingVertical!,
                horizontal: paddingHorizontal == null
                    ? Dimens.SPACE_12
                    : paddingHorizontal!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buttonIcon == null
                    ? SizedBox()
                    : Row(
                        children: [
                          buttonIcon!,
                          SizedBox(width: Dimens.SPACE_6)
                        ],
                      ),
                Row(
                  children: [
                    Text(
                      buttonText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          fontSize: fontSize != null ? fontSize : 14.0,
                          color: isDisabled
                              ? disabledTextColor
                              : buttonTextColor != null
                                  ? buttonTextColor
                                  : null,
                          fontWeight: FontWeight.w700,
                          letterSpacing: letterSpacing),
                    ),
                    rightIcon == null
                        ? SizedBox()
                        : SizedBox(width: Dimens.SPACE_6)
                  ],
                ),
                rightIcon == null
                    ? SizedBox()
                    : Row(
                        children: [rightIcon!, SizedBox(width: Dimens.SPACE_6)],
                      ),
                buttonIcon == null
                    ? SizedBox()
                    : SizedBox(width: Dimens.SPACE_4)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
