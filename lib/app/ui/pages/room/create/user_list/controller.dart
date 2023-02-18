import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/user_list/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/user_list/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/room/create_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/db/user/create_user_db_request.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:stream_transform/stream_transform.dart';

class UserListController extends BaseController {
  UserListArgs? _data;

  bool _isSearch = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final StreamController<String> _streamController = StreamController();

  // properties
  UserListPresenter _presenter;
  UserData _userData;
  bool _isCreateGroup = false;
  bool _initialLoad = true;
  bool _isCreating = false;

  List<User> _users = [];
  List<User> _fUsers = [];
  List<User> _selectedUsers = List.empty(growable: true);
  List<Room> _rooms = [];

  // getter
  List<User> get users => _users;

  List<User> get selectedUsers => _selectedUsers;

  bool get isCreateGroup => _isCreateGroup;

  bool get isSearch => _isSearch;

  TextEditingController get searchController => _searchController;

  FocusNode get focusNode => _focusNode;

  StreamController<String> get streamController => _streamController;

  UserListController(this._presenter, this._userData) : super();

  @override
  void load() {
    _presenter.onGetUsers(GetUsersApiRequest());
    _initStream();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as UserListArgs;
      _rooms = _data!.roomList;
      print(_data?.toPrint());
    }
  }

  void _initStream() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      loading(true);
      _presenter.onGetUsers(GetUsersApiRequest(nameLike: s));
      refreshUI();
    });
  }

  bool isUserSelected(int index) {
    return _selectedUsers.map((e) => e.id).toList().contains(_users[index].id);
  }

  void clearSearch() {
    _searchController.text = "";
    onSearch(false);
    refreshUI();
  }

  void onSearch(bool isSearch) {
    _isSearch = isSearch;

    if (isSearch) {
      _focusNode.requestFocus();
    } else {
      _users.clear();
      _users.addAll(_fUsers);
    }
    refreshUI();
  }

  void chatUser(User user) {
    var idx = _rooms.indexWhere((element) =>
        element.participants!.indexWhere((element) => element.id == user.id) >
        -1);
    if (idx > -1) {
      Navigator.pushReplacementNamed(
        context,
        Pages.chat,
        arguments: ChatArgs(_rooms[idx]),
      );
    } else if (!_isCreating) {
      _isCreating = true;
      _presenter.onCreateRoom(
          CreateRoomApiRequest(
              "private-${_userData.name.firstWord(" ").toLowerCase()}-${user.fullName!.firstWord(" ").toLowerCase()}",
              "Private chat between ${_userData.name} and ${user.fullName}",
              [_userData.id, user.id]),
          user);
    }
  }

  void onSelectUser(int index, bool? selected) {
    bool isSelected = selected ?? false;

    if (isSelected) {
      _selectedUsers.add(_users[index]);
    } else {
      _selectedUsers.remove(_users[index]);
    }

    refreshUI();
  }

  void onSetAsCreateGroup(bool isCreateGroup) {
    _isCreateGroup = isCreateGroup;
    refreshUI();
  }

  @override
  void initListeners() {
    _presenter.getUsersOnNext = (List<User> users, PersistenceType type) {
      print("user list: success getUsers $type");
      if (_isSearch || _initialLoad) {
        users.sort((a, b) =>
            a.fullName!.toLowerCase().compareTo(b.fullName!.toLowerCase()));
        _users.clear();
        _users.addAll(users);
      }
      if (_initialLoad) {
        _fUsers.addAll(users);
      }
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("user list: completed getUsers $type");
      loading(false);

      // save to db
      if (_initialLoad) {
        _users.forEach((u) {
          _presenter.onCreateUser(CreateUserDBRequest(u));
        });
      }
      _initialLoad = false;
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      print("user list: error getUsers $e $type");
    };

    _presenter.createRoomOnNext =
        (BaseApiResponse resp, PersistenceType type, User user) {
      printd("user list: success createRoom $type");

      // get room details
      _presenter.onGetRooms(
          GetRoomsApiRequest(ids: [resp.result], limit: 1), user);
    };

    _presenter.createRoomOnComplete = (PersistenceType type) {
      print("user list: completed createRoom $type");
    };

    _presenter.createRoomOnError = (e, PersistenceType type) {
      print("user list: error createRoom $e $type");
    };

    _presenter.getRoomsOnNext =
        (List<Room> rooms, PersistenceType type, User user) {
      printd("user list: success getRooms $type");
      Room room = rooms.first;
      room.participants = [_userData.toUser(), user];
      Navigator.pushReplacementNamed(
        context,
        Pages.chat,
        arguments: ChatArgs(room),
      );
      _isCreating = false;
    };

    _presenter.getRoomsOnComplete = (PersistenceType type) {
      print("user list: completed getRooms $type");
    };

    _presenter.getRoomsOnError = (e, PersistenceType type) {
      print("user list: error getRooms $e $type");
    };

    _presenter.createUserOnNext = (bool result, PersistenceType type) {
      print("user list: success createUser $type");
    };

    _presenter.createUserOnComplete = (PersistenceType type) {
      print("user list: completed createUser $type");
    };

    _presenter.createUserOnError = (e, PersistenceType type) {
      print("user list: error createUser $e $type");
    };
  }

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
  }
}
