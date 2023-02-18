import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/assets/widget/stickit_item.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/stickit/controller.dart';

class RoomStickitPage extends View {
  final Object? arguments;

  RoomStickitPage({this.arguments});

  @override
  _RoomStickitState createState() => _RoomStickitState(
      AppComponent.getInjector().get<RoomStickitController>(), arguments);
}

class _RoomStickitState
    extends ViewState<RoomStickitPage, RoomStickitController> {
  RoomStickitController _controller;

  _RoomStickitState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<RoomStickitController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).label_stickit,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimens.SPACE_20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: Dimens.SPACE_4,
                    ),
                    Text(
                      _controller.room.name!,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12,
                      ),
                    ),
                  ],
                ),
                suffix: Container(
                  width: Dimens.SPACE_50,
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                controller.isLoading
                    ? Expanded(
                        child: Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Expanded(
                        child: DefaultRefreshIndicator(
                          onRefresh: () => _controller.reload(),
                          child: (_controller.memo.isEmpty &&
                                  _controller.pitch.isEmpty &&
                                  _controller.mom.isEmpty &&
                                  _controller.praise.isEmpty)
                              ? EmptyList(
                                  title: S.of(context).room_empty_stickit_title,
                                  descripton: S
                                      .of(context)
                                      .room_empty_stickit_description)
                              : SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      _controller.memo.isEmpty
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  top: Dimens.SPACE_12),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Dimens.SPACE_10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.SPACE_10),
                                                    border: Border.all(
                                                        color: ColorsItem
                                                            .grey979797
                                                            .withOpacity(0.5))),
                                                child: ExpandablePanel(
                                                  theme: ExpandableThemeData(
                                                    iconColor:
                                                        ColorsItem.grey606060,
                                                    iconSize: Dimens.SPACE_35,
                                                    headerAlignment:
                                                        ExpandablePanelHeaderAlignment
                                                            .center,
                                                    tapBodyToCollapse: true,
                                                  ),
                                                  header: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: Dimens
                                                                  .SPACE_20),
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .stickit_type_announcement,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize:
                                                              Dimens.SPACE_16,
                                                        ),
                                                      )),
                                                  collapsed: SizedBox(),
                                                  expanded: ListView.builder(
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      itemCount: _controller
                                                          .memo.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return StickitItem(
                                                            isRead: _controller
                                                                .checkIsRead(
                                                                    _controller
                                                                            .memo[
                                                                        index]),
                                                            onTap: () {
                                                              _controller.onItemClicked(
                                                                  _controller
                                                                          .memo[
                                                                      index]);
                                                            },
                                                            stickit: _controller
                                                                .memo[index]);
                                                      }),
                                                ),
                                              ),
                                            ),
                                      _controller.pitch.isEmpty
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  top: Dimens.SPACE_2),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.SPACE_10,
                                                    Dimens.SPACE_10,
                                                    Dimens.SPACE_10,
                                                    0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.SPACE_10),
                                                    border: Border.all(
                                                        color: ColorsItem
                                                            .grey979797
                                                            .withOpacity(0.5))),
                                                child: ExpandablePanel(
                                                  theme: ExpandableThemeData(
                                                    iconColor:
                                                        ColorsItem.grey606060,
                                                    iconSize: Dimens.SPACE_35,
                                                    headerAlignment:
                                                        ExpandablePanelHeaderAlignment
                                                            .center,
                                                    tapBodyToCollapse: true,
                                                  ),
                                                  header: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: Dimens
                                                                  .SPACE_20),
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .stickit_type_pitch_idea,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: Dimens
                                                                    .SPACE_16),
                                                      )),
                                                  collapsed: SizedBox(),
                                                  expanded: ListView.builder(
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      itemCount: _controller
                                                          .pitch.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return StickitItem(
                                                            isRead: _controller
                                                                .checkIsRead(
                                                                    _controller
                                                                            .pitch[
                                                                        index]),
                                                            onTap: () {
                                                              _controller.onItemClicked(
                                                                  _controller
                                                                          .pitch[
                                                                      index]);
                                                            },
                                                            stickit: _controller
                                                                .pitch[index]);
                                                      }),
                                                ),
                                              ),
                                            ),
                                      _controller.praise.isEmpty
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  top: Dimens.SPACE_2),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.SPACE_10,
                                                    Dimens.SPACE_10,
                                                    Dimens.SPACE_10,
                                                    0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.SPACE_10),
                                                    border: Border.all(
                                                        color: ColorsItem
                                                            .grey979797
                                                            .withOpacity(0.5))),
                                                child: ExpandablePanel(
                                                  theme: ExpandableThemeData(
                                                    iconColor:
                                                        ColorsItem.grey606060,
                                                    iconSize: Dimens.SPACE_35,
                                                    headerAlignment:
                                                        ExpandablePanelHeaderAlignment
                                                            .center,
                                                    tapBodyToCollapse: true,
                                                  ),
                                                  header: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: Dimens
                                                                  .SPACE_20),
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .stickit_type_praise,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: Dimens
                                                                    .SPACE_16),
                                                      )),
                                                  collapsed: SizedBox(),
                                                  expanded: ListView.builder(
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      itemCount: _controller
                                                          .praise.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return StickitItem(
                                                            isRead: _controller
                                                                .checkIsRead(
                                                                    _controller
                                                                            .praise[
                                                                        index]),
                                                            onTap: () {
                                                              _controller.onItemClicked(
                                                                  _controller
                                                                          .praise[
                                                                      index]);
                                                            },
                                                            stickit: _controller
                                                                .praise[index]);
                                                      }),
                                                ),
                                              ),
                                            ),
                                      _controller.mom.isEmpty
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  top: Dimens.SPACE_2),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    Dimens.SPACE_10,
                                                    Dimens.SPACE_10,
                                                    Dimens.SPACE_10,
                                                    0),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.SPACE_10),
                                                    border: Border.all(
                                                        color: ColorsItem
                                                            .grey979797
                                                            .withOpacity(0.5))),
                                                child: ExpandablePanel(
                                                  theme: ExpandableThemeData(
                                                    iconColor:
                                                        ColorsItem.grey606060,
                                                    iconSize: Dimens.SPACE_35,
                                                    headerAlignment:
                                                        ExpandablePanelHeaderAlignment
                                                            .center,
                                                    tapBodyToCollapse: true,
                                                  ),
                                                  header: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: Dimens
                                                                  .SPACE_20),
                                                      child: Text(
                                                        S
                                                            .of(context)
                                                            .stickit_type_mom,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: Dimens
                                                                    .SPACE_16),
                                                      )),
                                                  collapsed: SizedBox(),
                                                  expanded: ListView.builder(
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      itemCount: _controller
                                                          .mom.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return StickitItem(
                                                            isRead: _controller
                                                                .checkIsRead(
                                                                    _controller
                                                                            .mom[
                                                                        index]),
                                                            onTap: () {
                                                              _controller
                                                                  .onItemClicked(
                                                                      _controller
                                                                              .mom[
                                                                          index]);
                                                            },
                                                            stickit: _controller
                                                                .mom[index]);
                                                      }),
                                                ),
                                              ),
                                            ),
                                      SizedBox(height: Dimens.SPACE_12),
                                    ],
                                  ),
                                ),
                        ),
                      ),
              ],
            ),
          );
        }),
      );
}
