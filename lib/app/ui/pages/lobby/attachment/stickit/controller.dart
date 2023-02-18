import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_stickit/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/stickit/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/stickit/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_stickits_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/set_as_read_stickit_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';

class RoomStickitController extends BaseController {
  RoomStickitPresenter _presenter;
  late Room _room;
  bool isRead = false;
  List<String> _readable = [];
  UserData _userData;

  List<Stickit> _praise = [];
  List<Stickit> _mom = [];
  List<Stickit> _memo = [];
  List<Stickit> _pitch = [];

  RoomStickitController(
    this._presenter,
    this._userData,
  );

  Room get room => _room;

  List<Stickit> get praise => _praise;

  List<Stickit> get mom => _mom;

  List<Stickit> get memo => _memo;

  List<Stickit> get pitch => _pitch;

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      var _data = args as RoomStickitArgs;
      _room = _data.room;
      print(_data.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.getLobbyRoomStickitsOnNext =
        (List<Stickit> stickits, PersistenceType type) {
      print("voice: success getLobbyRoomStickits $type");
      _praise.clear();
      _mom.clear();
      _memo.clear();
      _pitch.clear();

      stickits.forEach((element) {
        element.spectators!.forEach((spectator) {
          if (spectator.id == _userData.id) {
            _readable.addAll([element.id]);
          }
        });
      });
      stickits.forEach((st) {
        switch (st.stickitType) {
          case Stickit.TYPE_MEMO:
            _memo.add(st);
            break;
          case Stickit.TYPE_MOM:
            _mom.add(st);
            break;
          case Stickit.TYPE_PITCH:
            _pitch.add(st);
            break;
          case Stickit.TYPE_PRAISE:
            _praise.add(st);
            break;
          default:
        }
      });
    };

    _presenter.getLobbyRoomStickitsOnComplete = (PersistenceType type) {
      print("voice: completed getLobbyRoomStickits $type");
      loading(false);
    };

    _presenter.getLobbyRoomStickitsOnError = (e, PersistenceType type) {
      print("voice: error getLobbyRoomStickits $e $type");
      loading(false);
    };
    _presenter.setAsReadStickitOnNext = (bool result) {
      print("setAsRead: success setAsReadStickit");
    };

    _presenter.setAsReadStickitOnComplete = () {
      print("setAsRead: completed setAsReadStickit");
    };

    _presenter.setAsReadStickitOnError = (e) {
      print("setAsRead: error.setAsReadStickit: $e");
    };
  }

  @override
  void load() {
    loading(true);
    _presenter.onGetLobbyRoomStickits(GetLobbyRoomStickitsApiRequest(_room.id));
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    _presenter.onGetLobbyRoomStickits(GetLobbyRoomStickitsApiRequest(_room.id));
    reloading(true);
    await Future.delayed(Duration(seconds: 1));
  }

  void onAddStickit() {
    Navigator.pushNamed(context, Pages.create,
            arguments: CreateArgs(type: Stickit, room: _room))
        .then((value) => load());
  }

  void onItemClicked(PhObject object) {
    _presenter.onSetAsReadStickit(SetAsReadStickitApiRequest(object.id));
    Navigator.pushNamed(
      context,
      Pages.stickitDetail,
      arguments: DetailStickitArgs(phid: object.id),
    ).then(
      (value) => load(),
    );
  }

  bool checkIsRead(Stickit stickit) {
    if (_readable.contains(stickit.id)) {
      return true;
    } else {
      return false;
    }
  }
}
