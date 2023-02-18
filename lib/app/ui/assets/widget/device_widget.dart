import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_sev2/app/ui/assets/widget/orientation_widget.dart';

class MobileView extends StatelessWidget {
  final Widget child;
  final bool isLandscape;

  const MobileView({
    Key? key,
    required this.child,
    this.isLandscape = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (BuildContext context, Widget? child) => isLandscape
          ? LandscapeWidget(child: child!)
          : PotraitWidget(child: child!),
    );
  }
}

class TabletView extends StatelessWidget {
  final Widget child;

  const TabletView({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1194, 834),
      builder: (BuildContext context, Widget? child) =>
          LandscapeWidget(child: child!),
    );
  }
}
