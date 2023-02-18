import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/room/create_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/room/create_room.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_rooms.dart';

class CreateRoomPresenter extends Presenter {
  CreateRoomUseCase _createUseCase;
  CreateRoomUseCase _createDbUseCase;
  GetRoomsUseCase _roomsUseCase;
  GetRoomsUseCase _roomsDbUseCase;
  GetRoomParticipantsUseCase _roomParticipantsUseCase;

  // create room
  late Function createRoomOnNext;
  late Function createRoomOnComplete;
  late Function createRoomOnError;

  // get rooms
  late Function getRoomsOnNext;
  late Function getRoomsOnComplete;
  late Function getRoomsOnError;

  // get participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  CreateRoomPresenter(
    this._createUseCase,
    this._createDbUseCase,
    this._roomsUseCase,
    this._roomsDbUseCase,
    this._roomParticipantsUseCase,
  );

  void onCreateRoom(CreateRoomRequestInterface req) {
    if (req is CreateRoomApiRequest) {
      _createUseCase.execute(
          _CreateRoomObserver(this, PersistenceType.api), req);
    } else {
      _createDbUseCase.execute(
          _CreateRoomObserver(this, PersistenceType.db), req);
    }
  }

  void onGetRooms(GetRoomsRequestInterface req) {
    if (req is GetRoomsApiRequest) {
      _roomsUseCase.execute(_GetRoomsObserver(this, PersistenceType.api), req);
    } else {
      _roomsDbUseCase.execute(_GetRoomsObserver(this, PersistenceType.db), req);
    }
  }

  void onGetParticipants(GetParticipantsRequestInterface req) {
    _roomParticipantsUseCase.execute(_GetParticipantsObserver(this, PersistenceType.api), req);
  }

  void dispose() {
    _createUseCase.dispose();
    _roomsUseCase.dispose();
    _createDbUseCase.dispose();
    _roomsDbUseCase.dispose();
  }
}

class _CreateRoomObserver implements Observer<BaseApiResponse> {
  CreateRoomPresenter _presenter;
  PersistenceType _type;

  _CreateRoomObserver(this._presenter, this._type);

  void onNext(BaseApiResponse? result) {
    _presenter.createRoomOnNext(result, _type);
  }

  void onComplete() {
    _presenter.createRoomOnComplete(_type);
  }

  void onError(e) {
    _presenter.createRoomOnError(e, _type);
  }
}

class _GetRoomsObserver implements Observer<List<Room>> {
  CreateRoomPresenter _presenter;
  PersistenceType _type;

  _GetRoomsObserver(this._presenter, this._type);

  void onNext(List<Room>? rooms) {
    _presenter.getRoomsOnNext(rooms, _type);
  }

  void onComplete() {
    _presenter.getRoomsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getRoomsOnError(e, _type);
  }
}

class _GetParticipantsObserver implements Observer<List<User>> {
  CreateRoomPresenter _presenter;
  PersistenceType _type;

  _GetParticipantsObserver(this._presenter, this._type);

  void onNext(List<User>? users) {
    _presenter.getParticipantsOnNext(users, _type);
  }

  void onComplete() {
    _presenter.getParticipantsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getParticipantsOnError(e, _type);
  }
}
