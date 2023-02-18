import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_calendar_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_calendar.dart';

class RoomCalendarPresenter extends Presenter {
  GetLobbyRoomCalendarUseCase _calendarUseCase;

  RoomCalendarPresenter(this._calendarUseCase);

  // calendar
  late Function getLobbyRoomCalendarOnNext;
  late Function getLobbyRoomCalendarOnComplete;
  late Function getLobbyRoomCalendarOnError;

  void onGetLobbyRoomCalendar(GetLobbyRoomCalendarRequestInterface req) {
    if (req is GetLobbyRoomCalendarApiRequest) {
      _calendarUseCase.execute(_GetLobbyRoomCalendarObserver(this, PersistenceType.api), req);
    }
  }

  @override
  void dispose() {
    _calendarUseCase.dispose();
  }
}

class _GetLobbyRoomCalendarObserver implements Observer<List<Calendar>> {
  RoomCalendarPresenter _presenter;
  PersistenceType _type;

  _GetLobbyRoomCalendarObserver(this._presenter, this._type);

  void onNext(List<Calendar>? calendar) {
    _presenter.getLobbyRoomCalendarOnNext(calendar, _type);
  }

  void onComplete() {
    _presenter.getLobbyRoomCalendarOnComplete(_type);
  }

  void onError(e) {
    _presenter.getLobbyRoomCalendarOnError(e, _type);
  }
}
