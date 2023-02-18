import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/controller.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/sections/contribution.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/sections/head.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/sections/joined_project.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/sections/personal_data.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/sections/ticket_info.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/sections/ticket_summary.dart';

class ProfilePage extends View {
  ProfilePage({this.arguments});

  final Object? arguments;

  @override
  _ProfileState createState() => _ProfileState(
      AppComponent.getInjector().get<ProfileController>(), arguments);
}

class _ProfileState extends ViewState<ProfilePage, ProfileController>
    with SingleTickerProviderStateMixin {
  _ProfileState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  ProfileController _controller;
  DateTime currentBackPressTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller.thisTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ProfileController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
                key: globalKey,
                appBar: _controller.data?.user != null
                    ? AppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: MediaQuery.of(context).size.height / 10,
                        flexibleSpace: SimpleAppBar(
                          suffix: IconButton(
                            icon: FaIcon(
                              controller.isBlocked
                                  ? FontAwesomeIcons.solidFlag
                                  : FontAwesomeIcons.flag,
                              color: controller.isBlocked
                                  ? ColorsItem.orangeFB9600
                                  : ColorsItem.whiteFEFEFE,
                              size: Dimens.SPACE_20,
                            ),
                            onPressed: () {
                              if (controller.isBlocked) _undoReport();
                              if (!controller.isBlocked)
                                controller.reportUser();
                            },
                          ),
                          padding:
                              EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                          prefix: IconButton(
                            icon: FaIcon(FontAwesomeIcons.chevronLeft),
                            onPressed: () => Navigator.pop(context),
                          ),
                          titleMargin: 0,
                          toolbarHeight:
                              MediaQuery.of(context).size.height / 10,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).main_profile_tab_title,
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : AppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: MediaQuery.of(context).size.height / 10,
                        flexibleSpace: SimpleAppBar(
                          suffix: _popMenu(),
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_20,
                              vertical: Dimens.SPACE_10),
                          prefix: SizedBox(),
                          titleMargin: 0,
                          toolbarHeight:
                              MediaQuery.of(context).size.height / 10,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).main_profile_tab_title,
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_18,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: Dimens.SPACE_4),
                              Text(
                                S.of(context).profile_subtitle,
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )),
                body: Container(
                  child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return [ProfileHead(profileController: _controller)];
                      },
                      body: Container(
                        child: DefaultTabController(
                          length: 2,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorColor: ColorsItem.orangeFB9600,
                                unselectedLabelColor: ColorsItem.grey666B73,
                                labelColor: ColorsItem.orangeFB9600,
                                tabs: [
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.circleInfo,
                                          size: Dimens.SPACE_13,
                                        ),
                                        SizedBox(width: Dimens.SPACE_12),
                                        Flexible(
                                            child: Text(
                                                S.of(context).label_info,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: Dimens.SPACE_14),
                                                maxLines: 1))
                                      ],
                                    ),
                                  ),
                                  Tab(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.listCheck,
                                          size: Dimens.SPACE_13,
                                        ),
                                        SizedBox(width: Dimens.SPACE_12),
                                        Flexible(
                                            child: Text(
                                                S.of(context).label_ticket,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: Dimens.SPACE_14),
                                                maxLines: 1))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                  child: TabBarView(
                                children: [
                                  _infoTab(controller),
                                  ProfileTicketInfo(
                                      profileController: controller),
                                ],
                              ))
                            ],
                          ),
                        ),
                      )),
                )),
          );
        }),
      );

  _popMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0)
          _controller.goToEditProfile();
        else if (value == 1)
          _controller.goToSetting();
        else if (value == 2) {
          Navigator.pushNamed(context, Pages.roomFile,
              arguments: RoomFileArgs());
        } else if (value == 3) {
          Navigator.pushNamed(context, Pages.wikiList);
        } else
          showDialog<String>(
              context: context, builder: (BuildContext context) => exitAlert());
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
          child:
              FaIcon(FontAwesomeIcons.ellipsisVertical, size: Dimens.SPACE_18)),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.solidPenToSquare,
                    size: Dimens.SPACE_18),
                SizedBox(width: Dimens.SPACE_8),
                Expanded(
                    child: Text(S.of(context).profile_edit_label,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_14)))
              ],
            )),
        PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.gear, size: Dimens.SPACE_18),
                SizedBox(width: Dimens.SPACE_8),
                Expanded(
                    child: Text(S.of(context).profile_setting_label,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_14)))
              ],
            )),
        PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.paperclip, size: Dimens.SPACE_18),
                SizedBox(width: Dimens.SPACE_8),
                Expanded(
                    child: Text(S.of(context).room_detail_files_title,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_14)))
              ],
            )),
        PopupMenuItem(
            value: 3,
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.wikipediaW, size: Dimens.SPACE_18),
                SizedBox(width: Dimens.SPACE_8),
                Expanded(
                    child: Text("Wiki",
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_14)))
              ],
            )),
        PopupMenuItem(
            value: 4,
            child: Row(
              children: [
                FaIcon(FontAwesomeIcons.rightFromBracket,
                    size: Dimens.SPACE_18),
                SizedBox(width: Dimens.SPACE_8),
                Expanded(
                    child: Text(S.of(context).profile_logout_label,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_14)))
              ],
            )),
      ],
    );
  }

  _infoTab(ProfileController profileController) {
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.only(top: Dimens.SPACE_20),
          padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileSummary(profileController: profileController),
              SizedBox(
                height: Dimens.SPACE_20,
              ),
              ProfileContribution(profileController: profileController),
              SizedBox(
                height: Dimens.SPACE_15,
              ),
              ProfileProjectJoined(profileController: profileController),
              SizedBox(
                height: Dimens.SPACE_15,
              ),
              ProfilePersonalData(profileController: profileController),
              SizedBox(
                height: Dimens.SPACE_15,
              ),
            ],
          )),
    );
  }

  exitAlert() {
    return AlertDialog(
      elevation: 0.0,
      content: Container(
          height: MediaQuery.of(context).size.height / 4.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).profile_logout_dialog_title,
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Dimens.SPACE_10,
              ),
              Text(
                S.of(context).profile_logout_dialog_subtitle,
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14, color: ColorsItem.grey8D9299),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Dimens.SPACE_20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonDefault(
                      buttonText: S.of(context).label_cancel.toUpperCase(),
                      buttonTextColor: ColorsItem.orangeFB9600,
                      buttonColor: Colors.transparent,
                      buttonLineColor: ColorsItem.grey666B73,
                      radius: Dimens.SPACE_10,
                      width: MediaQuery.of(context).size.width / 3.2,
                      onTap: () => Navigator.pop(context)),
                  ButtonDefault(
                      buttonText:
                          S.of(context).profile_logout_label.toUpperCase(),
                      buttonColor: ColorsItem.redDA1414,
                      buttonTextColor: ColorsItem.whiteFEFEFE,
                      buttonLineColor: ColorsItem.redDA1414,
                      radius: Dimens.SPACE_10,
                      width: MediaQuery.of(context).size.width / 3.2,
                      onTap: () => _controller.logout())
                ],
              )
            ],
          )),
    );
  }

  void _undoReport() {
    showCustomAlertDialog(
        heightBoxDialog: MediaQuery.of(context).size.height / 4,
        context: context,
        title: S.of(context).label_unreport_title,
        subtitle: S.of(context).user_undo_report_terms,
        onConfirm: () {
          _controller.undoReportUser(_controller.userFlag);
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        },
        cancelButtonText: S.of(context).label_cancel,
        confirmButtonText: S.of(context).label_button_next.toUpperCase());
  }

  Future<bool> showConfirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap Again To Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
