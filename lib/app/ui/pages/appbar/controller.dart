import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/appbar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/member/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/update_status_api_request.dart';
import 'package:mobile_sev2/domain/user.dart';

class AppbarController extends BaseController {
  AppbarPresenter _presenter;
  UserData _userData;

  AppbarController(this._presenter, this._userData);

  // available & unavailable user
  List<User> _availableUsers = [];
  List<User> _unavailableUsers = [];
  List<User> _users = [];

  UserData get userData => _userData;

  List<User> get availableUsers => _availableUsers;

  List<User> get unavailableUsers => _unavailableUsers;

  @override
  void load() {
    // get active users
    _presenter.onGetLobbyParticipants(GetLobbyParticipantsApiRequest(
        queryKey: GetLobbyParticipantsApiRequest.QUERY_IN_LOBBY));
    _presenter.onGetLobbyParticipants(GetLobbyParticipantsApiRequest(
        queryKey: GetLobbyParticipantsApiRequest.QUERY_WORKING));

    // inactive users
    _presenter.onGetLobbyParticipants(GetLobbyParticipantsApiRequest(
        queryKey: GetLobbyParticipantsApiRequest.QUERY_UNAVAILABLE));
    _presenter.onGetLobbyParticipants(GetLobbyParticipantsApiRequest(
        queryKey: GetLobbyParticipantsApiRequest.QUERY_BREAK));
  }

  void goToNotification() {
    Navigator.pushNamed(context, Pages.notifications);
  }

  void goToMember() {
    Navigator.pushNamed(context, Pages.member,
        arguments: MemberArgs(_userData.workspace));
  }

  void goToWorkspaceList() {
    Navigator.pushNamed(context, Pages.workspaceList);
  }

  @override
  void getArgs() {}

  @override
  void initListeners() {
    _presenter.getLobbyParticipantsOnNext =
        (List<User> users, PersistenceType type) {
      print("appbar: success getLobbyParticipants $type");

      _users.addAll(users);

      users.forEach((u) {
        if ((u.status == UpdateStatusApiRequest.STATUS_IN_LOBBY ||
                u.status == UpdateStatusApiRequest.STATUS_IN_CHANNEL) &&
            u.isWorking == true) {
          _availableUsers.add(u);
        } else {
          _unavailableUsers.add(u);
        }
      });
    };

    _presenter.getLobbyParticipantsOnComplete = (PersistenceType type) {
      print("appbar: completed getLobbyParticipants $type");
      refreshUI();
    };

    _presenter.getLobbyParticipantsOnError = (e, PersistenceType type) {
      loading(false);
      print("appbar: error getLobbyParticipants $e $type");
    };
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
