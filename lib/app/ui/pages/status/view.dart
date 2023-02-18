import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/pages/status/controller.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

class StatusPage extends View {
  final Object? arguments;

  StatusPage({this.arguments});

  @override
  _StatusState createState() => _StatusState(
      AppComponent.getInjector().get<StatusController>(), arguments);
}

class _StatusState extends ViewState<StatusPage, StatusController> {
  StatusController _controller;

  _StatusState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<StatusController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              automaticallyImplyLeading: false,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                titleMargin: 0,
                prefix: _controller.isNewPage ? null : SizedBox(),
                title: Text(
                  S.of(context).profile_set_status_label,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: _controller.isNewPage ? Dimens.SPACE_10 : 24.0,
                  vertical: Dimens.SPACE_10,
                ),
              ),
            ),
            body: _controller.isLoading
                ? Container(
                    child: SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.all(Dimens.SPACE_20),
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_12)),
                              ),
                              width: Dimens.SPACE_100,
                              height: Dimens.SPACE_16,
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              width: double.infinity,
                              height: Dimens.SPACE_30,
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_40)),
                              ),
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          SizedBox(height: Dimens.SPACE_35),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_12)),
                              ),
                              width: Dimens.SPACE_80,
                              height: Dimens.SPACE_20,
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          SizedBox(
                            height: Dimens.SPACE_15,
                          ),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              width: double.infinity,
                              height: Dimens.SPACE_30,
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_40)),
                              ),
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          SizedBox(
                            height: Dimens.SPACE_15,
                          ),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              width: double.infinity,
                              height: Dimens.SPACE_30,
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_40)),
                              ),
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          SizedBox(
                            height: Dimens.SPACE_15,
                          ),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              width: double.infinity,
                              height: Dimens.SPACE_30,
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_40)),
                              ),
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          SizedBox(
                            height: Dimens.SPACE_15,
                          ),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              width: double.infinity,
                              height: Dimens.SPACE_30,
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_40)),
                              ),
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          SizedBox(
                            height: Dimens.SPACE_15,
                          ),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              width: double.infinity,
                              height: Dimens.SPACE_30,
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_40)),
                              ),
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          SizedBox(
                            height: Dimens.SPACE_15,
                          ),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              width: double.infinity,
                              height: Dimens.SPACE_30,
                              decoration: BoxDecoration(
                                color: ColorsItem.white9E9E9E,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_40)),
                              ),
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                          SizedBox(
                            height: Dimens.SPACE_15,
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(Dimens.SPACE_20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(S.of(context).profile_your_status_label,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12)),
                              SizedBox(height: Dimens.SPACE_20),
                              InkWell(
                                onTap: () {
                                  _statusModalBottomSheet();
                                },
                                child: _controller.isNewPage
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimens.SPACE_16,
                                            vertical: Dimens.SPACE_8),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: ColorsItem.white9E9E9E),
                                          borderRadius: BorderRadius.circular(
                                              Dimens.SPACE_20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Row(
                                              children: [
                                                FaIcon(
                                                  _controller.statusIcon,
                                                  size: Dimens.SPACE_18,
                                                ),
                                                SizedBox(
                                                    width: Dimens.SPACE_12),
                                                Expanded(
                                                  child: Text(
                                                    _controller.getUserStatus(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts
                                                        .montserrat(),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            CircleAvatar(
                                                backgroundColor: _controller
                                                        .isInactive
                                                    ? ColorsItem.redB43600
                                                    : _controller.isIdle ||
                                                            _controller
                                                                .getUserStatus()
                                                                .isEmpty
                                                        ? ColorsItem
                                                            .orangeFB9600
                                                        : ColorsItem
                                                            .green219653,
                                                radius: Dimens.SPACE_5)
                                          ],
                                        ),
                                      )
                                    : Showcase(
                                        key: _controller.three,
                                        contentPadding:
                                            EdgeInsets.all(Dimens.SPACE_12),
                                        disableAnimation: true,
                                        animationDuration: Duration(seconds: 0),
                                        titleTextStyle: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14,
                                            fontWeight: FontWeight.bold),
                                        descTextStyle: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_12,
                                            color: ColorsItem.greyB8BBBF),
                                        title: S
                                            .of(context)
                                            .tooltip_status_title_1,
                                        description: S
                                            .of(context)
                                            .tooltip_status_description_1,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimens.SPACE_16,
                                              vertical: Dimens.SPACE_8),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorsItem.white9E9E9E),
                                            borderRadius: BorderRadius.circular(
                                                Dimens.SPACE_20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Row(
                                                children: [
                                                  FaIcon(
                                                    _controller.statusIcon,
                                                    size: Dimens.SPACE_18,
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_12),
                                                  Expanded(
                                                    child: Text(
                                                      _controller
                                                          .getUserStatus(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .montserrat(),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundColor: _controller
                                                          .isInactive
                                                      ? ColorsItem.redB43600
                                                      : _controller.isIdle ||
                                                              _controller
                                                                  .getUserStatus()
                                                                  .isEmpty
                                                          ? ColorsItem
                                                              .orangeFB9600
                                                          : ColorsItem
                                                              .green219653,
                                                  radius: Dimens.SPACE_5)
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Divider(color: ColorsItem.white9E9E9E, thickness: 2),
                        SizedBox(height: Dimens.SPACE_10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_20),
                          child: Text(
                            S.of(context).status_for_refactory_label,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _controller.isNewPage
                            ? Container(
                                padding: EdgeInsets.all(Dimens.SPACE_20),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _controller.setStatus(
                                          "1",
                                          isIdle: true,
                                          statusIcon:
                                              FontAwesomeIcons.arrowsRotate,
                                        );
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.arrowsRotate,
                                                  size: Dimens.SPACE_14,
                                                ),
                                                SizedBox(
                                                    width: Dimens.SPACE_12),
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .status_back_to_lobby,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: Dimens
                                                                .SPACE_14),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            CircleAvatar(
                                                backgroundColor:
                                                    ColorsItem.green219653,
                                                radius: Dimens.SPACE_5)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_20),
                                    InkWell(
                                      onTap: () {
                                        _controller.setStatus("3",
                                            isIdle: true,
                                            statusIcon: FontAwesomeIcons.bath);
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.bath,
                                                  size: Dimens.SPACE_14,
                                                ),
                                                SizedBox(
                                                    width: Dimens.SPACE_12),
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .profile_status_bathroom_label,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: Dimens
                                                                .SPACE_14),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            CircleAvatar(
                                                backgroundColor:
                                                    ColorsItem.orangeFA8C16,
                                                radius: Dimens.SPACE_5)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_20),
                                    InkWell(
                                      onTap: () {
                                        _controller.setStatus("4",
                                            isIdle: true,
                                            statusIcon:
                                                FontAwesomeIcons.utensils);
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.utensils,
                                                  color: ColorsItem.whiteE0E0E0,
                                                  size: Dimens.SPACE_14,
                                                ),
                                                SizedBox(
                                                    width: Dimens.SPACE_12),
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .profile_status_lunch_label,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .whiteE0E0E0),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            CircleAvatar(
                                                backgroundColor:
                                                    ColorsItem.orangeFA8C16,
                                                radius: Dimens.SPACE_5)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_20),
                                    InkWell(
                                      onTap: () {
                                        _controller.setStatus("5",
                                            isIdle: true,
                                            statusIcon:
                                                FontAwesomeIcons.gamepad);
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.gamepad,
                                                  color: ColorsItem.whiteE0E0E0,
                                                  size: Dimens.SPACE_14,
                                                ),
                                                SizedBox(
                                                    width: Dimens.SPACE_12),
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .profile_status_me_time_label,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .whiteE0E0E0),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            CircleAvatar(
                                                backgroundColor:
                                                    ColorsItem.orangeFA8C16,
                                                radius: Dimens.SPACE_5)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_20),
                                    InkWell(
                                      onTap: () {
                                        _controller.setStatus("7",
                                            isIdle: true,
                                            statusIcon:
                                                FontAwesomeIcons.bellSlash);
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.bellSlash,
                                                  color: ColorsItem.whiteE0E0E0,
                                                  size: Dimens.SPACE_14,
                                                ),
                                                SizedBox(
                                                    width: Dimens.SPACE_12),
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .profile_status_praying_label,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .whiteE0E0E0),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            CircleAvatar(
                                                backgroundColor:
                                                    ColorsItem.orangeFA8C16,
                                                radius: Dimens.SPACE_5)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_20),
                                    InkWell(
                                      onTap: () {
                                        _controller.setStatus("6",
                                            isInactive: true,
                                            statusIcon:
                                                FontAwesomeIcons.lifeRing);
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.lifeRing,
                                                  color: ColorsItem.whiteE0E0E0,
                                                  size: Dimens.SPACE_14,
                                                ),
                                                SizedBox(
                                                    width: Dimens.SPACE_12),
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .profile_status_family_label,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .whiteE0E0E0),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            CircleAvatar(
                                                backgroundColor:
                                                    ColorsItem.redB43600,
                                                radius: Dimens.SPACE_5)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_20),
                                    InkWell(
                                      onTap: () {
                                        _controller.setStatus(
                                          "8",
                                          isInactive: true,
                                          statusIcon:
                                              FontAwesomeIcons.userSecret,
                                        );
                                      },
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Row(
                                              children: [
                                                FaIcon(
                                                  FontAwesomeIcons.userSecret,
                                                  color: ColorsItem.whiteE0E0E0,
                                                  size: Dimens.SPACE_14,
                                                ),
                                                SizedBox(
                                                    width: Dimens.SPACE_12),
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .profile_status_other_label,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .whiteE0E0E0),
                                                  ),
                                                ),
                                              ],
                                            )),
                                            CircleAvatar(
                                                backgroundColor:
                                                    ColorsItem.redB43600,
                                                radius: Dimens.SPACE_5)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Showcase(
                                key: _controller.four,
                                contentPadding: EdgeInsets.all(Dimens.SPACE_12),
                                disableAnimation: true,
                                animationDuration: Duration(seconds: 0),
                                titleTextStyle: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    fontWeight: FontWeight.bold),
                                descTextStyle: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_12,
                                    color: ColorsItem.greyB8BBBF),
                                title: S.of(context).tooltip_status_title_2,
                                description:
                                    S.of(context).tooltip_status_description_2,
                                child: Container(
                                  padding: EdgeInsets.all(Dimens.SPACE_20),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _controller.setStatus(
                                            "1",
                                            isIdle: false,
                                            statusIcon:
                                                FontAwesomeIcons.arrowsRotate,
                                          );
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons
                                                        .arrowsRotate,
                                                    size: Dimens.SPACE_14,
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_12),
                                                  Expanded(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .status_back_to_lobby,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: Dimens
                                                                  .SPACE_14),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundColor:
                                                      ColorsItem.green219653,
                                                  radius: Dimens.SPACE_5)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimens.SPACE_20),
                                      InkWell(
                                        onTap: () {
                                          _controller.setStatus("3",
                                              isIdle: true,
                                              statusIcon:
                                                  FontAwesomeIcons.bath);
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.bath,
                                                    size: Dimens.SPACE_14,
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_12),
                                                  Expanded(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .profile_status_bathroom_label,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: Dimens
                                                                  .SPACE_14),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundColor:
                                                      ColorsItem.orangeFA8C16,
                                                  radius: Dimens.SPACE_5)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimens.SPACE_20),
                                      InkWell(
                                        onTap: () {
                                          _controller.setStatus("4",
                                              isIdle: true,
                                              statusIcon:
                                                  FontAwesomeIcons.utensils);
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.utensils,
                                                    size: Dimens.SPACE_14,
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_12),
                                                  Expanded(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .profile_status_lunch_label,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundColor:
                                                      ColorsItem.orangeFA8C16,
                                                  radius: Dimens.SPACE_5)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimens.SPACE_20),
                                      InkWell(
                                        onTap: () {
                                          _controller.setStatus("5",
                                              isIdle: true,
                                              statusIcon:
                                                  FontAwesomeIcons.gamepad);
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.gamepad,
                                                    size: Dimens.SPACE_14,
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_12),
                                                  Expanded(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .profile_status_me_time_label,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundColor:
                                                      ColorsItem.orangeFA8C16,
                                                  radius: Dimens.SPACE_5)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimens.SPACE_20),
                                      InkWell(
                                        onTap: () {
                                          _controller.setStatus("7",
                                              isIdle: true,
                                              statusIcon:
                                                  FontAwesomeIcons.bellSlash);
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.bellSlash,
                                                    size: Dimens.SPACE_14,
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_12),
                                                  Expanded(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .profile_status_praying_label,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundColor:
                                                      ColorsItem.orangeFA8C16,
                                                  radius: Dimens.SPACE_5)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimens.SPACE_20),
                                      InkWell(
                                        onTap: () {
                                          _controller.setStatus("6",
                                              isInactive: true,
                                              statusIcon:
                                                  FontAwesomeIcons.lifeRing);
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.lifeRing,
                                                    size: Dimens.SPACE_14,
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_12),
                                                  Expanded(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .profile_status_family_label,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundColor:
                                                      ColorsItem.redB43600,
                                                  radius: Dimens.SPACE_5)
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: Dimens.SPACE_20),
                                      InkWell(
                                        onTap: () {
                                          _controller.setStatus("8",
                                              isInactive: true,
                                              statusIcon:
                                                  FontAwesomeIcons.userSecret);
                                        },
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                  child: Row(
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.userSecret,
                                                    size: Dimens.SPACE_14,
                                                  ),
                                                  SizedBox(
                                                      width: Dimens.SPACE_12),
                                                  Expanded(
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .profile_status_other_label,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              CircleAvatar(
                                                  backgroundColor:
                                                      ColorsItem.redB43600,
                                                  radius: Dimens.SPACE_5)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        Divider(
                          color: ColorsItem.white9E9E9E,
                          thickness: 2,
                        ),
                        // TEMPORARY DISABLE
                        // SizedBox(height: Dimens.SPACE_10),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                        //   child: Text(S.of(context).status_recent_label,
                        //       style: GoogleFonts.montserrat(
                        //           color: ColorsItem.grey858A93,
                        //           fontSize: Dimens.SPACE_12,
                        //           fontWeight: FontWeight.bold)),
                        // ),
                        // SizedBox(height: Dimens.SPACE_20),
                        // ListView.builder(
                        //     itemCount: _controller.recentStatuses.length,
                        //     shrinkWrap: true,
                        //     primary: false,
                        //     itemBuilder: (context, index) {
                        //       return TransactionItem(
                        //         avatar: _controller.userData.avatar,
                        //         transactionAuthor: _controller.userData.name,
                        //         dateTime: _controller.formatStatusDate(_controller.recentStatuses[index].createdAt),
                        //         transactionContent:
                        //             "${_controller.recentStatuses[index].action}: <highlight>${_controller.recentStatuses[index].target}</highlight>",
                        //       );
                        //     })
                      ],
                    ),
                  ),
          );
        }),
      );

  _statusModalBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.SPACE_35),
                      topRight: Radius.circular(Dimens.SPACE_35))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimens.SPACE_20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              S.of(context).status_activity_title,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                _controller.setAdhocTask();
                              },
                              child: Text(
                                S.of(context).profile_set_status_label,
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsItem.orangeFB9600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: ColorsItem.white9E9E9E),
                  Padding(
                    padding: const EdgeInsets.all(Dimens.SPACE_20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).status_adhoc_sentence,
                          style:
                              GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                        ),
                        SizedBox(height: Dimens.SPACE_25),
                        Text(S.of(context).status_adhoc_set_label,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.grey858A93,
                                fontSize: Dimens.SPACE_12)),
                        SizedBox(height: Dimens.SPACE_20),
                        Container(
                          padding: EdgeInsets.all(Dimens.SPACE_16),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimens.SPACE_10),
                              border: Border.all(
                                color: ColorsItem.orangeFB9600,
                                width: 1.0,
                              )),
                          child: TextField(
                            controller: _controller.adhocTaskController,
                            style: TextStyle(fontSize: 15.0),
                            decoration: InputDecoration.collapsed(
                              hintText: S.of(context).status_adhoc_write_label,
                              fillColor: Colors.grey,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.SPACE_30),
                        Text(S.of(context).status_task_choose_label,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.grey858A93,
                                fontSize: Dimens.SPACE_12)),
                        SizedBox(height: Dimens.SPACE_25),
                        ButtonDefault(
                          width: double.infinity,
                          buttonText: S.of(context).status_task_choose_label,
                          buttonTextColor: ColorsItem.orangeFB9600,
                          buttonColor: Colors.transparent,
                          buttonLineColor: ColorsItem.orangeFB9600,
                          onTap: () {
                            _taskModalBottomSheet(context);
                          },
                          paddingVertical: Dimens.SPACE_14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  _taskModalBottomSheet(BuildContext _ctx) {
    showModalBottomSheet(
        context: _ctx,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.95,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.SPACE_35),
                      topRight: Radius.circular(Dimens.SPACE_35))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimens.SPACE_20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios),
                        ),
                        Text(
                          S.of(context).status_task_choose_label.ucwords(),
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_16,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            _controller.setWorkOnTask();
                            _controller.removeStateSetter('statusbs');
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            S.of(context).label_update.ucwords(),
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14,
                              color: _controller.selectedTask.isNotEmpty
                                  ? ColorsItem.orangeFB9600
                                  : ColorsItem.grey8D9299,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: ColorsItem.grey666B73),
                  SizedBox(height: Dimens.SPACE_6),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: SearchBar(
                      hintText: S.of(context).status_task_find_label,
                      textStyle: TextStyle(fontSize: 15.0),
                      hintStyle: TextStyle(color: Colors.grey),
                      outerPadding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
                      innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                      onChanged: (txt) {
                        _controller.streamController.add(txt);
                      },
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(40.0)),
                      border: Border.all(color: ColorsItem.grey666B73),
                      endIcon: Icon(Icons.search),
                      clearTap: () => _controller.clearSearch(),
                      onTap: () => _controller.onSearch(true),
                      buttonText: 'Clear',
                      controller: _controller.searchController,
                      focusNode: _controller.focusNodeSearch,
                    ),
                  ),
                  SizedBox(height: Dimens.SPACE_12),
                  _buildChips(state),
                  SizedBox(height: Dimens.SPACE_25),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: Text(S.of(context).status_task_available_label,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
                  ),
                  SizedBox(height: Dimens.SPACE_6),
                  Expanded(
                    child: _controller.isLoading
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _controller.tickets.length,
                            controller: _controller.listScrollController,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    child: RadioListTile<String>(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: Dimens.SPACE_4,
                                          horizontal: Dimens.SPACE_20),
                                      value:
                                          "${_controller.tickets[index].code}: ${_controller.tickets[index].name}",
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      groupValue: _controller.selectedTask,
                                      title: Text(
                                          "${_controller.tickets[index].code}: ${_controller.tickets[index].name}",
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14)),
                                      activeColor: ColorsItem.orangeFB9600,
                                      onChanged: (String? val) {
                                        _controller.setSelectedTask(val!);
                                      },
                                      selected: false,
                                    ),
                                  ),
                                  Divider(
                                    color: ColorsItem.black292D33,
                                    height: Dimens.SPACE_2,
                                  ),
                                ],
                              );
                            },
                          ),
                  )
                ],
              ),
            );
          });
        });
  }

  Widget _buildChips(StateSetter setter) {
    List<Widget> chips = new List.empty(growable: true);
    _controller.addStateSetter('statusbs', setter);

    for (int i = 0; i < _controller.chipOptions.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _controller.selectedChip == i,
        label: Text(_controller.chipOptions[i],
            style: GoogleFonts.montserrat(
                color: _controller.selectedChip == i
                    ? ColorsItem.whiteColor
                    : null)),
        selectedColor: ColorsItem.blue3FB5ED,
        onSelected: (bool selected) {
          _controller.selectChip(selected, i);
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips,
      ),
    );
  }
}
