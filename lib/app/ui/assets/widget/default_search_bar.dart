import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class SearchBar extends StatelessWidget {
  final BoxBorder? border;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? innerPadding;
  final EdgeInsetsGeometry? outerPadding;
  final void Function()? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final Widget? endIcon;
  final bool? clear;
  final String filterValue;
  final void Function()? clearTap;
  final String? buttonText;

  const SearchBar(
      {this.hintText,
      this.textStyle,
      this.hintStyle,
      this.border,
      this.backgroundColor,
      this.borderRadius,
      this.onTap,
      this.controller,
      this.focusNode,
      this.onChanged,
      this.endIcon,
      this.innerPadding,
      this.outerPadding,
      this.clear = false,
      this.filterValue = "",
      this.clearTap,
      required this.buttonText})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
                padding: outerPadding,
                decoration: BoxDecoration(
                    border: border,
                    color: backgroundColor,
                    borderRadius: borderRadius),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: endIcon,
                    ),
                    Flexible(
                      child: Container(
                        padding: filterValue.isNotEmpty
                            ? EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_10,
                                vertical: Dimens.SPACE_6)
                            : innerPadding,
                        child: filterValue.isNotEmpty
                            ? Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(Dimens.SPACE_5),
                                      decoration: BoxDecoration(
                                          // color: ColorsItem.grey666B73,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6.0))),
                                      child: Text(
                                        filterValue,
                                        style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_14,
                                          // color: ColorsItem.greyB8BBBF
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimens.SPACE_5,
                                    ),
                                    Flexible(
                                      child: TextField(
                                        onTap: onTap,
                                        controller: controller,
                                        focusNode: focusNode,
                                        onChanged: onChanged,
                                        style: textStyle,
                                        textInputAction: TextInputAction.search,
                                        decoration: InputDecoration.collapsed(
                                          hintText: hintText,
                                          fillColor: Colors.grey,
                                          hintStyle: hintStyle,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : TextField(
                                onTap: onTap,
                                controller: controller,
                                focusNode: focusNode,
                                onChanged: onChanged,
                                style: textStyle,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration.collapsed(
                                  hintText: hintText,
                                  fillColor: Colors.grey,
                                  hintStyle: hintStyle,
                                ),
                              ),
                      ),
                    ),
                  ],
                )),
          ),
          (controller!.text.isNotEmpty || filterValue.isNotEmpty) ||
                  (controller!.text.isEmpty && buttonText == "Cancel")
              ? InkWell(
                  onTap: clearTap,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.only(left: Dimens.SPACE_10),
                    child: Text(
                      "$buttonText",
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                        // color: ColorsItem.whiteFEFEFE
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
