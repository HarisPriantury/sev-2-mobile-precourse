import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';

class DefaultRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? backgroundColor;
  final Future<void> Function() onRefresh;

  const DefaultRefreshIndicator(
      {Key? key, this.color, this.backgroundColor, required this.onRefresh, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: child,
      onRefresh: onRefresh,
      backgroundColor: color == null ? ColorsItem.black1F2329 : backgroundColor,
      color: color == null ? ColorsItem.whiteFEFEFE : color,
    );
  }
}
