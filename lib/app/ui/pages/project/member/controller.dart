import 'dart:async';

import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/presenter.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/create_project_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:stream_transform/stream_transform.dart';

import 'args.dart';

class ProjectMemberController extends BaseController {
  ProjectMemberPresenter _presenter;
  ProjectMemberArgs? _data;
  late Project _project;
  List<User> _participants = [];
  List<User> userList;
  EventBus _eventBus;

  bool isChanged = false;

  List<User> _searchedObjects = [];
  List<User> _selectedObjects = List.empty(growable: true);
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final StreamController<String> _streamController = StreamController();

  List<User> get searchedObjects => _searchedObjects;

  List<User> get selectedObjects => _selectedObjects;

  TextEditingController get searchController => _searchController;

  FocusNode get focusNode => _focusNode;

  StreamController<String> get streamController => _streamController;

  ProjectMemberActionType type = ProjectMemberActionType.add;

  ProjectMemberController(
    this._presenter,
    this.userList,
    this._eventBus,
  );

  Project get project => _project;

  List<User> get participants => _participants;

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as ProjectMemberArgs;
      _project = _data!.project;
      type = _data!.type;
      // if (_project.members != null) _participants = _project.members!;
      print(_data!.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.getUsersOnNext = (List<User> users) {
      print("search: success getUsers");
      _searchedObjects.clear();
      _searchedObjects.addAll(users);
    };

    _presenter.getUsersOnComplete = () {
      print("search: completed getUsers");
      loading(false);
      refreshUI();
    };

    _presenter.getUsersOnError = (e) {
      print("search: error getUsers: $e");
    };

    _presenter.createProjectOnNext = (BaseApiResponse resp) {
      print("create: success createProject");
    };

    _presenter.createProjectOnComplete = () {
      print("create: completed createProject");
      Navigator.pop(context);
      showNotif(context, "Success");
      isChanged = true;
      refreshUI();
      if (type == ProjectMemberActionType.add) {
        _eventBus.fire(Refresh());
        Navigator.of(context).pop(true);
      }
    };

    _presenter.createProjectOnError = (e) {
      Navigator.pop(context);
      showNotif(context, "Something went wrong");
      print("create: error createProject: $e");
      refreshUI();
    };
  }

  @override
  void load() {
    mapUsers();
    if (type == ProjectMemberActionType.add) {
      _presenter.onGetUsers(GetUsersApiRequest());
      _selectedObjects.addAll(_participants);
    } else {
      loading(false);
    }
    _initStream();
  }

  void _initStream() {
    _streamController.stream
        .transform(
      StreamTransformer.fromBind(
        (s) => s.debounce(
          const Duration(
            milliseconds: 750,
          ),
        ),
      ),
    )
        .listen(
      (s) {
        _presenter.onGetUsers(
          GetUsersApiRequest(nameLike: s),
        );
        refreshUI();
      },
    );
  }

  void mapUsers() {
    if (_data != null) {
      if (_data!.project.members != null) {
        _data!.project.members!.forEach((user) {
          User? _user =
              userList.firstWhereOrNull((element) => element.id == user.id);
          if (_user != null) {
            _participants.add(_user);
          } else {
            _participants.add(user);
          }
        });
      }
    }
  }

  void onRemoveMember(User user) {
    _participants.removeWhere((element) => element.id == user.id);
    _data!.project.members = _participants;
    showOnLoading(context, null);
    _presenter.onCreateProject(
      CreateProjectApiRequest(
        membersPhid: _participants.map((e) => e.id).toList(),
        objectIdentifier: _project.id,
      ),
    );
  }

  void onSetMembers() {
    showOnLoading(context, null);
    _data!.project.members = _selectedObjects;
    _presenter.onCreateProject(
      CreateProjectApiRequest(
        membersPhid: _selectedObjects.map((e) => e.id).toList(),
        objectIdentifier: _project.id,
      ),
    );
  }

  void goToProfile(User user) {
    Navigator.pushNamed(context, Pages.profile,
        arguments: ProfileArgs(user: user));
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
}
