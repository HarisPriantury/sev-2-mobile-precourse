import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/room/add_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/room/remove_participants.dart';

class RoomDetailPresenter extends Presenter {
  GetRoomParticipantsUseCase _participantsUseCase;
  GetRoomParticipantsUseCase _participantsDbUseCase;
  AddRoomParticipantsUseCase _addParticipantsUseCase;
  AddRoomParticipantsUseCase _addParticipantsDbUseCase;
  RemoveRoomParticipantsUseCase _removeParticipantsUseCase;
  RemoveRoomParticipantsUseCase _removeParticipantsDbUseCase;
  GetFilesUseCase _getFilesUseCase;
  GetFilesUseCase _getFilesDbUseCase;

  // get participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  // add participants
  late Function addParticipantsOnNext;
  late Function addParticipantsOnComplete;
  late Function addParticipantsOnError;

  // remove participants
  late Function removeParticipantsOnNext;
  late Function removeParticipantsOnComplete;
  late Function removeParticipantsOnError;

  // get files
  late Function getFilesOnNext;
  late Function getFilesOnComplete;
  late Function getFilesOnError;

  RoomDetailPresenter(
      this._participantsUseCase,
      this._participantsDbUseCase,
      this._addParticipantsUseCase,
      this._addParticipantsDbUseCase,
      this._removeParticipantsUseCase,
      this._removeParticipantsDbUseCase,
      this._getFilesUseCase,
      this._getFilesDbUseCase);

  void onGetParticipants(GetParticipantsRequestInterface req) {
    _participantsUseCase.execute(_GetParticipantsObserver(this), req);
  }

  void onAddParticipants(AddParticipantsRequestInterface req) {
    _addParticipantsUseCase.execute(_AddParticipantsObserver(this), req);
  }

  void onRemoveParticipants(RemoveParticipantsRequestInterface req) {
    _removeParticipantsUseCase.execute(_RemoveParticipantsObserver(this), req);
  }

  void onGetFiles(GetFilesRequestInterface req) {
    if (req is GetFilesApiRequest) {
      _getFilesUseCase.execute(_GetFilesObserver(this, PersistenceType.api), req);
    } else {
      _getFilesDbUseCase.execute(_GetFilesObserver(this, PersistenceType.db), req);
    }
  }

  void dispose() {
    _participantsUseCase.dispose();
    _participantsDbUseCase.dispose();
    _addParticipantsUseCase.dispose();
    _addParticipantsDbUseCase.dispose();
    _removeParticipantsUseCase.dispose();
    _removeParticipantsDbUseCase.dispose();
    _getFilesUseCase.dispose();
    _getFilesDbUseCase.dispose();
  }
}

class _GetParticipantsObserver implements Observer<List<User>> {
  RoomDetailPresenter _presenter;

  _GetParticipantsObserver(this._presenter);

  void onNext(List<User>? participants) {
    _presenter.getParticipantsOnNext(participants);
  }

  void onComplete() {
    _presenter.getParticipantsOnComplete();
  }

  void onError(e) {
    _presenter.getParticipantsOnError(e);
  }
}

class _AddParticipantsObserver implements Observer<bool> {
  RoomDetailPresenter _presenter;

  _AddParticipantsObserver(this._presenter);

  void onNext(bool? result) {
    _presenter.addParticipantsOnNext(result);
  }

  void onComplete() {
    _presenter.addParticipantsOnComplete();
  }

  void onError(e) {
    _presenter.addParticipantsOnError(e);
  }
}

class _RemoveParticipantsObserver implements Observer<bool> {
  RoomDetailPresenter _presenter;

  _RemoveParticipantsObserver(this._presenter);

  void onNext(bool? result) {
    _presenter.removeParticipantsOnNext(result);
  }

  void onComplete() {
    _presenter.removeParticipantsOnComplete();
  }

  void onError(e) {
    _presenter.removeParticipantsOnError(e);
  }
}

class _GetFilesObserver implements Observer<List<File>> {
  RoomDetailPresenter _presenter;
  PersistenceType _type;

  _GetFilesObserver(this._presenter, this._type);

  void onNext(List<File>? result) {
    _presenter.getFilesOnNext(result, _type);
  }

  void onComplete() {
    _presenter.getFilesOnComplete(_type);
  }

  void onError(e) {
    _presenter.getFilesOnError(e, _type);
  }
}
