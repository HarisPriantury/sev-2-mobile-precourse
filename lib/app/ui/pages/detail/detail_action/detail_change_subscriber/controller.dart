import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_subscriber/args.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:stream_transform/src/rate_limit.dart';

import 'presenter.dart';

class DetailChangeSubscriberController extends BaseController {
  final DetailChangeSubscriberPresenter _presenter;
  late DetailChangeSubscriberArgs _data;
  final TextEditingController _searchController = TextEditingController();
  FocusNode _focusNodeSearch = FocusNode();
  final StreamController<String> _streamController = StreamController<String>();
  List<User> _searchSubscriber = [];
  String _keyword = "";
  bool _isSearch = false;
  bool _isPaginating = false;
  List<User> _listSelectedUser = [];
  List<User> _listRemovedSubscriber = [];

  DetailChangeSubscriberController(this._presenter);

  DetailChangeSubscriberArgs get data => _data;
  TextEditingController get searchController => _searchController;
  FocusNode get focusNodeSearch => _focusNodeSearch;
  StreamController<String> get streamController => _streamController;
  List<User> get searchSubscriber => _searchSubscriber;
  List<User> get listSelectedUser => _listSelectedUser;

  @override
  void getArgs() {
    if (args != null) {
      _data = args as DetailChangeSubscriberArgs;
    }
  }

  @override
  void load() {
    if (data.type == DetailChangeSubscriberType.search) {
      _listSelectedUser = _data.currentSubscriber;
    }

    _searchUser(_keyword, reset: true);
  }

  bool validateSaveAddSubscriber() {
    return _listSelectedUser.isNotEmpty;
  }

  bool validateSaveSearchSubsrcriber() {
    return _listRemovedSubscriber.isNotEmpty;
  }

  bool validateExistSubscriber(User user) {
    bool isExist = false;

    for (User existUser in _data.currentSubscriber) {
      if (existUser.id == user.id) {
        isExist = true;
        break;
      }
    }
    return isExist;
  }

  void clearSearch() {
    _searchController.text = "";
    _keyword = "";
    onSearch(false);
    _searchSubscriber.clear();
    loading(true);
    _searchSubscriber.clear();
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
      _searchSubscriber.clear();
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

    if (_data.type == DetailChangeSubscriberType.add) {
      _presenter.onGetUsers(
        GetUsersApiRequest(
          nameLike: keyword,
        ),
      );
    } else {
      _presenter.onGetUsers(
        GetUsersApiRequest(
          nameLike: keyword,
          ids: _listSelectedUser.map((e) => e.id).toList(),
        ),
      );
    }
  }

  void onSelectUser(User selectedUser) {
    if (isUserSelected(selectedUser)) {
      _listSelectedUser.removeWhere((user) => user.id == selectedUser.id);
    } else {
      _listSelectedUser.add(selectedUser);
    }
    refreshUI();
  }

  bool isUserSelected(User selectedUser) {
    bool isSelected = false;

    for (User user in _listSelectedUser) {
      if (user.id == selectedUser.id) {
        isSelected = true;
        break;
      }
    }
    return isSelected;
  }

  void onSaveAddSubscriber() {
    Navigator.of(context).pop(listSelectedUser);
  }

  void onSaveSearchSubscriber() {
    Navigator.of(context).pop(_listRemovedSubscriber);
  }

  void onRemoveSubscriber(User user) {
    _searchSubscriber.removeWhere((e) => e.id == user.id);
    _listSelectedUser.removeWhere((e) => e.id == user.id);
    _listRemovedSubscriber.add(user);

    refreshUI();
  }

  @override
  void initListeners() {
    _focusNodeSearch.addListener(onFocusChange);
    _initStream();

    _presenter.getUsersOnNext = (List<User> users, PersistenceType type) {
      print("detailChangeSubscriber: success getUsers $type, ${users.length}");

      _searchSubscriber.addAll(users);
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("detailChangeSubscriber: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      print("detailChangeSubscriber: error getUsers: $e $type");
      loading(false);
    };
  }

  @override
  void disposing() {
    _presenter.dispose();
    _searchController.dispose();
    _streamController.close();
  }
}
