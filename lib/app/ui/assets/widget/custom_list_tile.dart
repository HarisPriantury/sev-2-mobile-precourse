import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final TextStyle style;
  final Widget icon;
  final EdgeInsetsGeometry padding;
  final double textMargin;
  final void Function()? onTap;

  const CustomListTile({
    required this.title,
    required this.style,
    required this.icon,
    this.padding = const EdgeInsets.symmetric(
        horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_8),
    this.textMargin = Dimens.SPACE_6,
    this.onTap,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: style,
              ),
            ),
            SizedBox(width: textMargin),
            icon
          ],
        ),
      ),
    );
  }
}
