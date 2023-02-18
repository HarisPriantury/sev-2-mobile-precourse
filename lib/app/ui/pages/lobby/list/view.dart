import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/device_checker.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/sections/lobby_content.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/sections/head.dart';

class LobbyPage extends View {
  final Object? arguments;

  LobbyPage({this.arguments});

  @override
  _MainState createState() =>
      _MainState(AppComponent.getInjector().get<LobbyController>(), arguments);
}

class _MainState extends ViewState<LobbyPage, LobbyController> {
  LobbyController _controller;

  DateTime currentBackPressTime = DateTime.now();

  _MainState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  Widget get mobileView => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<LobbyController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
              child: PageView(
                  key: globalKey,
                  scrollDirection: Axis.horizontal,
                  controller: _controller.pageController,
                  children: [
                    Scaffold(
                        appBar: AppBar(
                          toolbarHeight: Dimens.SPACE_80,
                          elevation: 0,
                          flexibleSpace: SimpleAppBar(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_20.w,
                                vertical: Dimens.SPACE_10.w),
                            prefix: SizedBox(),
                            titleMargin: 0,
                            title: LobbyHead(controller: _controller),
                            toolbarHeight: Dimens.SPACE_80,
                          ),
                        ),
                        body: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_20.w),
                          child: Platform.isIOS
                              ? CustomScrollView(
                                  slivers: [
                                    CupertinoSliverRefreshControl(
                                      onRefresh: () => _controller.reload(),
                                    ),
                                    SliverToBoxAdapter(
                                      child: LobbyContent(
                                          lobbyController: controller),
                                    ),
                                  ],
                                )
                              : DefaultRefreshIndicator(
                                  onRefresh: () => _controller.reload(),
                                  child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    child: LobbyContent(
                                        lobbyController: controller),
                                  ),
                                ),
                        )),
                    WillPopScope(
                        onWillPop: () => Future.sync(() {
                              _controller.pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.linear);
                              return false;
                            }),
                        child: _controller.statusPage)
                  ]),
            ),
          );
        }),
      );

  Widget get tabletView =>
      ControlledWidgetBuilder<LobbyController>(builder: (context, controller) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Container(
            // color: ColorsItem.black1F2329,
            child: PageView(
                key: globalKey,
                scrollDirection: Axis.horizontal,
                controller: _controller.pageController,
                children: [
                  Container(
                    // color: ColorsItem.black191C21,
                    child: Scaffold(
                        backgroundColor: ColorsItem.black1F2329,
                        appBar: AppBar(
                          toolbarHeight:
                              MediaQuery.of(context).size.height / 10,
                          elevation: 0,
                          flexibleSpace: SimpleAppBar(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_20.h,
                                vertical: Dimens.SPACE_10.h),
                            // color: ColorsItem.black191C21,
                            prefix: SizedBox(),
                            titleMargin: 0,
                            title: LobbyHead(controller: _controller),
                            toolbarHeight:
                                MediaQuery.of(context).size.height / 10,
                          ),
                        ),
                        body: Container(
                          child: Container(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20.h),
                              child: Platform.isIOS
                                  ? CustomScrollView(
                                      slivers: [
                                        CupertinoSliverRefreshControl(
                                          onRefresh: () => _controller.reload(),
                                        ),
                                        SliverToBoxAdapter(
                                          child: LobbyContent(
                                              lobbyController: controller),
                                        ),
                                      ],
                                    )
                                  : DefaultRefreshIndicator(
                                      onRefresh: () => _controller.reload(),
                                      child: SingleChildScrollView(
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        child: LobbyContent(
                                            lobbyController: controller),
                                      ),
                                    ),
                            ),
                          ),
                        )),
                  ),
                  WillPopScope(
                      onWillPop: () => Future.sync(() {
                            _controller.pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear);
                            return false;
                          }),
                      child: _controller.statusPage)
                ]),
          ),
        );
      });
  Future<bool> showConfirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap Again To Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget get view => ResponsiveView(mobile: mobileView, tablet: tabletView);
}
