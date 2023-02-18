import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';

class AdaptiveListview extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext context, int index) item;
  final ScrollController? scrollController;
  final int itemCount;

  const AdaptiveListview({
    Key? key,
    required this.onRefresh,
    required this.item,
    this.scrollController,
    required this.itemCount,
  }) : super(key: key);

  @override
  _AdaptiveListviewState createState() => _AdaptiveListviewState();
}

class _AdaptiveListviewState extends State<AdaptiveListview> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: widget.onRefresh,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return widget.item(context, index);
              },
              childCount: widget.itemCount,
            ),
          ),
        ],
        controller: widget.scrollController,
      );
    } else {
      return DefaultRefreshIndicator(
        onRefresh: widget.onRefresh,
        child: ListView.builder(
            controller: widget.scrollController,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              return widget.item(context, index);
            }),
      );
    }
  }
}
