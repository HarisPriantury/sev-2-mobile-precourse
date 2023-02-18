import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/create/custom_policy/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class CustomPolicyPage extends View {
  final Object? arguments;

  CustomPolicyPage({this.arguments});

  @override
  _CustomPolicyState createState() => _CustomPolicyState(
      AppComponent.getInjector().get<CustomPolicyController>(), arguments);
}

class _CustomPolicyState
    extends ViewState<CustomPolicyPage, CustomPolicyController> {
  CustomPolicyController _controller;

  _CustomPolicyState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<CustomPolicyController>(
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
                  S.of(context).label_custom_policy,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                suffix: GestureDetector(
                  onTap: () {
                    _controller.backWithArguments();
                  },
                  child: Text(
                    S.of(context).label_add,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: Dimens.SPACE_14,
                        color: _controller.isValidated()
                            ? ColorsItem.orangeFB9600
                            : ColorsItem.grey606060),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).label_status,
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.greyB8BBBF,
                          fontSize: Dimens.SPACE_12)),
                  SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.status == '',
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: ColorsItem.black020202,
                            ),
                            child: DropdownButton<String>(
                              value: _controller.status,
                              isDense: true,
                              style: GoogleFonts.montserrat(),
                              onChanged: (String? newValue) {
                                _controller.onSelectedStatus(newValue);
                              },
                              items: _controller.statusList.map((String value) {
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
                  Text(
                      _controller.status != null
                          ? "${_controller.status} To"
                          : "Allow To",
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.greyB8BBBF,
                          fontSize: Dimens.SPACE_12)),
                  SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.target == '',
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: ColorsItem.black020202,
                            ),
                            child: DropdownButton<String>(
                              value: _controller.target,
                              isDense: true,
                              style: GoogleFonts.montserrat(),
                              onChanged: (String? newValue) {
                                _controller.onSelectedTarget(newValue);
                              },
                              items: _controller.targetList.map((String value) {
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
                  _populateWidgetFromSelectedTarget()
                ],
              ),
            ),
          );
        }),
      );

  Widget _populateWidgetFromSelectedTarget() {
    if (_controller.target == _controller.targetList[0])
      return _userForm();
    else if (_controller.target == _controller.targetList[1])
      return _membersOfAnyProjectForm();
    else if (_controller.target == _controller.targetList[2])
      return _membersOfAllProjectsForm();
    else if (_controller.target == _controller.targetList[6])
      return _documentsForm();
    else if (_controller.target == _controller.targetList[7])
      return _moonTimeForm();
    else
      return SizedBox();
  }

  Widget _userForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Username",
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
        SizedBox(height: Dimens.SPACE_8),
        GestureDetector(
          onTap: () {
            _controller.onSearchUsers();
          },
          child: Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                border: Border.all(color: ColorsItem.grey888888, width: 1),
                borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _buildSearchItems(_controller.users),
                    ),
                  ),
                ),
                Container(
                  color: ColorsItem.grey666B73,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimens.SPACE_14),
                        child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                            size: Dimens.SPACE_16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _membersOfAnyProjectForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Project Name",
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
        SizedBox(height: Dimens.SPACE_8),
        GestureDetector(
          onTap: () {
            _controller.onSearchProjects();
          },
          child: Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                border: Border.all(color: ColorsItem.grey888888, width: 1),
                borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _buildSearchItems(_controller.projects),
                    ),
                  ),
                ),
                Container(
                  color: ColorsItem.grey666B73,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimens.SPACE_14),
                        child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                            size: Dimens.SPACE_16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _membersOfAllProjectsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Projects Name",
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
        SizedBox(height: Dimens.SPACE_8),
        GestureDetector(
          onTap: () {
            _controller.onSearchProjects();
          },
          child: Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                border: Border.all(color: ColorsItem.grey888888, width: 1),
                borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _buildSearchItems(_controller.projects),
                    ),
                  ),
                ),
                Container(
                  color: ColorsItem.grey666B73,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimens.SPACE_14),
                        child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                            size: Dimens.SPACE_16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _documentsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Documents name",
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
        SizedBox(height: Dimens.SPACE_8),
        GestureDetector(
          onTap: () {
            _controller.onSearchDocuments();
          },
          child: Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                border: Border.all(color: ColorsItem.grey888888, width: 1),
                borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _buildSearchItems(_controller.documents),
                    ),
                  ),
                ),
                Container(
                  color: ColorsItem.grey666B73,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimens.SPACE_14),
                        child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                            size: Dimens.SPACE_16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _moonTimeForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("When the moon",
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
        SizedBox(height: Dimens.SPACE_8),
        FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                  labelStyle: GoogleFonts.montserrat(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsItem.grey666B73))),
              isEmpty: _controller.moonTime == '',
              child: DropdownButtonHideUnderline(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: ColorsItem.black020202,
                  ),
                  child: DropdownButton<String>(
                    value: _controller.moonTime,
                    isDense: true,
                    style: GoogleFonts.montserrat(),
                    onChanged: (String? newValue) {
                      _controller.onSelectedMoonTime(newValue);
                    },
                    items: _controller.moonTimeList.map((String value) {
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
      ],
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
          child: Text(obj.name!, style: GoogleFonts.montserrat()),
        ),
      ));
    }
    chips.add(SizedBox(width: Dimens.SPACE_4));
    return chips;
  }
}
