import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/appbar/controller.dart';

class AppbarPage extends View {
  final Object? arguments;

  AppbarPage({this.arguments});

  @override
  _MainState createState() =>
      _MainState(AppComponent.getInjector().get<AppbarController>(), arguments);
}

class _MainState extends ViewState<AppbarPage, AppbarController> {
  AppbarController _controller;

  _MainState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => Container(
        color: ColorsItem.black191C21,
        child: SafeArea(
            key: globalKey,
            child: Scaffold(
              backgroundColor: ColorsItem.black191C21,
              appBar: AppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_10),
                  color: ColorsItem.black191C21,
                  prefix: SizedBox(),
                  titleMargin: 0,
                  title: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  _controller.goToWorkspaceList();
                                },
                                child: Text(
                                  _controller.userData.workspace,
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_20,
                                    color: ColorsItem.orangeFB9600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: _controller
                                                .availableUsers.length
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                color: ColorsItem.greyB8BBBF,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                " ${S.of(context).lobby_active_label}",
                                            style: TextStyle(
                                                fontSize: Dimens.SPACE_14,
                                                color: ColorsItem.greyB8BBBF))
                                      ])),
                                      SizedBox(
                                        width: Dimens.SPACE_5,
                                      ),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: _controller
                                                .unavailableUsers.length
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                color: ColorsItem.greyB8BBBF,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                " ${S.of(context).lobby_inactive_label}",
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                color: ColorsItem.greyB8BBBF))
                                      ]))
                                    ],
                                  ),
                                  InkWell(
                                      onTap: () => _controller.goToMember(),
                                      child: Container(
                                        height: Dimens.SPACE_25,
                                        child: Text(
                                            S.of(context).appbar_see_all_label,
                                            style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14,
                                              color: ColorsItem.green00A1B0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ))
                                ],
                              ),
                              SizedBox(height: Dimens.SPACE_2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                ),
              ),
            )),
      );
}
