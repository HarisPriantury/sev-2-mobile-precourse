import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/icon_status.dart';
import 'package:mobile_sev2/app/ui/assets/widget/member_item.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/pages/member/controller.dart';

class MemberPage extends View {
  final Object? arguments;

  MemberPage({this.arguments});

  @override
  _MemberState createState() => _MemberState(
      AppComponent.getInjector().get<MemberController>(), arguments);
}

class _MemberState extends ViewState<MemberPage, MemberController> {
  MemberController _controller;

  _MemberState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view =>
      ControlledWidgetBuilder<MemberController>(builder: (context, controller) {
        return Scaffold(
          key: globalKey,
          backgroundColor: ColorsItem.black191C21,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: MediaQuery.of(context).size.height / 10,
            flexibleSpace: SimpleAppBar(
              title: Text(
                _controller.data.workspace,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.SPACE_20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: ColorsItem.black191C21,
            ),
          ),
          body: controller.isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: ColorsItem.black191C21,
                    border: Border(
                      top: BorderSide(
                          width: 1.0, color: Colors.white.withOpacity(0.5)),
                    ),
                  ),
                  child: Platform.isIOS
                      ? CustomScrollView(
                          slivers: [
                            CupertinoSliverRefreshControl(
                              onRefresh: () => _controller.reload(),
                            ),
                            SliverToBoxAdapter(
                              child: memberList(),
                            ),
                          ],
                        )
                      : DefaultRefreshIndicator(
                          onRefresh: () => _controller.reload(),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: memberList(),
                          ),
                        ),
                ),
        );
      });

  Widget memberList() {
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: [
              SizedBox(
                height: Dimens.SPACE_10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorsItem.black020202,
                  border: Border(
                    bottom: BorderSide(
                        width: 1.0,
                        color: ColorsItem.grey606060.withOpacity(0.5)),
                  ),
                ),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    iconColor: Colors.white,
                    iconSize: 35.0,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                      child: Text(
                        "${S.of(context).member_in_lobby_subtitle} (${_controller.inLobbyUsers.length} member)",
                        style: GoogleFonts.montserrat(
                            fontSize: 16.0, color: Colors.white),
                      )),
                  collapsed: SizedBox(),
                  expanded: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _controller.inLobbyUsers.length,
                      itemBuilder: (context, idx) {
                        return Container(
                          color: ColorsItem.black191C21,
                          child: MemberItem(
                            avatar: _controller.inLobbyUsers[idx].avatar!,
                            name: _controller.inLobbyUsers[idx].name!,
                            fullName:
                                _controller.inLobbyUsers[idx].getFullName()!,
                            icon: IconStatus(
                              status: _controller.inLobbyUsers[idx].userStatus!,
                            ),
                            status: _controller.inLobbyUsers[idx].currentTask ??
                                _controller.inLobbyUsers[idx].userStatus!,
                            statusColor: ColorsItem.green219653,
                            onTap: () {
                              _controller
                                  .goToProfile(_controller.inLobbyUsers[idx]);
                            },
                          ),
                        );
                      }),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorsItem.black020202,
                  border: Border(
                    bottom: BorderSide(
                        width: 1.0,
                        color: ColorsItem.grey606060.withOpacity(0.5)),
                  ),
                ),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    iconColor: Colors.white,
                    iconSize: 35.0,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                      child: Text(
                        "${S.of(context).member_break_subtitle} (${_controller.breakUsers.length} member)",
                        style: GoogleFonts.montserrat(
                            fontSize: 16.0, color: Colors.white),
                      )),
                  collapsed: SizedBox(),
                  expanded: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _controller.breakUsers.length,
                      itemBuilder: (context, idx) {
                        return Container(
                          color: ColorsItem.black191C21,
                          child: MemberItem(
                            avatar: _controller.breakUsers[idx].avatar!,
                            name: _controller.breakUsers[idx].name!,
                            fullName:
                                _controller.breakUsers[idx].getFullName()!,
                            icon: IconStatus(
                              status: _controller.breakUsers[idx].userStatus!,
                            ),
                            status: _controller.breakUsers[idx].currentTask ??
                                _controller.breakUsers[idx].userStatus!,
                            statusColor: ColorsItem.orangeFB9600,
                            onTap: () {
                              _controller
                                  .goToProfile(_controller.breakUsers[idx]);
                            },
                          ),
                        );
                      }),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorsItem.black020202,
                  border: Border(
                    bottom: BorderSide(
                        width: 1.0,
                        color: ColorsItem.grey606060.withOpacity(0.5)),
                  ),
                ),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    iconColor: Colors.white,
                    iconSize: 35.0,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                      child: Text(
                        "${S.of(context).member_in_channel_subtitle} (${_controller.inChannelUsers.length} member)",
                        style: GoogleFonts.montserrat(
                            fontSize: 16.0, color: Colors.white),
                      )),
                  collapsed: SizedBox(),
                  expanded: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _controller.inChannelUsers.length,
                      itemBuilder: (context, idx) {
                        return Container(
                          color: ColorsItem.black191C21,
                          child: MemberItem(
                            avatar: _controller.inChannelUsers[idx].avatar!,
                            name: _controller.inChannelUsers[idx].name!,
                            fullName:
                                _controller.inChannelUsers[idx].getFullName()!,
                            icon: IconStatus(
                              status:
                                  _controller.inChannelUsers[idx].userStatus!,
                            ),
                            status: _controller
                                    .inChannelUsers[idx].currentTask ??
                                _controller.inChannelUsers[idx].currentChannel!,
                            statusColor: ColorsItem.green219653,
                            onTap: () {
                              _controller
                                  .goToProfile(_controller.inChannelUsers[idx]);
                            },
                          ),
                        );
                      }),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorsItem.black020202,
                  border: Border(
                    bottom: BorderSide(
                        width: 1.0,
                        color: ColorsItem.grey606060.withOpacity(0.5)),
                  ),
                ),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    iconColor: Colors.white,
                    iconSize: 35.0,
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                      child: Text(
                        "${S.of(context).member_unavailable_subtitle} (${_controller.unavailableUsers.length} member)",
                        style: GoogleFonts.montserrat(
                            fontSize: 16.0, color: Colors.white),
                      )),
                  collapsed: SizedBox(),
                  expanded: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: _controller.unavailableUsers.length,
                      itemBuilder: (context, idx) {
                        return Container(
                          color: ColorsItem.black191C21,
                          child: MemberItem(
                            avatar: _controller.unavailableUsers[idx].avatar!,
                            name: _controller.unavailableUsers[idx].name!,
                            fullName: _controller.unavailableUsers[idx]
                                .getFullName()!,
                            icon: IconStatus(
                              status:
                                  _controller.unavailableUsers[idx].userStatus!,
                            ),
                            status: _controller
                                    .unavailableUsers[idx].currentTask ??
                                _controller.unavailableUsers[idx].userStatus!,
                            statusColor: ColorsItem.grey606060,
                            onTap: () {
                              _controller.goToProfile(
                                  _controller.unavailableUsers[idx]);
                            },
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
