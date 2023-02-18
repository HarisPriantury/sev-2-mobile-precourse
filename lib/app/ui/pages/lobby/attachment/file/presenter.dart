import 'package:file_picker/file_picker.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_files_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/use_cases/file/create_file.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/file/prepare_create_file.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_files.dart';

class RoomFilePresenter extends Presenter {
  GetLobbyRoomFilesUseCase _fileUseCase;
  CreateFileUseCase _uploadUseCase;
  PrepareCreateFileUseCase _prepareUploadUseCase;
  GetFilesUseCase _getFilesUseCase;

  RoomFilePresenter(
    this._fileUseCase,
    this._uploadUseCase,
    this._prepareUploadUseCase,
    this._getFilesUseCase,
  );

  // files
  late Function getLobbyRoomFilesOnNext;
  late Function getLobbyRoomFilesOnComplete;
  late Function getLobbyRoomFilesOnError;

  // upload file
  late Function uploadFileOnNext;
  late Function uploadFileOnComplete;
  late Function uploadFileOnError;

  // prepare for upload
  late Function prepareFileUploadOnNext;
  late Function prepareFileUploadOnComplete;
  late Function prepareFileUploadOnError;

  // get attachment
  late Function getFilesOnNext;
  late Function getFilesOnComplete;
  late Function getFilesOnError;

  void onGetLobbyRoomFiles(GetLobbyRoomFilesRequestInterface req) {
    if (req is GetLobbyRoomFilesApiRequest) {
      _fileUseCase.execute(
          _GetLobbyRoomFilesObserver(this, PersistenceType.api), req);
    }
  }

  void onUploadFile(CreateFileRequestInterface req) {
    _uploadUseCase.execute(_UploadFileObserver(this, PersistenceType.api), req);
  }

  void onPrepareUploadFile(
      PrepareCreateFileRequestInterface req, PlatformFile file) {
    _prepareUploadUseCase.execute(
        _PrepareFileUploadObserver(this, PersistenceType.api, file), req);
  }

  void onGetFiles(GetFilesRequestInterface req) {
    _getFilesUseCase.execute(_GetFilesObserver(this, PersistenceType.api), req);
  }

  @override
  void dispose() {
    _fileUseCase.dispose();
    _uploadUseCase.dispose();
    _prepareUploadUseCase.dispose();
    _getFilesUseCase.dispose();
  }
}

class _GetLobbyRoomFilesObserver implements Observer<List<File>> {
  RoomFilePresenter _presenter;
  PersistenceType _type;

  _GetLobbyRoomFilesObserver(this._presenter, this._type);

  void onNext(List<File>? files) {
    _presenter.getLobbyRoomFilesOnNext(files, _type);
  }

  void onComplete() {
    _presenter.getLobbyRoomFilesOnComplete(_type);
  }

  void onError(e) {
    _presenter.getLobbyRoomFilesOnError(e, _type);
  }
}

class _UploadFileObserver implements Observer<BaseApiResponse> {
  RoomFilePresenter _presenter;
  PersistenceType _type;

  _UploadFileObserver(this._presenter, this._type);

  void onNext(BaseApiResponse? result) {
    _presenter.uploadFileOnNext(result, _type);
  }

  void onComplete() {
    _presenter.uploadFileOnComplete(_type);
  }

  void onError(e) {
    _presenter.uploadFileOnError(e, _type);
  }
}

class _PrepareFileUploadObserver implements Observer<bool> {
  RoomFilePresenter _presenter;
  PersistenceType _type;
  PlatformFile _file;

  _PrepareFileUploadObserver(this._presenter, this._type, this._file);

  void onNext(bool? result) {
    _presenter.prepareFileUploadOnNext(result, _file, _type);
  }

  void onComplete() {
    _presenter.prepareFileUploadOnComplete(_type);
  }

  void onError(e) {
    _presenter.prepareFileUploadOnError(e, _type);
  }
}

class _GetFilesObserver implements Observer<List<File>> {
  RoomFilePresenter _presenter;
  PersistenceType _ptype;

  _GetFilesObserver(this._presenter, this._ptype);

  void onNext(List<File>? files) {
    _presenter.getFilesOnNext(files, _ptype);
  }

  void onComplete() {
    _presenter.getFilesOnComplete(_ptype);
  }

  void onError(e) {
    _presenter.getFilesOnError(e);
  }
}
