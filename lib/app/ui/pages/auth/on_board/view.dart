import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/pages/auth/on_board/controller.dart';

class OnBoardPage extends View {
  final Object? arguments;

  OnBoardPage({this.arguments});

  @override
  _OnBoardPageState createState() => _OnBoardPageState(
      AppComponent.getInjector().get<OnBoardController>(), arguments);
}

class _OnBoardPageState extends ViewState<OnBoardPage, OnBoardController> {
  OnBoardController _controller;

  _OnBoardPageState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<OnBoardController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 7,
                      child: Container(
                        child: PageView(
                          controller: _controller.pageController,
                          onPageChanged: (int page) =>
                              _controller.onPageChanged(page),
                          children: <Widget>[
                            _buildPageContent(
                              image: ImageItem.ON_BOARD1,
                              title: S.of(context).on_board_first_title,
                              body: S.of(context).on_board_first_description,
                            ),
                            _buildPageContent(
                              image: ImageItem.ON_BOARD2,
                              title: S.of(context).on_board_second_title,
                              body: S.of(context).on_board_second_description,
                            ),
                            _buildPageContent(
                              image: ImageItem.ON_BOARD3,
                              title: S.of(context).on_board_third_title,
                              body: S.of(context).on_board_third_description,
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: ControlledWidgetBuilder<OnBoardController>(
                        builder: (context, controller) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Row(children: [
                                for (int i = 0; i < _controller.totalPages; i++)
                                  i == _controller.currentPage
                                      ? _buildPageIndicator(i, true)
                                      : _buildPageIndicator(i, false)
                              ]),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
                      child: Center(
                          child: _controller.currentPage == 2
                              ? ButtonDefault(
                                  buttonText: S
                                      .of(context)
                                      .on_board_login_btn_label
                                      .toUpperCase(),
                                  buttonTextColor: ColorsItem.black32373D,
                                  buttonColor: ColorsItem.orangeFB9600,
                                  buttonLineColor: ColorsItem.orangeFB9600,
                                  letterSpacing: 1.5,
                                  paddingHorizontal: Dimens.SPACE_80,
                                  paddingVertical: Dimens.SPACE_14,
                                  radius: 10.0,
                                  onTap: () => _controller.gotoWorkspace(),
                                )
                              : ButtonDefault(
                                  buttonText:
                                      S.of(context).label_next.toUpperCase(),
                                  buttonTextColor: ColorsItem.orangeFB9600,
                                  buttonColor: Colors.transparent,
                                  buttonLineColor: ColorsItem.orangeFB9600,
                                  letterSpacing: 1.5,
                                  paddingHorizontal: Dimens.SPACE_80,
                                  paddingVertical: Dimens.SPACE_14,
                                  radius: 10.0,
                                  onTap: () => _controller.onNextPage(),
                                )),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      );

  _buildPageIndicator(int page, bool isCurrentPage) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 375),
      margin: EdgeInsets.symmetric(horizontal: Dimens.SPACE_6),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  _buildPageContent({
    required String image,
    required String title,
    required String body,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            image,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SizedBox(height: Dimens.SPACE_40),
          Text(
            title,
            style: GoogleFonts.raleway(
                fontSize: Dimens.SPACE_20,
                height: 1.5,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: Dimens.SPACE_16),
          Container(
            child: Text(
              body,
              style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
