import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class CustomPolicyController extends BaseController {
  String? _status;
  String? _target;

  final _statusList = ["Allow", "Deny"];
  final _targetList = [
    "Users",
    "Members of Any Project",
    "Members of All Projects",
    "Task Author",
    "Administrators",
    "Subscribers",
    "Signers of Legalpad Documents",
    "When the moon"
  ];
  final _moonTimeList = ["is full", "is new", "is waxing", "is waning"];

  List<PhObject> _users = List.empty(growable: true);
  List<PhObject> _projects = List.empty(growable: true);
  List<PhObject> _documents = List.empty(growable: true);
  String? _moonTime;

  String? get status => _status;

  String? get target => _target;

  List<String> get statusList => _statusList;

  List<String> get targetList => _targetList;

  List<String> get moonTimeList => _moonTimeList;

  List<PhObject> get users => _users;

  List<PhObject> get projects => _projects;

  List<PhObject> get documents => _documents;

  String? get moonTime => _moonTime;

  void onSelectedStatus(String? newValue) {
    _status = newValue;
    refreshUI();
  }

  void onSelectedTarget(String? newValue) {
    _target = newValue;
    refreshUI();
  }

  bool isValidated() {
    return false;
  }

  Future<void> onSearchUsers() async {
    var result = await Navigator.pushNamed(context, Pages.objectSearch,
        arguments: ObjectSearchArgs("user",
            title: S.of(context).create_form_search_user_label,
            placeholderText: S.of(context).create_form_search_user_select));
    _users.clear();
    _users.addAll(result as List<PhObject>);
    refreshUI();
  }

  Future<void> onSearchProjects() async {
    var result = await Navigator.pushNamed(context, Pages.objectSearch,
        arguments: ObjectSearchArgs("project",
            title: S.of(context).create_form_search_project_label,
            placeholderText: S.of(context).create_form_search_project_select));
    _projects.clear();
    _projects.addAll(result as List<PhObject>);
    refreshUI();
  }

  Future<void> onSearchDocuments() async {
    var result = await Navigator.pushNamed(context, Pages.objectSearch,
        arguments: ObjectSearchArgs("document",
            title: S.of(context).create_form_search_document_label,
            placeholderText: S.of(context).create_form_search_document_select));
    _documents.clear();
    _documents.addAll(result as List<PhObject>);
    refreshUI();
  }

  void onSelectedMoonTime(String? newValue) {
    _moonTime = newValue;
    refreshUI();
  }

  //TODO: send arguments to pop
  void backWithArguments() {
    Navigator.pop(context);
  }

  @override
  void disposing() {
    // TODO: implement disposing
  }

  @override
  void getArgs() {
    // TODO: implement getArgs
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }

  @override
  void load() {
    // TODO: implement load
  }
}
