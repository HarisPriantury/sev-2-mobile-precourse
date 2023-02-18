import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_participants.dart';
import 'package:mobile_sev2/use_cases/room/add_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';

class RoomMemberPresenter extends Presenter {
  GetLobbyParticipantsUseCase _lobbyParticipantsUseCase;
  GetRoomParticipantsUseCase _participantsUseCase;
  AddRoomParticipantsUseCase _addParticipantsUseCase;

  // get lobby participants
  late Function getLobbyParticipantsOnNext;
  late Function getLobbyParticipantsOnComplete;
  late Function getLobbyParticipantsOnError;

  // get participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  // add participant
  late Function addParticipantsOnNext;
  late Function addParticipantsOnComplete;
  late Function addParticipantsOnError;

  RoomMemberPresenter(
    this._lobbyParticipantsUseCase,
    this._participantsUseCase,
    this._addParticipantsUseCase,
  );

  void onGetLobbyParticipants(GetLobbyParticipantsRequestInterface req) {
    if (req is GetLobbyParticipantsApiRequest) {
      _lobbyParticipantsUseCase.execute(_GetLobbyParticipantsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetParticipants(GetParticipantsRequestInterface req) {
    _participantsUseCase.execute(_GetParticipantsObserver(this, PersistenceType.api), req);
  }

  void onAddParticipants(AddParticipantsRequestInterface req) {
    _addParticipantsUseCase.execute(_AddParticipantsObserver(this, PersistenceType.api), req);
  }

  @override
  void dispose() {
    _lobbyParticipantsUseCase.dispose();
    _participantsUseCase.dispose();
    _addParticipantsUseCase.dispose();
  }
}

class _GetLobbyParticipantsObserver implements Observer<List<User>> {
  RoomMemberPresenter _presenter;
  PersistenceType _type;

  _GetLobbyParticipantsObserver(this._presenter, this._type);

  void onNext(List<User>? users) {
    _presenter.getLobbyParticipantsOnNext(users, _type);
  }

  void onComplete() {
    _presenter.getLobbyParticipantsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getLobbyParticipantsOnError(e, _type);
  }
}

class _GetParticipantsObserver implements Observer<List<User>> {
  RoomMemberPresenter _presenter;
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

class _AddParticipantsObserver implements Observer<bool> {
  RoomMemberPresenter _presenter;
  PersistenceType _type;

  _AddParticipantsObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.addParticipantsOnNext(result, _type);
  }

  void onComplete() {
    _presenter.addParticipantsOnComplete(_type);
  }

  void onError(e) {
    _presenter.addParticipantsOnError(e, _type);
  }
}
