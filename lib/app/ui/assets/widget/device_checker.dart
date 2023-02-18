import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/utils.dart';

class ResponsiveView extends StatelessWidget {
  final Widget mobile, tablet;

  const ResponsiveView({
    Key? key,
    required this.mobile,
    required this.tablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget generateWidget() {
      var isTablet = Utils.isTablet();
      if (isTablet) return tablet;
      return mobile;
    }

    return generateWidget();
  }
}
