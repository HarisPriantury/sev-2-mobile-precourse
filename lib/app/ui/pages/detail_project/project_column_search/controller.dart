import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/move_ticket_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/project.dart';

class ProjectColumnSearchController extends BaseController {
  ProjectColumnSearchController(this._presenter);

  ProjectColumnSearchArgs? _data;
  TextEditingController _descriptionController = new TextEditingController();
  ProjectColumnSearchPresenter _presenter;
  List<ProjectColumn> _projectColumns = [];
  List<PhObject> _projects = [];
  String? _selectedColumn;
  TextEditingController _titleController = new TextEditingController();
  late ProjectColumnSearchType _type;

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as ProjectColumnSearchArgs;
      _type = _data!.type;
      _projectColumns = _data!.projectColumn;
      _selectedColumn = _data!.projectColumn.first.id;
      print("getArgs : ${_data?.toPrint()}");
    }
  }

  @override
  void initListeners() {
    _presenter.moveTicketOnNext = (List<BaseApiResponse>? response) {
      print("ProjectColumnSearch: success moveTicket");
      Navigator.pop(context);
      Navigator.pop(context, response);
      refreshUI();
    };

    _presenter.moveTicketOnComplete = () {
      print("ProjectColumnSearch: complete moveTicket");
    };

    _presenter.moveTicketOnError = (e) {
      print("ProjectColumnSearch: error moveTicket, $e");
      showNotif(context, S.of(context).error_disconnected);
    };

    _presenter.getColumnsTicketOnNext = (List<ProjectColumn> columns) {
      print("ProjectColumnSearch: success getColumnTicket ${columns.length}");
      _projectColumns = columns;
      _selectedColumn = columns.first.id;
    };

    _presenter.getColumnsTicketOnComplete = () {
      print("ProjectColumnSearch: completed getColumnTicket");
      loading(false);
      refreshUI();
    };

    _presenter.getColumnsTicketOnError = (e) {
      print("ProjectColumnSearch: error getColumnTicket: $e");
      loading(false);
    };
  }

  @override
  void load() {
    // TODO: implement load
  }

  TextEditingController get titleController => _titleController;

  TextEditingController get descriptionController => _descriptionController;

  List<PhObject> get label => _projects;

  ProjectColumnSearchType get type => _type;

  bool isMoveToProject() {
    return _type == ProjectColumnSearchType.moveTicketToProject;
  }

  String? get selectedColumn => _selectedColumn;

  List<ProjectColumn> get projectColumns => _projectColumns;

  ProjectColumnSearchArgs? get projectData => _data;

  void onSelectedColumn(String? newValue) {
    _selectedColumn = newValue;
    refreshUI();
  }

  void onMoveTicket() {
    showOnLoading(context, "Loading...");
    _presenter.onMoveTicket(MoveTicketApiRequest(
      "${_data?.projectId}",
      "$_selectedColumn",
      _data!.ticketIds ?? [],
    ));
  }

  Future<void> onSearchProjects() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs('project',
          title: S.of(context).label_project,
          placeholderText: "Pilih Project",
          selectedBefore: _projects,
          type: SearchSelectionType.single),
    );

    if (result != null) {
      _projects.clear();
      Project project;
      project = result as Project;
      _projects = [project];
      _presenter.onGetColumnTicket(
          GetProjectColumnTicketApiRequest(_projects.first.id));
      refreshUI();
    }
  }
}
