import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandscapeWidget extends StatelessWidget {
  final Widget child;

  LandscapeWidget({Key? key, required this.child}) : super(key: key);

  late final Future<void> _future = SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) => child,
    );
  }
}

class PotraitWidget extends StatelessWidget {
  final Widget child;

  PotraitWidget({Key? key, required this.child}) : super(key: key);

  late final Future<void> _future = SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) => child,
    );
  }
}
