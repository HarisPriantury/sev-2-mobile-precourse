import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/no_connection.dart';
import 'package:mobile_sev2/app/ui/assets/widget/project_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/assets/widget/shimmer_project.dart';
import 'package:mobile_sev2/app/ui/assets/widget/ticket_list.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/project/list/controller.dart';
import 'dart:math' as math;

class ProjectPage extends View {
  ProjectPage({this.arguments});

  final Object? arguments;

  @override
  _ProjectState createState() => _ProjectState(
      AppComponent.getInjector().get<ProjectController>(), arguments);
}

class _ProjectState extends ViewState<ProjectPage, ProjectController> {
  _ProjectState(this._controller, Object? args) : super(_controller);

  ProjectController _controller;
  DateTime currentBackPressTime = DateTime.now();

  @override
  Widget get view => ControlledWidgetBuilder<ProjectController>(
        builder: (context, controller) {
          return !_controller.isConnected
              ? NoConnection(globalKey)
              : WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: Scaffold(
                    key: globalKey,
                    body: Container(
                      margin: EdgeInsets.only(top: Dimens.SPACE_40),
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
                                  child: Center(
                                    child: Text(
                                      S.of(context).label_ticket,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Center(
                                    child: Text(
                                      S.of(context).main_project_tab_title,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  tabTicket(),
                                  tabProject(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      );

  Widget tabTicket() {
    return DefaultRefreshIndicator(
      onRefresh: () => _controller.reload(),
      child: SingleChildScrollView(
        controller: _controller.secondListScrollController,
        child: Column(
          children: [
            SizedBox(height: Dimens.SPACE_15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).label_ticket,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: Dimens.SPACE_4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(S.of(context).ticket_subtitle,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w500)),
                      ),
                      PopupMenuButton(
                        onSelected: (value) {
                          if (value == 0)
                            _controller.goToCreateTicket(TaskType.task);
                          else if (value == 1)
                            _controller.goToCreateTicket(TaskType.bug);
                          else
                            _controller.goToCreateTicket(TaskType.spike);
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 0,
                              child: Text(S.of(context).label_add_new_task,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14))),
                          PopupMenuItem(
                              value: 1,
                              child: Text(S.of(context).label_add_new_bug,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14))),
                          PopupMenuItem(
                              value: 2,
                              child: Text(S.of(context).label_add_new_spike,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14))),
                        ],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: Dimens.SPACE_16,
                              color: ColorsItem.orangeFB9600,
                            ),
                            SizedBox(width: Dimens.SPACE_4),
                            Text(
                              S.of(context).label_ticket,
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w700,
                                color: ColorsItem.orangeFB9600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
              child: tabSearchTicket(),
            ),
            _controller.isLoading
                ? ShimmerProject()
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: ticketContent(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget tabSearchTicket() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_15),
      child: SearchBar(
        hintText: "${S.of(context).label_search} ${S.of(context).label_ticket}",
        border: Border.all(color: ColorsItem.grey979797.withOpacity(0.5)),
        borderRadius: BorderRadius.all(const Radius.circular(Dimens.SPACE_40)),
        innerPadding: EdgeInsets.all(Dimens.SPACE_10),
        outerPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
        controller: _controller.searchTicketController,
        focusNode: _controller.focusNodeSearchTicket,
        onChanged: (txt) {
          _controller.streamTicketController.add(txt);
        },
        clearTap: () => _controller.clearSearch(),
        onTap: () => _controller.onSearchTicket(true),
        endIcon: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          color: ColorsItem.greyB8BBBF,
          size: Dimens.SPACE_18,
        ),
        textStyle: TextStyle(fontSize: 15.0),
        hintStyle: TextStyle(color: ColorsItem.grey8D9299),
        buttonText: 'Clear',
      ),
    );
  }

  Widget ticketContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _controller.searchTicketController.text.isNotEmpty
              ? RichText(
                  text: TextSpan(
                    text: S.of(context).search_found_placeholder,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                        color: ColorsItem.grey8D9299),
                    children: <TextSpan>[
                      TextSpan(
                        text: "${_controller.searchTicketController.text}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : SizedBox(),
          _controller.isLoading
              ? ShimmerProject()
              : _controller.ticket.isNotEmpty
                  ? _listTicket()
                  : Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              S.of(context).search_data_not_found_title,
                              style: GoogleFonts.montserrat(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              S.of(context).search_data_not_found_description,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14.0, color: ColorsItem.grey8D9299),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    )
        ],
      ),
    );
  }

  _listTicket() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: _controller.ticket.length,
            itemBuilder: (context, index) {
              return TicketList(
                onTap: () {
                  _controller.goToTicketDetail(_controller.ticket[index]);
                },
                onLongPress: () {
                  _controller.getUser(
                    _controller.ticket[index].author?.id ?? "",
                    _controller.ticket[index],
                  );
                },
                ticketName:
                    "T${_controller.ticket[index].intId} : ${_controller.ticket[index].name}",
                status: _controller.ticket[index].rawStatus ?? "-",
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget tabProject() {
    return DefaultRefreshIndicator(
      onRefresh: () => _controller.reload(),
      child: SingleChildScrollView(
        controller: _controller.listScrollController,
        child: Column(
          children: [
            SizedBox(height: Dimens.SPACE_15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).main_project_tab_title,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: Dimens.SPACE_4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(S.of(context).project_subtitle,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w500)),
                      ),
                      InkWell(
                        onTap: () => {_controller.moveToNewProject()},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: Dimens.SPACE_16,
                              color: ColorsItem.orangeFB9600,
                            ),
                            SizedBox(width: Dimens.SPACE_4),
                            Text(
                              S.of(context).main_project_tab_title,
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w700,
                                color: ColorsItem.orangeFB9600,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
              child: tabSearchProject(),
            ),
            _controller.isLoading
                ? ShimmerProject()
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: projectContent(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget tabSearchProject() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_15),
      child: SearchBar(
        hintText:
            "${S.of(context).label_search} ${S.of(context).label_project}",
        border: Border.all(color: ColorsItem.grey979797.withOpacity(0.5)),
        borderRadius: BorderRadius.all(const Radius.circular(Dimens.SPACE_40)),
        innerPadding: EdgeInsets.all(Dimens.SPACE_10),
        outerPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
        controller: _controller.searchProjectController,
        focusNode: _controller.focusNodeSearchProject,
        onChanged: (txt) {
          _controller.streamController.add(txt);
        },
        clearTap: () => _controller.clearSearch(),
        onTap: () => _controller.onSearchProject(true),
        endIcon: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          color: ColorsItem.greyB8BBBF,
          size: Dimens.SPACE_18,
        ),
        textStyle: TextStyle(fontSize: 15.0),
        hintStyle: TextStyle(color: ColorsItem.grey8D9299),
        buttonText: 'Clear',
      ),
    );
  }

  Widget projectContent() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _controller.searchProjectController.text.isNotEmpty
              ? RichText(
                  text: TextSpan(
                    text: S.of(context).search_found_placeholder,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                        color: ColorsItem.grey8D9299),
                    children: <TextSpan>[
                      TextSpan(
                          text: "${_controller.searchProjectController.text}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            ImageItem.IC_PROJECT,
                            width: Dimens.SPACE_16,
                          ),
                          SizedBox(
                            width: Dimens.SPACE_10,
                          ),
                          Text(
                            "${_controller.getFilterProject().toUpperCase()}",
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.bold,
                                color: ColorsItem.grey858A93),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: customPopupMenuButton(),
                    )
                  ],
                ),
          SizedBox(
            height: Dimens.SPACE_10,
          ),
          _controller.project.isNotEmpty
              ? _listProject()
              : Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          S.of(context).search_data_not_found_title,
                          style: GoogleFonts.montserrat(
                              fontSize: 18.0,
                              color: ColorsItem.whiteFEFEFE,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          S.of(context).search_data_not_found_description,
                          style: GoogleFonts.montserrat(
                              fontSize: 14.0, color: ColorsItem.grey8D9299),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  PopupMenuButton<ProjectFilterType> customPopupMenuButton() {
    return PopupMenuButton<ProjectFilterType>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.SPACE_8),
        ),
      ),
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${_controller.getFilterProject()}',
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_12,
                    fontWeight: FontWeight.w700,
                    color: ColorsItem.blue38A1D3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(math.pi),
                child: SvgPicture.asset(
                  ImageItem.IC_DROPDOWN,
                  width: Dimens.SPACE_8,
                  color: ColorsItem.blue38A1D3,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2.0,
            color: ColorsItem.blue38A1D3,
          )
        ],
      ),
      itemBuilder: (BuildContext context) => <ProjectFilterType>[
        ProjectFilterType.Filter,
        ProjectFilterType.All,
        ProjectFilterType.Joined,
        ProjectFilterType.Active,
      ].map((ProjectFilterType value) {
        return customPopupMenuItem(value, context);
      }).toList(),
      onSelected: (type) {
        if (type != ProjectFilterType.Filter) _controller.filter(type);
      },
    );
  }

  PopupMenuItem<ProjectFilterType> customPopupMenuItem(
    ProjectFilterType value,
    BuildContext context,
  ) {
    return PopupMenuItem<ProjectFilterType>(
      value: value,
      height: Dimens.SPACE_35,
      child: value == ProjectFilterType.Filter
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: ColorsItem.blue38A1D3,
                      ),
                    ),
                    SvgPicture.asset(
                      ImageItem.IC_DROPDOWN,
                      width: Dimens.SPACE_8,
                    ),
                  ],
                ),
                SizedBox(height: Dimens.SPACE_3),
                Divider(
                  thickness: 1.0,
                  color: ColorsItem.black32373D,
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getLabelFilterProject(context, value),
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_12,
                    fontWeight: FontWeight.w700,
                    color: ColorsItem.blue38A1D3,
                  ),
                ),
                if (_controller.projectFilterType == value) ...[
                  Icon(
                    Icons.check,
                    color: ColorsItem.blue38A1D3,
                    size: Dimens.SPACE_12,
                  )
                ]
              ],
            ),
    );
  }

  _listProject() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _controller.project.length,
        itemBuilder: (context, index) {
          return ProjectList(
            onTap: () {
              _controller.goToProjectDetail(_controller.project[index]);
            },
            projectName:
                "#${_controller.project[index].intId} : ${_controller.project[index].name}",
            joinDate: "",
            status: _controller.project[index].isArchived
                ? S.of(context).label_archive
                : S.of(context).status_task_open,
            index: index,
          );
        },
      ),
    );
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
