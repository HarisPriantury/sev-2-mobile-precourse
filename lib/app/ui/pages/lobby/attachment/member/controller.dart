import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/member/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/add_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

class RoomMemberController extends BaseController {
  RoomMemberPresenter _presenter;
  late Room _room;
  List<User> _participants = [];
  List<User> _lobbyParticipants = [];

  RoomMemberController(this._presenter);

  Room get room => _room;

  List<User> get participants => _participants;

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      var _data = args as RoomMemberArgs;
      _room = _data.room;
      if (_room.participants != null) _participants = _room.participants!;
      print(_data.toPrint());
    }
  }

  @override
  void initListeners() {
    // get lobby participants
    _presenter.getLobbyParticipantsOnNext =
        (List<User> users, PersistenceType type) {
      printd("member: success getLobbyParticipants $type");
      _lobbyParticipants.clear();
      _lobbyParticipants.addAll(users);
    };

    _presenter.getLobbyParticipantsOnComplete = (PersistenceType type) {
      print("member: completed getLobbyParticipants $type");
      _presenter.onGetParticipants(GetParticipantsApiRequest(_room.id));
    };

    _presenter.getLobbyParticipantsOnError = (e, PersistenceType type) {
      print("member: error getLobbyParticipants $e $type");
    };
    // get participants
    _presenter.getParticipantsOnNext =
        (List<User> users, PersistenceType type) {
      printd("roomMember: success getParticipants");
      _participants.clear();
      users.forEach((user) {
        var idx = _lobbyParticipants
            .indexWhere((lobbyUser) => lobbyUser.id == user.id);
        if (idx > -1)
          _participants.add(_lobbyParticipants[idx]);
        else
          _participants.add(user);
      });
    };

    _presenter.getParticipantsOnComplete = (PersistenceType type) {
      print("roomMember: completed getParticipants");
      loading(false);
    };

    _presenter.getParticipantsOnError = (e, PersistenceType type) {
      print("roomMember: error getParticipants $e");
    };

    _presenter.addParticipantsOnNext = (bool, PersistenceType type) {
      print("roomMember: success addParticipants");
    };

    _presenter.addParticipantsOnComplete = (PersistenceType type) {
      print("roomMember: completed addParticipants");
      load();
    };

    _presenter.addParticipantsOnError = (e, PersistenceType type) {
      print("roomMember: error addParticipants $e");
    };
  }

  @override
  void load() {
    loading(true);
    _presenter.onGetLobbyParticipants(GetLobbyParticipantsApiRequest());
  }

  void onAddMember() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        "user",
        title: S.of(context).create_form_search_user_label,
        placeholderText: S.of(context).create_form_search_user_select,
      ),
    );
    if (result != null) {
      loading(true);
      var selectedUsers = result as List<PhObject>;
      selectedUsers.forEach((se) {
        var idx = _participants.indexWhere((e) => e.id == se.id);
        if (idx < 0) {
          _participants.add(User(se.id,
              name: se.name, fullName: se.fullName, avatar: se.avatar));
        }
      });

      _presenter.onAddParticipants(AddParticipantsApiRequest(
          _room.id, selectedUsers.map((e) => e.id).toList()));
    }
  }

  void goToProfile(User user) {
    Navigator.pushNamed(context, Pages.profile,
        arguments: ProfileArgs(user: user));
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    reloading(true);
    _presenter.onGetLobbyParticipants(GetLobbyParticipantsApiRequest());
    await Future.delayed(Duration(seconds: 1));
  }
}
