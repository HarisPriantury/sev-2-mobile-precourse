import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/always_disable_focus_node.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/args.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class CreateProjectPage extends View {
  CreateProjectPage({this.arguments});

  final Object? arguments;

  @override
  _CreateState createState() => _CreateState(
      AppComponent.getInjector().get<CreateProjectController>(), arguments);
}

class _CreateState
    extends ViewState<CreateProjectPage, CreateProjectController> {
  _CreateState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  CreateProjectController _controller;

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<CreateProjectController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  _getTitle(),
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                suffix: GestureDetector(
                  onTap: () {
                    _controller.validateOnTap();
                    if (_controller.isValidated && !_controller.isProcessing) {
                      _controller.onCreateTransaction();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: Dimens.SPACE_24),
                    child: Text(
                      _getButtonSave(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: _controller.isValidated
                              ? ColorsItem.orangeFB9600
                              : ColorsItem.grey606060),
                      // color: ColorsItem.orangeFB9600),
                    ),
                  ),
                ),
              ),
            ),
            body: _getBodyContent(),
          );
        }),
      );

  Widget _getBodyContent() {
    return _projectContent();
  }

  Widget _projectContent() {
    return Padding(
        padding: const EdgeInsets.all(Dimens.SPACE_20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_controller.type == CreateProjectType.subProject ||
                  _controller.isMilestone()) ...[
                Text(
                  S.of(context).label_project,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.greyB8BBBF,
                    fontSize: Dimens.SPACE_12,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_15),
                Text(
                  _controller.projectObj!.name!,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.green00A1B0,
                    fontSize: Dimens.SPACE_14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_25),
              ],
              Text(
                _controller.isMilestone()
                    ? S.of(context).label_milestone_name
                    : S.of(context).label_project_name,
                style: GoogleFonts.montserrat(
                  color: ColorsItem.greyB8BBBF,
                  fontSize: Dimens.SPACE_12,
                ),
              ),
              SizedBox(height: Dimens.SPACE_12),
              Theme(
                data: new ThemeData(
                  primaryColor: ColorsItem.grey666B73,
                  primaryColorDark: ColorsItem.grey666B73,
                ),
                child: TextField(
                  onChanged: (val) => _controller.validate(),
                  controller: _controller.titleController,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                  ),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _controller.validateTitle &&
                                _controller.titleController.text.isEmpty
                            ? ColorsItem.redDA1414
                            : ColorsItem.grey666B73,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _controller.validateTitle &&
                                _controller.titleController.text.isEmpty
                            ? ColorsItem.redDA1414
                            : ColorsItem.grey666B73,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorsItem.grey666B73,
                      ),
                    ),
                    hintStyle:
                        GoogleFonts.montserrat(color: ColorsItem.grey666B73),
                    hintText: _controller.isMilestone()
                        ? S.of(context).label_milestone_name
                        : S.of(context).project_name_hint,
                  ),
                ),
              ),
              SizedBox(height: Dimens.SPACE_20),
              // project description
              Text(S.of(context).room_detail_description_label,
                  style: GoogleFonts.montserrat(
                      color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
              SizedBox(height: Dimens.SPACE_8),
              Theme(
                data: new ThemeData(
                  primaryColor: ColorsItem.grey666B73,
                  primaryColorDark: ColorsItem.grey666B73,
                ),
                child: TextField(
                  onChanged: (val) => _controller.validate(),
                  controller: _controller.descriptionController,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: _controller.validateDesc &&
                                    _controller
                                        .descriptionController.text.isEmpty
                                ? ColorsItem.redDA1414
                                : ColorsItem.grey666B73)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: _controller.validateDesc &&
                                    _controller
                                        .descriptionController.text.isEmpty
                                ? ColorsItem.redDA1414
                                : ColorsItem.grey666B73)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorsItem.grey666B73)),
                    hintText: S.of(context).project_description_hint,
                    hintStyle:
                        GoogleFonts.montserrat(color: ColorsItem.grey666B73),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                ),
              ),
              _bottomContent(),
            ],
          ),
        ));
  }

  String _getTitle() {
    String? _type;
    String? _status;
    if (_controller.type == CreateProjectType.projectEdit) {
      _type = S.of(context).label_project;
      _status = S.of(context).label_edit;
    } else if (_controller.type == CreateProjectType.subProject) {
      _type = S.of(context).project_sub_project_label;
      _status = S.of(context).label_add;
    } else if (_controller.isMilestone()) {
      _type = S.of(context).project_milestone_label;
      if (_controller.type == CreateProjectType.milestoneCreate) {
        _status = S.of(context).label_add;
      } else {
        _status = S.of(context).label_edit;
      }
    } else {
      _type = S.of(context).label_project;
      _status = S.of(context).label_add;
    }

    return "$_status $_type";
  }

  String _getButtonSave() {
    String? _button;
    if (_controller.objectIdentifier != null &&
        _controller.type == CreateProjectType.projectEdit) {
      _button = S.of(context).label_submit;
    } else if (_controller.objectIdentifier != null &&
        _controller.type == CreateProjectType.subProject) {
      _button = S.of(context).label_create;
    } else if (_controller.type == CreateProjectType.milestoneEdit) {
      _button = S.of(context).label_edit;
    } else {
      _button = S.of(context).label_create;
    }
    return "$_button";
  }

  List<Widget> _buildSearchItems(List<PhObject> list) {
    List<Widget> chips = new List.empty(growable: true);
    chips.add(SizedBox(width: Dimens.SPACE_4));
    for (PhObject obj in list) {
      chips.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_4),
        child: Container(
          decoration: BoxDecoration(
              color: ColorsItem.grey666B73,
              borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_8, vertical: Dimens.SPACE_2),
          child: Text(obj.name!,
              style: GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE)),
        ),
      ));
    }
    chips.add(SizedBox(width: Dimens.SPACE_4));
    return chips;
  }

  Widget _bottomContent() {
    if (_controller.isMilestone()) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimens.SPACE_20),
          Text(
            S.of(context).room_calendar_startdate,
            style: GoogleFonts.montserrat(
              color: ColorsItem.greyB8BBBF,
              fontSize: Dimens.SPACE_12,
            ),
          ),
          SizedBox(height: Dimens.SPACE_8),
          Theme(
            data: new ThemeData(
              primaryColor: ColorsItem.grey666B73,
              primaryColorDark: ColorsItem.grey666B73,
            ),
            child: TextField(
              onChanged: (val) => _controller.validate(),
              cursorColor: ColorsItem.whiteFEFEFE,
              style: GoogleFonts.montserrat(
                color: ColorsItem.whiteFEFEFE,
                fontSize: Dimens.SPACE_14,
              ),
              focusNode: AlwaysDisabledFocusNode(),
              controller: _controller.startDateController,
              onTap: () {
                _selectStartDate();
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _controller.validateDate &&
                            _controller.startDateController.text.isEmpty
                        ? ColorsItem.redDA1414
                        : ColorsItem.grey666B73,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _controller.validateDate &&
                            _controller.startDateController.text.isEmpty
                        ? ColorsItem.redDA1414
                        : ColorsItem.grey666B73,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsItem.grey666B73),
                ),
                hintStyle: GoogleFonts.montserrat(
                    color: ColorsItem.grey666B73, fontSize: Dimens.SPACE_14),
                hintText: S.of(context).room_calendar_choose_date,
                prefixIcon: Icon(
                  FontAwesomeIcons.calendarDay,
                  color: ColorsItem.whiteFEFEFE,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimens.SPACE_20),
          Text(
            S.of(context).room_calendar_enddate,
            style: GoogleFonts.montserrat(
              color: ColorsItem.greyB8BBBF,
              fontSize: Dimens.SPACE_12,
            ),
          ),
          SizedBox(height: Dimens.SPACE_8),
          Theme(
            data: new ThemeData(
              primaryColor: ColorsItem.grey666B73,
              primaryColorDark: ColorsItem.grey666B73,
            ),
            child: TextField(
              onChanged: (val) => _controller.validate(),
              cursorColor: ColorsItem.whiteFEFEFE,
              style: GoogleFonts.montserrat(
                color: ColorsItem.whiteFEFEFE,
                fontSize: Dimens.SPACE_14,
              ),
              focusNode: AlwaysDisabledFocusNode(),
              controller: _controller.endDateController,
              onTap: () {
                _selectEndDate();
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _controller.validateDate &&
                            _controller.endDateController.text.isEmpty
                        ? ColorsItem.redDA1414
                        : ColorsItem.grey666B73,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _controller.validateDate &&
                            _controller.endDateController.text.isEmpty
                        ? ColorsItem.redDA1414
                        : ColorsItem.grey666B73,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsItem.grey666B73),
                ),
                hintStyle: GoogleFonts.montserrat(
                  color: ColorsItem.grey666B73,
                  fontSize: Dimens.SPACE_14,
                ),
                hintText: S.of(context).room_calendar_choose_date,
                prefixIcon: Icon(
                  FontAwesomeIcons.calendarDay,
                  color: ColorsItem.whiteFEFEFE,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Aksesibilitas
          SizedBox(height: Dimens.SPACE_20),
          Text(S.of(context).label_accessibility,
              style: GoogleFonts.montserrat(
                  color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: _controller.accessibility.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                          unselectedWidgetColor: ColorsItem.greyd8d8d8),
                      child: RadioListTile<String>(
                          contentPadding: EdgeInsets.only(
                            bottom: Dimens.SPACE_11,
                          ),
                          value: _controller.accessibility[index],
                          controlAffinity: ListTileControlAffinity.leading,
                          groupValue: _controller.selectedAccessibility,
                          title: Text(_controller.accessibility[index],
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14,
                              )),
                          activeColor: ColorsItem.orangeFB9600,
                          subtitle: Text(
                              _controller.accessibilityDescription[index],
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_10,
                                  color: ColorsItem.grey666B73)),
                          onChanged: (val) {
                            _controller.onSelectedPolicy(val!);
                            if (val == 'Private' &&
                                _controller.label.length == 0) {
                              _controller.showActionSnackbar(
                                context,
                                S.of(context).select_project_accessibility,
                              );
                            }
                          },
                          selected: false),
                    ),
                    if (index != _controller.accessibility.length - 1) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: Dimens.SPACE_10),
                        child: Divider(
                            color: ColorsItem.grey858A93,
                            height: Dimens.SPACE_2),
                      )
                    ]
                  ],
                );
              }),
          SizedBox(height: Dimens.SPACE_20),
          if (_controller.selectedAccessibility == "Private" &&
              _controller.label.length == 0)
            // if Aksesibility == private
            ...[
            Padding(
              padding: const EdgeInsets.only(left: Dimens.SPACE_55),
              child: GestureDetector(
                onTap: () {
                  _controller.onSearchProjects();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.circlePlus,
                      color: ColorsItem.orangeFB9600,
                      size: 18,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      S.of(context).label_accessibility,
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.orangeFB9600,
                          fontSize: Dimens.SPACE_14),
                    ),
                  ],
                ),
              ),
            )
          ] else if (_controller.selectedAccessibility == 'Private' &&
              _controller.label.length > 0) ...[
            Padding(
                padding: const EdgeInsets.only(left: Dimens.SPACE_55),
                child: GestureDetector(
                  onTap: () {
                    _controller.onSearchProjects();
                  },
                  child: FittedBox(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimens.SPACE_6,
                          horizontal: Dimens.SPACE_16),
                      decoration: BoxDecoration(
                        color: ColorsItem.blue38A1D3,
                        borderRadius: BorderRadius.circular(Dimens.SPACE_20),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _controller.label[0].name!,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12,
                              color: ColorsItem.black1F2329,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: 9),
                          GestureDetector(
                            onTap: () {
                              _controller.onDeleteProjects();
                              _controller.showActionSnackbar(
                                context,
                                S.of(context).select_project_accessibility,
                              );
                            },
                            child: Icon(Icons.close, size: Dimens.SPACE_14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
          ] else ...[
            SizedBox(),
          ]
        ],
      );
    }
  }

  _selectStartDate() async {
    DateTime selectedDate = _controller.dateUtil.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: _controller.dateUtil.from(_controller.dateUtil.now().year - 1),
      lastDate: _controller.dateUtil.from(_controller.dateUtil.now().year + 1),
    );
    if (picked != null) {
      _controller.setCalendarStartDate(picked);
      _controller.clearEndDate();
    }
  }

  _selectEndDate() async {
    if (_controller.startDate != null) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _controller.startDate!,
        firstDate: _controller.startDate!,
        lastDate:
            _controller.dateUtil.from(_controller.dateUtil.now().year + 1),
      );
      if (picked != null) _controller.setCalendarEndDate(picked);
    } else {
      _controller.showNotif(
          context, S.of(context).create_form_date_picker_alert);
    }
  }
}
