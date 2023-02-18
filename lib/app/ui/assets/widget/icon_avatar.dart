import 'package:flutter/material.dart';

class IconAvatar extends StatelessWidget {
  final BoxBorder? border;
  final Widget avatar;
  final Widget icon;
  final EdgeInsetsGeometry? padding;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;

  const IconAvatar(
      {required this.avatar,
      required this.icon,
      this.border,
      this.padding,
      this.left,
      this.top,
      this.right,
      this.bottom})
      : super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: padding,
          decoration: BoxDecoration(shape: BoxShape.circle, border: border),
          child: avatar,
        ),
        Positioned.fill(
            bottom: bottom, left: left, right: right, top: top, child: Align(child: icon)),
      ],
    );
  }
}
