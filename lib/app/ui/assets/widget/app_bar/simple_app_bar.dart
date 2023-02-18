import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class SimpleAppBar extends StatelessWidget {
  final double toolbarHeight;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Widget? prefix;
  final Widget? suffix;
  final double? titleMargin;
  final Widget title;

  SimpleAppBar(
      {required this.toolbarHeight,
      this.padding,
      required this.title,
      this.color,
      this.prefix,
      this.suffix,
      this.titleMargin = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Platform.isIOS ? Dimens.SPACE_40 : Dimens.SPACE_20),
        Container(
          padding: padding,
          height: toolbarHeight,
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    prefix == null
                        ? IconButton(
                            icon: FaIcon(FontAwesomeIcons.chevronLeft),
                            onPressed: () => Navigator.pop(context),
                          )
                        : prefix!,
                    SizedBox(
                      width: titleMargin,
                    ),
                    Expanded(child: title),
                  ],
                ),
              ),
              SizedBox(width: titleMargin),
              suffix == null ? SizedBox() : suffix!
            ],
          ),
        ),
      ],
    );
  }
}
