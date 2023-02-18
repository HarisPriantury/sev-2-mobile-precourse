import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/calendar/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/calendar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_calendar_api_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/room.dart';

class RoomCalendarController extends BaseController {
  RoomCalendarPresenter _presenter;
  late Room _room;

  List<Calendar> _calendars = [];

  RoomCalendarController(this._presenter);

  Room get room => _room;

  List<Calendar> get calendars => _calendars;

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      var _data = args as RoomCalendarArgs;
      _room = _data.room;
      print(_data.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.getLobbyRoomCalendarOnNext =
        (List<Calendar> calendars, PersistenceType type) {
      print("roomCalendar: success getLobbyRoomCalendar $type");
      _calendars.clear();
      _calendars.addAll(calendars);
    };

    _presenter.getLobbyRoomCalendarOnComplete = (PersistenceType type) {
      print("roomCalendar: completed getLobbyRoomCalendar $type");
      loading(false);
    };

    _presenter.getLobbyRoomCalendarOnError = (e, PersistenceType type) {
      print("roomCalendar: error getLobbyRoomCalendar $e $type");
      loading(false);
    };
  }

  @override
  void load() {
    loading(true);
    _presenter.onGetLobbyRoomCalendar(GetLobbyRoomCalendarApiRequest(_room.id));
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    _presenter.onGetLobbyRoomCalendar(GetLobbyRoomCalendarApiRequest(_room.id));
    reloading(true);
    await Future.delayed(Duration(seconds: 1));
  }

  void onAddCalendar() {
    Navigator.pushNamed(context, Pages.create,
            arguments: CreateArgs(type: Calendar, room: _room))
        .then((value) => load());
  }

  void onItemClicked(PhObject object) {
    // Navigator.pushNamed(context, Pages.detail, arguments: DetailArgs(object))
    //     .then((value) => load());
    Navigator.pushNamed(
      context,
      Pages.eventDetail,
      arguments: DetailEventArgs(phid: object.id),
    ).then(
      (value) => load(),
    );
  }
}
