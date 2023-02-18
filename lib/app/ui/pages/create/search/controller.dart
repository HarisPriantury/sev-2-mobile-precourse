import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/presenter.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:stream_transform/stream_transform.dart';

class ObjectSearchController extends BaseController {
  ObjectSearchPresenter _presenter;
  ObjectSearchArgs? _data;

  List<PhObject> _searchedObjects = [];
  List<PhObject> _selectedObjects = List.empty(growable: true);

  bool _isUpdate = false;

  PhObject? _singleSelectedObject;

  String? get title => _data?.title;

  String? get placeholderText => _data?.placeholderText;

  PhObject? get singleSelectedObject => _singleSelectedObject;

  SearchSelectionType get searchSelectionType => _data!.type;

  bool _isSearch = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final StreamController<String> _streamController = StreamController();

  bool get isUpdate => _isUpdate;

  List<PhObject> get searchedObjects => _searchedObjects;

  List<PhObject> get selectedObjects => _selectedObjects;

  bool get isSearch => _isSearch;

  TextEditingController get searchController => _searchController;

  FocusNode get focusNode => _focusNode;

  StreamController<String> get streamController => _streamController;

  ObjectSearchController(this._presenter);

  @override
  void load() {
    if (_data?.objectType == 'user') {
      _presenter.onGetUsers(GetUsersApiRequest());
    } else if (_data?.objectType == 'project') {
      _presenter.onGetProjects(GetProjectsApiRequest());
    }

    _initStream();
  }

  void _initStream() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      if (_data?.objectType == 'user') {
        _presenter.onGetUsers(GetUsersApiRequest(nameLike: s));
      } else if (_data?.objectType == 'project') {
        _presenter.onGetProjects(GetProjectsApiRequest(nameLike: s));
      }
      // _resultObjects = _searchedObjects
      //     .where((u) =>
      //         u.name!.toLowerCase().contains(s.toLowerCase()) || u.fullName!.toLowerCase().contains(s.toLowerCase()))
      //     .toList();
      refreshUI();
    });
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as ObjectSearchArgs;
      if (_data!.selectedBefore != null) {
        if (_data!.type == SearchSelectionType.multiple)
          _selectedObjects.addAll(_data!.selectedBefore!);
        if (_data!.selectedBefore!.isNotEmpty) _isUpdate = true;
      }
      print(_data?.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.getUsersOnNext = (List<User> users) {
      print("search: success getUsers");
      _searchedObjects.clear();
      _searchedObjects.addAll(users);
      if (_data?.type == SearchSelectionType.single &&
          _data?.selectedBefore != null) {
        onSingleSelectObject(users.singleWhere(
            (element) => element.id == _data!.selectedBefore!.first.id));
      }
    };

    _presenter.getUsersOnComplete = () {
      print("search: completed getUsers");
      loading(false);
      refreshUI();
    };

    _presenter.getUsersOnError = (e) {
      loading(false);
      print("search: error getUsers: $e");
    };

    _presenter.getProjectsOnNext = (List<Project> projects) {
      print("search: success getProjects");
      _searchedObjects.clear();
      _searchedObjects.addAll(projects);
      if (_data?.type == SearchSelectionType.single &&
          _data?.selectedBefore != null) {
        onSingleSelectObject(projects.singleWhere(
            (element) => element.id == _data!.selectedBefore!.first.id));
      }
    };

    _presenter.getProjectsOnComplete = () {
      print("search: completed getProjects");
      loading(false);
      refreshUI();
    };

    _presenter.getProjectsOnError = (e) {
      loading(false);
      print("search: error getProjects: $e");
    };
  }

  void onSelectObject(int index, bool? selected) {
    bool isSelected = selected ?? false;

    if (isSelected) {
      _selectedObjects.add(_searchedObjects[index]);
    } else {
      _selectedObjects
          .removeWhere((element) => element.id == _searchedObjects[index].id);
    }

    refreshUI();
  }

  bool isObjectSelected(int index) {
    return _selectedObjects
        .map((e) => e.id)
        .toList()
        .contains(_searchedObjects[index].id);
  }

  void onSingleSelectObject(PhObject? newObj) {
    _singleSelectedObject = newObj;
    refreshUI();
  }

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
  }
}
