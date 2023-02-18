import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/lazy_indexed_stack.dart';
import 'package:mobile_sev2/app/ui/pages/main/controller.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:showcaseview/showcaseview.dart';

class MainPage extends View {
  final Object? arguments;

  MainPage({this.arguments});

  @override
  _MainState createState() =>
      _MainState(AppComponent.getInjector().get<MainController>(), arguments);
}

class _MainState extends ViewState<MainPage, MainController> {
  MainController _controller;

  _MainState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        duration: Duration(milliseconds: 300),
        data: Theme.of(context),
        child: ControlledWidgetBuilder<MainController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            body: ShowCaseWidget(
              onComplete: (index, key) {
                if (key == _controller.four) {
                  _controller.userData.lobbyTooltipFinished = true;
                  _controller.userData.statusTooltipFinished = true;
                  _controller.userData.save();
                } else if (key == _controller.two) {
                  _controller.userData.lobbyTooltipFinished = true;
                  _controller.userData.save();
                } else if (key == _controller.seven) {
                  _controller.userData.workspaceTooltipFinished = true;
                  _controller.userData.save();
                }
              },
              autoPlay: false,
              autoPlayLockEnable: false,
              builder: Builder(
                builder: (context) => LazyIndexedStack(
                  children: _controller.pages,
                  index: _controller.currentTab,
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 0.1, color: ColorsItem.whiteFEFEFE),
                ),
              ),
              child: BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 10,
                child: Container(
                  height: MediaQuery.of(context).size.height / 10,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () =>
                              _controller.updateCurrentScreen(Pages.lobby),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.house,
                                color: _controller.currentTab == 0
                                    ? ColorsItem.orangeFB9600
                                    : ColorsItem.grey8D9299,
                              ),
                              _controller.currentTab == 0
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(top: Dimens.SPACE_5),
                                      child: Text(
                                        S.of(context).main_lobby_tab_title,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_12,
                                            color: ColorsItem.orangeFB9600),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () => _controller
                              .updateCurrentScreen(Pages.mainCalendar),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendar,
                                    color: _controller.currentTab == 1
                                        ? ColorsItem.orangeFB9600
                                        : ColorsItem.grey8D9299,
                                  ),
                                  _controller.setting?.hasUnopenedCalendar ==
                                          true
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: Dimens.SPACE_15),
                                          child: Container(
                                            width: Dimens.SPACE_12,
                                            height: Dimens.SPACE_12,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                              _controller.currentTab == 1
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(top: Dimens.SPACE_5),
                                      child: Text(
                                        S.of(context).label_calendar,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_12,
                                            color: ColorsItem.orangeFB9600),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () =>
                              _controller.updateCurrentScreen(Pages.project),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    SvgPicture.asset(
                                      ImageItem.IC_PROJECT,
                                      width: Dimens.SPACE_24,
                                      height: Dimens.SPACE_24,
                                      color: _controller.currentTab == 2
                                          ? ColorsItem.orangeFB9600
                                          : ColorsItem.grey8D9299,
                                    ),
                                    SizedBox()
                                  ],
                                ),
                                _controller.currentTab == 2
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            top: Dimens.SPACE_5),
                                        child: Text(
                                          S.of(context).label_ticket,
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_12,
                                              color: ColorsItem.orangeFB9600),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () =>
                              _controller.updateCurrentScreen(Pages.rooms),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.solidCommentDots,
                                      color: _controller.currentTab == 3
                                          ? ColorsItem.orangeFB9600
                                          : ColorsItem.grey8D9299,
                                    ),
                                    _controller.setting?.hasUnreadChats == true
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: Dimens.SPACE_15),
                                            child: Container(
                                              width: Dimens.SPACE_12,
                                              height: Dimens.SPACE_12,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : SizedBox()
                                  ],
                                ),
                                _controller.currentTab == 3
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            top: Dimens.SPACE_5),
                                        child: Text(
                                          S.of(context).main_chat_tab_title,
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_12,
                                              color: ColorsItem.orangeFB9600),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () =>
                              _controller.updateCurrentScreen(Pages.profile),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.userTie,
                                color: _controller.currentTab == 4
                                    ? ColorsItem.orangeFB9600
                                    : ColorsItem.grey8D9299,
                              ),
                              _controller.currentTab == 4
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(top: Dimens.SPACE_5),
                                      child: Text(
                                        S.of(context).main_profile_tab_title,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_12,
                                            color: ColorsItem.orangeFB9600),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      );
}
