import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/events/connection.dart';
import 'package:mobile_sev2/app/infrastructures/misc/common.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class BaseController extends Controller with CommonUtil {
  BaseController() : super();

  final ScrollController _listScrollController = ScrollController();
  final ScrollController _secondScrollController = ScrollController();
  final ScrollController _thirdScrollController = ScrollController();

  static GlobalKey _one = GlobalKey();
  static GlobalKey _two = GlobalKey();
  static GlobalKey _three = GlobalKey();
  static GlobalKey _four = GlobalKey();
  static GlobalKey _five = GlobalKey();
  static GlobalKey _six = GlobalKey();
  static GlobalKey _seven = GlobalKey();
  static GlobalKey _eight = GlobalKey();
  final GlobalKey flushBarUnAvailableKey = GlobalKey();
  final GlobalKey flushBarAvailableKey = GlobalKey();

  Object? args;
  bool isLoading = true;
  bool isConnected = true;
  bool isReloading = false;
  bool isShowUnAvailableFlushbar = true;

  BuildContext get context => getContext();

  ScrollController get listScrollController => _listScrollController;
  ScrollController get secondListScrollController => _secondScrollController;
  ScrollController get thirdListScrollController => _thirdScrollController;

  GlobalKey get one => _one;
  GlobalKey get two => _two;
  GlobalKey get three => _three;
  GlobalKey get four => _four;
  GlobalKey get five => _five;
  GlobalKey get six => _six;
  GlobalKey get seven => _seven;
  GlobalKey get eight => _eight;

  @override
  void onInitState() {
    super.onInitState();
    getArgs();
    load();

    AppComponent.getInjector().get<EventBus>().on<ConnectionEvent>().listen((event) async {
      isConnected = event.isOnline;
      if (!isConnected) showUnAvailableConnectionFlushbar();
      if (!isShowUnAvailableFlushbar) {
        if (isConnected) {
          (flushBarUnAvailableKey.currentWidget as Flushbar).dismiss();
          showAvailableConnectionFlushbar();
          (flushBarAvailableKey.currentWidget as Flushbar).dismiss();
        }
      }

      refreshUI();
    });
  }

  void setScrollListener(
    Function func, {
    Function? secondFunc,
    Function? thirdFunc,
  }) {
    _listScrollController.addListener(() => scrollListener(func));

    if (secondFunc != null) {
      _secondScrollController
          .addListener(() => secondScrollListener(secondFunc));
    }

    if (thirdFunc != null) {
      _thirdScrollController.addListener(() => thirdScrollListener(thirdFunc));
    }
  }

  scrollListener(Function func) {
    if (_listScrollController.offset >=
            _listScrollController.position.maxScrollExtent &&
        !_listScrollController.position.outOfRange) {
      func();
    }
  }

  secondScrollListener(Function func) {
    if (_secondScrollController.offset >=
            _secondScrollController.position.maxScrollExtent &&
        !_secondScrollController.position.outOfRange) {
      func();
    }
  }

  thirdScrollListener(Function func) {
    if (_thirdScrollController.offset >=
            _thirdScrollController.position.maxScrollExtent &&
        !_thirdScrollController.position.outOfRange) {
      func();
    }
  }

  void delay(Function func, {int period: 2}) {
    Future.delayed(
      Duration(seconds: period),
      () async {
        func();
      },
    );
  }

  void delayMillis(Function func, {int milliseconds: 2}) {
    Future.delayed(
      Duration(milliseconds: milliseconds),
      () async {
        func();
      },
    );
  }

  Future<bool> checkConnection() async {
    bool isOnline = true;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    return isOnline;
  }

  void loading(bool isLoad) {
    isLoading = isLoad;
    refreshUI();
  }

  void reloading(bool isReload) {
    isReloading = isReload;
    refreshUI();
  }

  void launchURL(String uriString) async {
    Uri url = Uri.parse(uriString);
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Can not launch $url';
  }

  void onError() {}

  @protected
  void getArgs();

  @protected
  void load();

  @protected
  void disposing();

  @override
  void initListeners();

  @override
  void onDisposed() {
    super.onDisposed();
    this.disposing();
  }

  Future<void> reload({String? type}) async {
    await Future.delayed(Duration(seconds: 1));
  }

  showUnAvailableConnectionFlushbar() {
    isShowUnAvailableFlushbar = false;
    return Flushbar(
      key: flushBarUnAvailableKey,
      message: "Tidak dapat terhubung kejaringan",
      backgroundColor: ColorsItem.redA70000,
      flushbarPosition: FlushbarPosition.BOTTOM,
    )..show(getContext());
  }

  Widget showAvailableConnectionFlushbar() {
    return Flushbar(
      key: flushBarAvailableKey,
      message: "Kembali terhubung kejaringan",
      backgroundColor: ColorsItem.green477908,
      duration: Duration(seconds: 5),
      flushbarPosition: FlushbarPosition.BOTTOM,
    )..show(getContext());
  }
}
