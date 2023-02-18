import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_project/presenter.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:stream_transform/src/rate_limit.dart';

import 'args.dart';

class DetailChangeProjectController extends BaseController {
  DetailChangeProjectPresenter _presenter;
  late DetailChangeProjectArgs _data;
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNodeSearch = FocusNode();
  final StreamController<String> _streamController = StreamController<String>();
  List<Project> _searchProject = [];
  String _keyword = "";
  bool _isSearch = false;
  bool _isPaginating = false;
  List<Project> _listSelectedProject = [];

  DetailChangeProjectController(this._presenter);

  DetailChangeProjectArgs get data => _data;
  TextEditingController get searchController => _searchController;
  FocusNode get focusNodeSearch => _focusNodeSearch;
  StreamController<String> get streamController => _streamController;
  List<Project> get searchProject => _searchProject;
  List<Project> get listSelectedProject => _listSelectedProject;

  @override
  void load() {
    _listSelectedProject = _data.currentProjects;
    _searchProjects(_keyword, reset: true);
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as DetailChangeProjectArgs;
    }
  }

  void clearSearch() {
    _searchController.text = "";
    _keyword = "";
    onSearch(false);
    _searchProject.clear();
    loading(true);
    _searchProject.clear();
    _searchProjects(_keyword, reset: true);
  }

  void onSearch(bool isSearching) {
    _isSearch = isSearching;

    if (_isSearch) {
      _focusNodeSearch.requestFocus();
    } else {
      _focusNodeSearch.unfocus();
      _searchController.clear();
    }
    refreshUI();
  }

  void onFocusChange() {
    if (_focusNodeSearch.hasFocus) {
    } else if (_searchController.text.isEmpty) {
      onSearch(false);
    }
  }

  void _initStream() {
    listScrollController.addListener(searchScrollListener);
    _streamController.stream
        .transform(
      StreamTransformer.fromBind(
        (s) => s.debounce(
          const Duration(milliseconds: 750),
        ),
      ),
    )
        .listen((s) {
      _keyword = s.toLowerCase();
      loading(true);
      _searchProject.clear();
      _searchProjects(_keyword, reset: true);
      refreshUI();
    });
  }

  void searchScrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      _isPaginating = true;
      _searchProjects(_keyword);
    }
  }

  void _searchProjects(String keyword, {bool reset = false}) {
    if (!_isPaginating) loading(true);

    if (_data.type == DetailChangeProjectType.add) {
      _presenter.onGetProjects(
        GetProjectsApiRequest(
          nameLike: keyword,
        ),
      );
    } else {
      List<String> projectIds = _listSelectedProject.map((e) => e.id).toList();

      if (projectIds.isNotEmpty) {
        _presenter.onGetProjects(
          GetProjectsApiRequest(
            nameLike: keyword,
            ids: projectIds,
          ),
        );
      } else {
        loading(false);
      }
    }
  }

  void onSelectProject(Project selectedProject) {
    if (isProjectSelected(selectedProject)) {
      _listSelectedProject.removeWhere(
        (project) => project.id == selectedProject.id,
      );
    } else {
      _listSelectedProject.add(selectedProject);
    }
    refreshUI();
  }

  bool isProjectSelected(Project selectedProject) {
    bool isSelected = false;

    for (Project project in _listSelectedProject) {
      if (project.id == selectedProject.id) {
        isSelected = true;
        break;
      }
    }

    return isSelected;
  }

  bool validateExistProject(Project project) {
    bool isExist = false;
    for (Project existProject in _data.currentProjects) {
      if (existProject.id == project.id) {
        isExist = true;
        break;
      }
    }

    return isExist;
  }

  void onRemoveProject(Project project) {
    _listSelectedProject.removeWhere((p) => p.id == project.id);
    _searchProject.removeWhere((p) => p.id == project.id);
    refreshUI();
  }

  bool validateSaveProject() {
    return _listSelectedProject.length != _data.currentProjects.length ||
        _listSelectedProject.isNotEmpty;
  }

  void onSaveChangeProject() {
    Navigator.of(context).pop(listSelectedProject);
  }

  @override
  void initListeners() {
    _focusNodeSearch.addListener(onFocusChange);
    _initStream();

    _presenter.getProjectsOnNext =
        (List<Project> projects, PersistenceType type) {
      print(
          "detailChangeProject: success getProjets : $type ${projects.length}");
      _searchProject.addAll(projects);
    };

    _presenter.getProjectsOnComplete = (PersistenceType type) {
      print("detailChangeProject: completed getProjects : $type");
      loading(false);
    };

    _presenter.getProjectsOnError = (e, PersistenceType type) {
      print("detailChangeProject: error getUsers: $e $type");
      loading(false);
    };
  }

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
    _searchController.dispose();
    _focusNodeSearch.dispose();
  }
}
