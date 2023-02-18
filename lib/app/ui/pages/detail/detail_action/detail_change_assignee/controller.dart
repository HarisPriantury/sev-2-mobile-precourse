import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_assignee/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_assignee/presenter.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:stream_transform/src/rate_limit.dart';

class DetailChangeAssigneeControler extends BaseController {
  final DetailChangeAssigneePresenter _presenter;
  late final DetailChangeAssigneeArgs _data;
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNodeSearch = FocusNode();
  final StreamController<String> _streamController = StreamController<String>();
  List<User> _searchAssignee = [];
  String _keyword = "";
  bool _isSearch = false;
  bool _isPaginating = false;
  User? _selectedUser;

  DetailChangeAssigneeControler(this._presenter);

  DetailChangeAssigneeArgs get data => _data;
  List<User> get searchAssignee => _searchAssignee;
  TextEditingController get searchController => _searchController;
  FocusNode get focusNodeSearch => _focusNodeSearch;
  StreamController<String> get streamController => _streamController;
  User? get selectedUser => _selectedUser;

  void clearSearch() {
    _searchController.text = "";
    _keyword = "";
    onSearch(false);
    _searchAssignee.clear();
    loading(true);
    _searchAssignee.clear();
    _searchUser(_keyword, reset: true);
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
      _searchAssignee.clear();
      _searchUser(_keyword, reset: true);
      refreshUI();
    });
  }

  void searchScrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      _isPaginating = true;
      _searchUser(_keyword);
    }
  }

  void _searchUser(String keyword, {bool reset = false}) {
    if (!_isPaginating) loading(true);

    _presenter.onGetUsers(
      GetUsersApiRequest(
        nameLike: keyword,
      ),
    );
  }

  bool validateCurrentAssignee() {
    return _data.currentAssignee != _selectedUser;
  }

  void onSaveAddAssignee() {
    Navigator.of(context).pop(_selectedUser);
  }

  void onSelectUser(String? id) {
    _selectedUser = _searchAssignee.firstWhere((user) => user.id == id);
    refreshUI();
  }

  bool isUserSelected(User selectedUser) {
    bool isSelected = false;
    return isSelected;
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as DetailChangeAssigneeArgs;
    }
  }

  @override
  void load() {
    _selectedUser = data.currentAssignee;
    _searchUser(_keyword, reset: true);
  }

  @override
  void initListeners() {
    _focusNodeSearch.addListener(onFocusChange);
    _initStream();

    _presenter.getUsersOnNext = (List<User> users, PersistenceType type) {
      print("detailChangeAssignee: success getUsers $type, ${users.length}");

      _searchAssignee.addAll(users);
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("detailChangeAssignee: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      print("detailChangeAssignee: error getUsers: $e $type");
      loading(false);
    };
  }

  @override
  void disposing() {
    _searchController.dispose();
    _streamController.close();
    _presenter.dispose();
  }
}
