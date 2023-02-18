import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class DefaultFormField extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController textEditingController;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon, suffixIcon;
  final TextInputType? keyboardType;
  final void Function()? onTap;
  final Color? focusedBorderColor, enabledBorderColor;
  final BoxConstraints? prefixIconConstraints, suffixIconConstraints;
  final bool? isReadOnly;

  const DefaultFormField({
    required this.textEditingController,
    required this.onChanged,
    required this.hintText,
    this.prefixIconConstraints,
    this.label,
    this.prefixIcon,
    this.keyboardType,
    this.onTap,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!,
              style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
          SizedBox(height: Dimens.SPACE_8),
        ],
        TextField(
            readOnly: isReadOnly ?? false,
            onTap: () {
              if (onTap != null) {
                onTap!();
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            onChanged: onChanged,
            controller: textEditingController,
            style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
            decoration: InputDecoration(
              prefixIconConstraints: prefixIconConstraints,
              suffixIconConstraints: suffixIconConstraints,
              contentPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: focusedBorderColor != null
                      ? focusedBorderColor!
                      : ColorsItem.grey666B73,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: enabledBorderColor != null
                      ? enabledBorderColor!
                      : ColorsItem.grey666B73,
                ),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsItem.grey666B73)),
              hintStyle: GoogleFonts.montserrat(color: ColorsItem.grey666B73),
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
            keyboardType:
                keyboardType != null ? keyboardType : TextInputType.text),
      ],
    );
  }
}

class DefaultFormFieldWithAction extends StatelessWidget {
  final String label;
  final void Function() onTap;
  final List<Widget> children;
  final Widget icon;

  const DefaultFormFieldWithAction({
    required this.children,
    required this.label,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
        SizedBox(height: Dimens.SPACE_8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                border: Border.all(color: ColorsItem.grey888888, width: 1),
                borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: children,
                    ),
                  ),
                ),
                Container(
                  color: ColorsItem.grey666B73,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimens.SPACE_14),
                        child: icon,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DefaultFormFieldWithLongText extends StatelessWidget {
  final String label, hintText;
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;
  final int maxLines;
  final Color focusedBorderColor;
  final Color? enabledBorderColor;

  const DefaultFormFieldWithLongText({
    this.enabledBorderColor,
    required this.focusedBorderColor,
    required this.hintText,
    required this.label,
    required this.maxLines,
    required this.onChanged,
    required this.textEditingController,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
        SizedBox(height: Dimens.SPACE_8),
        TextField(
          onChanged: onChanged,
          controller: textEditingController,
          style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: focusedBorderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: enabledBorderColor != null
                    ? enabledBorderColor!
                    : ColorsItem.grey666B73,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: ColorsItem.grey666B73)),
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(color: ColorsItem.grey666B73),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
