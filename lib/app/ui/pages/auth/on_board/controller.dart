import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/pages/auth/on_board/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';

class OnBoardController extends BaseController {
  OnboardArgs? _data;

  // properties
  int _totalPages = 3;
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  int get totalPages => _totalPages;

  int get currentPage => _currentPage;

  PageController get pageController => _pageController;

  @override
  void load() {
    // load
  }

  @override
  void getArgs() {
    if (args != null) _data = args as OnboardArgs;
    print(_data?.toPrint());
  }

  void gotoWorkspace() {
    Navigator.pushReplacementNamed(context, Pages.workspace,
        arguments: WorkspaceLoginArgs());
  }

  void onPageChanged(int page) {
    _currentPage = page;
    refreshUI();
  }

  void onNextPage() {
    _pageController.animateToPage(_currentPage + 1,
        duration: Duration(milliseconds: 400), curve: Curves.linear);
  }

  @override
  void initListeners() {}

  @override
  void disposing() {
    //
  }
}
