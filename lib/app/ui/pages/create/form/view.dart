import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_form_field.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/controller.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class CreatePage extends View {
  final Object? arguments;

  CreatePage({this.arguments});

  @override
  _CreateState createState() => _CreateState(
      AppComponent.getInjector().get<CreateController>(), arguments);
}

class _CreateState extends ViewState<CreatePage, CreateController> {
  CreateController _controller;

  _CreateState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<CreateController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(FontAwesomeIcons.chevronLeft),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  _getTitle(),
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                suffix: GestureDetector(
                  onTap: () {
                    if (_controller.isValidated && !_controller.isProcessing) {
                      _controller.onCreateTransaction();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Text(
                      _controller.objectIdentifier.isEmpty
                          ? S.of(context).label_add
                          : S.of(context).label_update,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: _controller.isValidated
                              ? ColorsItem.orangeFB9600
                              : ColorsItem.grey606060),
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
    if (_controller.argsType == Stickit)
      return _stickitContent();
    else if (_controller.argsType == Ticket || _controller.argsType == Project)
      return _ticketContent();
    else if (_controller.argsType == Calendar) return _calendarContent();
    return SizedBox();
  }

  Widget _stickitContent() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.SPACE_20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).label_type,
              style: GoogleFonts.montserrat(
                  color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
          SizedBox(height: Dimens.SPACE_8),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                    // labelStyle:
                    //     GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: _controller.validateDropDown &&
                                    _controller.stickitType == null
                                ? ColorsItem.redDA1414
                                : ColorsItem.grey666B73))),
                isEmpty: _controller.stickitType == '',
                child: DropdownButtonHideUnderline(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: ColorsItem.black020202,
                    ),
                    child: DropdownButton<String>(
                      value: _controller.stickitType,
                      isDense: true,
                      style:
                          GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE),
                      onChanged: (String? newValue) {
                        _controller.onStickitTypeChanged(newValue);
                        _controller.validate();
                      },
                      items: _controller.stickitTypeList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: Dimens.SPACE_8),
          _controller.validateDropDown && _controller.stickitType == null
              ? Text(
                  S.of(context).error_stickit_type_selected,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.redDA1414,
                    fontSize: Dimens.SPACE_12,
                  ),
                )
              : SizedBox(),
          SizedBox(height: Dimens.SPACE_20),
          DefaultFormField(
            label: S.of(context).label_title,
            textEditingController: _controller.titleController,
            onChanged: (val) => _controller.validate(),
            hintText: S.of(context).profile_profile_name_label,
          ),
          SizedBox(height: Dimens.SPACE_8),
          _controller.validateTitle && _controller.titleController.text.isEmpty
              ? Text(
                  S.of(context).error_title_empty,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.redDA1414,
                    fontSize: Dimens.SPACE_12,
                  ),
                )
              : SizedBox(),
          SizedBox(height: Dimens.SPACE_20),
          DefaultFormFieldWithLongText(
            enabledBorderColor: _controller.validateDesc &&
                    _controller.descriptionController.text.isEmpty
                ? ColorsItem.redDA1414
                : ColorsItem.grey666B73,
            focusedBorderColor: _controller.validateDesc &&
                    _controller.descriptionController.text.isEmpty
                ? ColorsItem.redDA1414
                : ColorsItem.grey666B73,
            hintText: S.of(context).room_detail_comment_hint,
            label: S.of(context).room_detail_description_label,
            maxLines: 5,
            onChanged: (val) => _controller.validate(),
            textEditingController: _controller.descriptionController,
          ),
          SizedBox(height: Dimens.SPACE_8),
          _controller.validateDesc &&
                  _controller.descriptionController.text.isEmpty
              ? Text(
                  S.of(context).error_description_stickit_empty,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.redDA1414,
                    fontSize: Dimens.SPACE_12,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _ticketContent() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.SPACE_20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _controller.isSubTask
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(S.of(context).create_form_parent_task,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.greyB8BBBF,
                                fontSize: Dimens.SPACE_12)),
                        SizedBox(height: Dimens.SPACE_16),
                        Text(_controller.ticketObj!.name!,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.green00A1B0,
                                fontSize: Dimens.SPACE_14)),
                        SizedBox(height: Dimens.SPACE_20),
                      ])
                : SizedBox(),
            DefaultFormField(
              label: S.of(context).label_title,
              textEditingController: _controller.titleController,
              onChanged: (val) => _controller.validate(),
              hintText: S.of(context).profile_profile_name_label,
              enabledBorderColor: _controller.validateTitle &&
                      _controller.titleController.text.isEmpty
                  ? ColorsItem.redDA1414
                  : ColorsItem.grey666B73,
              focusedBorderColor: _controller.validateTitle &&
                      _controller.titleController.text.isEmpty
                  ? ColorsItem.redDA1414
                  : ColorsItem.grey666B73,
            ),
            SizedBox(height: Dimens.SPACE_8),
            _controller.validateTitle &&
                    _controller.titleController.text.isEmpty
                ? Text(
                    S.of(context).error_title_empty,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.redDA1414,
                      fontSize: Dimens.SPACE_12,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: Dimens.SPACE_20),
            DefaultFormFieldWithAction(
              children: _controller.assignee != null
                  ? _buildSearchItems([_controller.assignee!])
                  : _buildSearchItems(List.empty()),
              label: S.of(context).room_detail_assigned_label,
              onTap: _controller.onSearchTicketAssignee,
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                  color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_16),
            ),
            SizedBox(height: Dimens.SPACE_20),
            DefaultFormFieldWithAction(
              children: _buildSearchItems(_controller.subscribers),
              label: S.of(context).label_subscriber,
              onTap: _controller.onSearchSubscribers,
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                  color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_16),
            ),
            SizedBox(height: Dimens.SPACE_20),
            if (_controller.data?.taskType == TaskType.bug) ...[
              _bugReportedBy(),
            ],
            Text(S.of(context).label_status,
                style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
            SizedBox(height: Dimens.SPACE_8),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                      labelStyle: GoogleFonts.montserrat(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorsItem.grey666B73))),
                  isEmpty: _controller.ticketStatus == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _controller.ticketStatus,
                      isDense: true,
                      onChanged: (String? newValue) {
                        _controller.onTicketStatusChanged(newValue);
                      },
                      items: _controller.ticketStatuses
                          .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_14),
                                  ),
                                ));
                          })
                          .values
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: Dimens.SPACE_20),
            Text(S.of(context).label_priority,
                style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
            SizedBox(height: Dimens.SPACE_8),
            FormField<String>(
              builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                      labelStyle: GoogleFonts.montserrat(),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorsItem.grey666B73))),
                  isEmpty: _controller.ticketPriority == '',
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _controller.ticketPriority,
                      isDense: true,
                      onChanged: (String? newValue) {
                        _controller.onTicketPriorityChanged(newValue);
                      },
                      items: _controller.ticketPriorities
                          .map((key, value) {
                            return MapEntry(
                                key,
                                DropdownMenuItem<String>(
                                  value: key,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_14),
                                  ),
                                ));
                          })
                          .values
                          .toList(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: Dimens.SPACE_8),
            _controller.validateDropDown && _controller.ticketPriority == null
                ? Text(
                    S.of(context).error_priority_selected,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.redDA1414,
                      fontSize: Dimens.SPACE_12,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: Dimens.SPACE_20),
            DefaultFormField(
              label: S.of(context).profile_story_point_title,
              textEditingController: _controller.storyPointsController,
              onChanged: (val) => _controller.validate(),
              hintText: S.of(context).profile_story_point_title,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: Dimens.SPACE_20),
            DefaultFormFieldWithLongText(
              enabledBorderColor: _controller.validateDesc &&
                      _controller.descriptionController.text.isEmpty
                  ? ColorsItem.redDA1414
                  : ColorsItem.grey666B73,
              focusedBorderColor: _controller.validateDesc &&
                      _controller.descriptionController.text.isEmpty
                  ? ColorsItem.redDA1414
                  : ColorsItem.grey666B73,
              hintText: S.of(context).room_detail_comment_hint,
              label: S.of(context).room_detail_description_label,
              maxLines: 5,
              onChanged: (val) => _controller.validate(),
              textEditingController: _controller.descriptionController,
            ),
            SizedBox(height: Dimens.SPACE_8),
            _controller.validateDesc &&
                    _controller.descriptionController.text.isEmpty
                ? Text(
                    S.of(context).error_description_empty,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.redDA1414,
                      fontSize: Dimens.SPACE_12,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: Dimens.SPACE_20),
            DefaultFormFieldWithAction(
              children: _buildSearchItems(_controller.visibleTo),
              label: S.of(context).label_visible_to,
              onTap: () {
                _controller.onChangeVisibility();
              },
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                  color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_16),
            ),
            SizedBox(height: Dimens.SPACE_20),
            DefaultFormFieldWithAction(
              children: _buildSearchItems(_controller.editableBy),
              label: S.of(context).label_editable_to,
              onTap: () {
                _controller.onChangeEditability();
              },
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                  color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_16),
            ),
            SizedBox(height: Dimens.SPACE_20),
            DefaultFormFieldWithAction(
              children: _buildSearchItems(_controller.label),
              label: S.of(context).label_tag,
              onTap: () {
                _controller.onSearchProjects();
              },
              icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                  color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_16),
            ),
            SizedBox(height: Dimens.SPACE_20),
          ],
        ),
      ),
    );
  }

  _bugReportedBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).ticket_bug_reporter,
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
        SizedBox(height: Dimens.SPACE_8),
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                  labelStyle:
                      GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsItem.grey666B73))),
              isEmpty: _controller.ticketReportedBy == '',
              child: DropdownButtonHideUnderline(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: ColorsItem.black020202,
                  ),
                  child: DropdownButton<String>(
                    value: _controller.ticketReportedBy,
                    isDense: true,
                    style:
                        GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE),
                    onChanged: (String? newValue) {
                      _controller.onTicketReportChanged(newValue);
                    },
                    items: _controller.ticketReports.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: Dimens.SPACE_20),
      ],
    );
  }

  Widget _calendarContent() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.SPACE_20),
      child: AnimatedTheme(
        data: Theme.of(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DefaultFormField(
                label: S.of(context).label_title,
                textEditingController: _controller.titleController,
                onChanged: (val) => _controller.validate(),
                hintText: S.of(context).profile_profile_name_label,
                enabledBorderColor: _controller.validateTitle &&
                        _controller.titleController.text.isEmpty
                    ? ColorsItem.redDA1414
                    : ColorsItem.grey666B73,
                focusedBorderColor: _controller.validateTitle &&
                        _controller.titleController.text.isEmpty
                    ? ColorsItem.redDA1414
                    : ColorsItem.grey666B73,
              ),
              SizedBox(height: Dimens.SPACE_8),
              _controller.validateTitle &&
                      _controller.titleController.text.isEmpty
                  ? Text(
                      S.of(context).error_title_empty,
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.redDA1414,
                        fontSize: Dimens.SPACE_12,
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: Dimens.SPACE_20),
              DefaultFormField(
                label: S.of(context).room_calendar_startdate,
                textEditingController: _controller.startDateController,
                onTap: () {
                  _selectStartDate();
                },
                onChanged: (val) => _controller.validate(),
                hintText: S.of(context).room_calendar_choose_date,
                enabledBorderColor: _controller.validateDate &&
                        _controller.startDateController.text.isEmpty
                    ? ColorsItem.redDA1414
                    : ColorsItem.grey666B73,
                focusedBorderColor: _controller.validateDate &&
                        _controller.startDateController.text.isEmpty
                    ? ColorsItem.redDA1414
                    : ColorsItem.grey666B73,
                prefixIcon: Icon(FontAwesomeIcons.calendarDay),
              ),
              SizedBox(height: Dimens.SPACE_8),
              _controller.validateDate &&
                      _controller.startDateController.text.isEmpty
                  ? Text(
                      S.of(context).error_date_selected,
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.redDA1414,
                        fontSize: Dimens.SPACE_12,
                      ),
                    )
                  : SizedBox(),
              _controller.validateDate
                  ? SizedBox(height: Dimens.SPACE_8)
                  : SizedBox(),
              _controller.isAllDay
                  ? SizedBox()
                  : SizedBox(height: Dimens.SPACE_8),
              _controller.isAllDay
                  ? SizedBox()
                  : DefaultFormField(
                      textEditingController: _controller.startTimeController,
                      onChanged: (val) => _controller.validate(),
                      hintText: S.of(context).room_calendar_choose_time,
                      onTap: () {
                        _selectStartTime();
                      },
                      prefixIcon: Icon(
                        FontAwesomeIcons.clock,
                      ),
                    ),
              SizedBox(height: Dimens.SPACE_20),
              DefaultFormField(
                label: S.of(context).room_calendar_enddate,
                textEditingController: _controller.endDateController,
                onTap: () {
                  _selectEndDate();
                },
                onChanged: (val) => _controller.validate(),
                hintText: S.of(context).room_calendar_choose_date,
                enabledBorderColor: _controller.validateDate &&
                        _controller.endDateController.text.isEmpty
                    ? ColorsItem.redDA1414
                    : ColorsItem.grey666B73,
                focusedBorderColor: _controller.validateDate &&
                        _controller.endDateController.text.isEmpty
                    ? ColorsItem.redDA1414
                    : ColorsItem.grey666B73,
                prefixIcon: Icon(
                  FontAwesomeIcons.calendarDay,
                ),
              ),
              SizedBox(height: Dimens.SPACE_8),
              _controller.validateDate &&
                      _controller.endDateController.text.isEmpty
                  ? Text(
                      S.of(context).error_date_selected,
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.redDA1414,
                        fontSize: Dimens.SPACE_12,
                      ),
                    )
                  : SizedBox(),
              _controller.validateDate
                  ? SizedBox(height: Dimens.SPACE_8)
                  : SizedBox(),
              _controller.isAllDay
                  ? SizedBox()
                  : SizedBox(height: Dimens.SPACE_8),
              _controller.isAllDay
                  ? SizedBox()
                  : DefaultFormField(
                      textEditingController: _controller.endTimeController,
                      onChanged: (val) => _controller.validate(),
                      hintText: S.of(context).room_calendar_choose_time,
                      onTap: () {
                        _selectEndTime();
                      },
                      prefixIcon: Icon(
                        FontAwesomeIcons.clock,
                      ),
                    ),
              SizedBox(height: Dimens.SPACE_12),
              Row(
                children: [
                  Theme(
                    child: Checkbox(
                      checkColor: Colors.black,
                      activeColor: ColorsItem.orangeFB9600,
                      onChanged: (bool? value) {
                        _controller.onSelectedAllDay();
                      },
                      value: _controller.isAllDay,
                    ),
                    data: ThemeData(
                      unselectedWidgetColor: Colors.grey,
                    ),
                  ),
                  Text(S.of(context).room_calendar_all_day,
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14))
                ],
              ),
              SizedBox(height: Dimens.SPACE_12),
              DefaultFormFieldWithAction(
                children: _buildSearchItems(_controller.participants),
                label: S.of(context).room_detail_member_title,
                onTap: () {
                  _controller.onSearchCalendarParticipants();
                },
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                    size: Dimens.SPACE_16),
              ),
              SizedBox(height: Dimens.SPACE_20),
              DefaultFormFieldWithAction(
                children: _buildSearchItems(_controller.subscribers),
                label: S.of(context).label_subscriber,
                onTap: _controller.onSearchSubscribers,
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                    size: Dimens.SPACE_16),
              ),
              SizedBox(height: Dimens.SPACE_20),
              DefaultFormFieldWithLongText(
                enabledBorderColor: _controller.validateDesc &&
                        _controller.descriptionController.text.isEmpty
                    ? ColorsItem.redDA1414
                    : ColorsItem.grey666B73,
                focusedBorderColor: _controller.validateDesc &&
                        _controller.descriptionController.text.isEmpty
                    ? ColorsItem.redDA1414
                    : ColorsItem.grey666B73,
                hintText: S.of(context).room_detail_comment_hint,
                label: S.of(context).room_detail_description_label,
                maxLines: 5,
                onChanged: (val) => _controller.validate(),
                textEditingController: _controller.descriptionController,
              ),
              SizedBox(height: Dimens.SPACE_8),
              _controller.validateDesc &&
                      _controller.descriptionController.text.isEmpty
                  ? Text(
                      S.of(context).error_description_empty,
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.redDA1414,
                        fontSize: Dimens.SPACE_12,
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: Dimens.SPACE_20),
              DefaultFormFieldWithAction(
                children: _buildSearchItems(_controller.visibleTo),
                label: S.of(context).label_visible_to,
                onTap: () {
                  _controller.onChangeVisibility();
                },
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                    size: Dimens.SPACE_16),
              ),
              SizedBox(height: Dimens.SPACE_20),
              DefaultFormFieldWithAction(
                children: _buildSearchItems(_controller.editableBy),
                label: S.of(context).label_editable_to,
                onTap: () {
                  _controller.onChangeEditability();
                },
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                    size: Dimens.SPACE_16),
              ),
              SizedBox(height: Dimens.SPACE_20),
              DefaultFormFieldWithAction(
                children: _buildSearchItems(_controller.label),
                label: S.of(context).label_tag,
                onTap: () {
                  _controller.onSearchProjects();
                },
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                    size: Dimens.SPACE_16),
              ),
              SizedBox(height: Dimens.SPACE_20),
            ],
          ),
        ),
      ),
    );
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

  String _getTitle() {
    String? _type;
    String? _status;
    if (_controller.argsType == Stickit) {
      _type = S.of(context).label_stickit;
      if (_controller.stickitObj == null)
        _status = S.of(context).label_create;
      else
        _status = S.of(context).label_edit;
    } else if (_controller.argsType == Ticket) {
      if (_controller.isSubTask) {
        return S.of(context).detail_subtask_create_label;
      }
      _type = S.of(context).label_ticket;
      if (_controller.ticketObj == null)
        _status = S.of(context).label_create;
      else
        _status = S.of(context).label_edit;
    } else if (_controller.argsType == Calendar) {
      _type = S.of(context).label_calendar;
      if (_controller.calendarObj == null)
        _status = S.of(context).label_create;
      else
        _status = S.of(context).label_edit;
    } else if (_controller.argsType == Project) {
      _type = S.of(context).label_ticket;
      _status = S.of(context).label_create;
    }

    return "$_status $_type";
  }

  _selectStartDate() async {
    DateTime selectedDate = _controller.dateUtil.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: _controller.dateUtil.now(),
      lastDate: _controller.dateUtil.from(_controller.dateUtil.now().year + 1),
    );
    if (picked != null) _controller.setCalendarStartDate(picked);
  }

  _selectEndDate() async {
    if (_controller.startDate != null &&
        (_controller.startTime != null || _controller.isAllDay)) {
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

  _selectStartTime() async {
    TimeOfDay selectedTime = TimeOfDay(
      hour: _controller.dateUtil.now().hour,
      minute: _controller.dateUtil.now().minute,
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) _controller.setCalendarStartTime(picked);
  }

  _selectEndTime() async {
    if (_controller.startDate != null && _controller.startTime != null) {
      TimeOfDay selectedTime = TimeOfDay(
        hour: _controller.dateUtil.now().hour,
        minute: _controller.dateUtil.now().minute,
      );
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null) _controller.setCalendarEndTime(picked);
    } else {
      _controller.showNotif(
          context, S.of(context).create_form_date_picker_alert);
    }
  }
}
