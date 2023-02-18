import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/member/args.dart';
import 'package:mobile_sev2/app/ui/pages/member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/update_status_api_request.dart';
import 'package:mobile_sev2/domain/user.dart';

class MemberController extends BaseController {
  late MemberArgs _data;
  MemberPresenter _presenter;

  List<User> _inLobbyUsers = [];
  List<User> _breakUsers = [];
  List<User> _inChannelUsers = [];
  List<User> _unavailableUsers = [];

  int _limit = 100;

  // get
  MemberArgs get data => _data;

  List<User> get inLobbyUsers => _inLobbyUsers;

  List<User> get breakUsers => _breakUsers;

  List<User> get inChannelUsers => _inChannelUsers;

  List<User> get unavailableUsers => _unavailableUsers;

  MemberController(this._presenter);

  @override
  void getArgs() {
    if (args != null) _data = args as MemberArgs;
    print(_data.toPrint());
  }

  void _reload({String? after}) {
    // get active users
    _presenter.onGetLobbyParticipants(
      GetLobbyParticipantsApiRequest(
        after: after,
        queryKey: GetLobbyParticipantsApiRequest.QUERY_ALL,
      ),
    );
  }

  void _mapUsers(List<User> users) {
    users.forEach((u) {
      if (u.status == UpdateStatusApiRequest.STATUS_IN_LOBBY &&
          u.isWorking == false) {
        _unavailableUsers.add(u);
      } else if (u.status == UpdateStatusApiRequest.STATUS_IN_CHANNEL) {
        _inChannelUsers.add(u);
      } else if (u.status == UpdateStatusApiRequest.STATUS_IN_LOBBY) {
        _inLobbyUsers.add(u);
      } else {
        _breakUsers.add(u);
      }
    });
  }

  @override
  void initListeners() {
    _presenter.getLobbyParticipantsOnNext =
        (List<User> users, PersistenceType type) {
      printd("member: success getLobbyParticipants $type");
      if (users.length == _limit) {
        print("after id: ${users.last.intId}");
        _reload(after: users.last.intId.toString());
      } else {
        loading(false);
      }
      _mapUsers(users);
    };

    _presenter.getLobbyParticipantsOnComplete = (PersistenceType type) {
      print("member: completed getLobbyParticipants $type");
    };

    _presenter.getLobbyParticipantsOnError = (e, PersistenceType type) {
      print("member: error getLobbyParticipants $e $type");
      loading(false);
    };
  }

  @override
  void load() {
    loading(true);
    _reload();
    // _mapUsers(_data.users);
    // refreshUI();
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    _inLobbyUsers.clear();
    _inChannelUsers.clear();
    _breakUsers.clear();
    _unavailableUsers.clear();
    _reload();
    delay(() => refreshUI(), period: 3);
  }

  void goToProfile(User user) {
    Navigator.pushNamed(context, Pages.profile,
        arguments: ProfileArgs(user: user));
  }
}
