import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class ProjectColumnSearchPage extends View {
  final Object? arguments;

  ProjectColumnSearchPage({this.arguments});

  @override
  _ProjectColumnSearchState createState() => _ProjectColumnSearchState(
      AppComponent.getInjector().get<ProjectColumnSearchController>(),
      arguments);
}

class _ProjectColumnSearchState
    extends ViewState<ProjectColumnSearchPage, ProjectColumnSearchController> {
  ProjectColumnSearchController _controller;

  _ProjectColumnSearchState(this._controller, Object? args)
      : super(_controller) {
    _controller.args = args;
  }
  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ProjectColumnSearchController>(
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
                    _controller.onMoveTicket();
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: Dimens.SPACE_24),
                    child: Text(
                      _getButtonSave(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.orangeFB9600),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_controller.isMoveToProject()) ...[
            Text(S.of(context).label_select_project,
                style: GoogleFonts.montserrat(
                    color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
            SizedBox(height: Dimens.SPACE_6),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.onSearchProjects();
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: ColorsItem.grey888888, width: 1),
                        borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _buildSearchItems(_controller.label),
                            ),
                          ),
                        ),
                        Container(
                          color: ColorsItem.grey666B73,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(Dimens.SPACE_14),
                                child: FaIcon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  size: Dimens.SPACE_16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
          _controller.label.isNotEmpty || !_controller.isMoveToProject()
              ? _buildSelectColumn()
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildSelectColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.SPACE_12),
        Text(S.of(context).label_select_column,
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF,
                fontSize: Dimens.SPACE_12,
                fontWeight: FontWeight.w700)),
        SizedBox(height: Dimens.SPACE_12),
        Row(
          children: [
            Expanded(
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                        labelStyle: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorsItem.grey666B73))),
                    isEmpty: _controller.selectedColumn == '',
                    child: DropdownButtonHideUnderline(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: ColorsItem.black020202,
                        ),
                        child: DropdownButton<String>(
                          value: _controller.selectedColumn,
                          isDense: true,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.whiteFEFEFE),
                          onChanged: (String? newValue) {
                            _controller.onSelectedColumn(newValue);
                          },
                          items: _controller.projectColumns.map((column) {
                            return DropdownMenuItem<String>(
                              value: column.id,
                              child: Text(column.name,
                                  overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getTitle() {
    if (_controller.type == ProjectColumnSearchType.moveOnWorkboard) {
      return _controller.projectData!.title;
    }

    String? _type;
    String? _status;
    _type = _controller.isMoveToProject()
        ? S.of(context).label_project
        : S.of(context).label_column;
    _status = S.of(context).label_move_ticket_to;

    return "$_status $_type";
  }

  String _getButtonSave() {
    String? _button;
    _button = S.of(context).label_move;
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
}
