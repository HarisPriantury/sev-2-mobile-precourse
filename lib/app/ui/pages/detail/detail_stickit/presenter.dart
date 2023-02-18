import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_stickit_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/stickit/get_stickit_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/stickit_request_interface.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/use_cases/file/create_file.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/file/prepare_create_file.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_stickits.dart';
import 'package:mobile_sev2/use_cases/phobject/get_object_transactions.dart';
import 'package:mobile_sev2/use_cases/phobject/get_objects.dart';
import 'package:mobile_sev2/use_cases/reaction/get_object_reactions.dart';
import 'package:mobile_sev2/use_cases/reaction/give_reaction.dart';
import 'package:mobile_sev2/use_cases/stickit/get_stickit.dart';

class DetailStickitPresenter extends Presenter {
  GetStickitsUseCase _stickitsUseCase;
  GetObjectTransactionsUseCase _transactionsUseCase;
  GetObjectsUseCase _objectUseCase;
  GetObjectReactionsUseCase _getObjectReactionsUseCase;
  GiveReactionUseCase _giveReactionUseCase;
  CreateLobbyRoomStickitUseCase _createStickitUseCase;
  CreateFileUseCase _uploadUseCase;
  PrepareCreateFileUseCase _prepareUploadUseCase;
  GetFilesUseCase _getFilesUseCase;
  GetFilesUseCase _getFilesDbUseCase;

  // get stickits
  late Function getStickitsOnNext;
  late Function getStickitsOnComplete;
  late Function getStickitsOnError;

  // get transactions
  late Function getTransactionsOnNext;
  late Function getTransactionsOnComplete;
  late Function getTransactionsOnError;

  // get object
  late Function getObjectsOnNext;
  late Function getObjectsOnComplete;
  late Function getObjectsOnError;

  // get object reaction
  late Function getObjectReactionOnNext;
  late Function getObjectReactionOnComplete;
  late Function getObjectReactionOnError;

  // send reaction
  late Function sendReactionOnNext;
  late Function sendReactionOnComplete;
  late Function sendReactionOnError;

  late Function stickitTransactionOnNext;
  late Function stickitTransactionOnComplete;
  late Function stickitTransactionOnError;

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

  DetailStickitPresenter(
    this._stickitsUseCase,
    this._transactionsUseCase,
    this._objectUseCase,
    this._getObjectReactionsUseCase,
    this._giveReactionUseCase,
    this._createStickitUseCase,
    this._uploadUseCase,
    this._prepareUploadUseCase,
    this._getFilesUseCase,
    this._getFilesDbUseCase,
  );

  void onGetStickit(GetStickitRequestInterface req) {
    if (req is GetStickitsApiRequest) {
      _stickitsUseCase.execute(
          _GetStickitsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetTransactions(GetObjectTransactionsRequestInterface req) {
    if (req is GetObjectTransactionsApiRequest) {
      _transactionsUseCase.execute(
          _GetTransactionsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetObjects(GetObjectsRequestInterface req) {
    if (req is GetObjectsApiRequest) {
      _objectUseCase.execute(
          _GetObjectsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetObjectReactions(GetObjectReactionsRequestInterface req) {
    if (req is GetObjectReactionsApiRequest) {
      _getObjectReactionsUseCase.execute(
          _GetObjectReactionsObserver(this), req);
    }
  }

  void onSendReaction(GiveReactionRequestInterface req) {
    if (req is GiveReactionApiRequest) {
      _giveReactionUseCase.execute(
          _GiveReactionObserver(this, PersistenceType.api), req);
    }
  }

  void onStickitTransaction(CreateLobbyRoomStickitRequestInterface req) {
    if (req is CreateLobbyRoomStickitApiRequest) {
      _createStickitUseCase.execute(
          _StickitTransactionObserver(this, PersistenceType.api), req);
    }
  }

  void onUploadFile(CreateFileRequestInterface req) {
    _uploadUseCase.execute(_UploadFileObserver(this, PersistenceType.api), req);
  }

  void onPrepareUploadFile(PrepareCreateFileRequestInterface req) {
    _prepareUploadUseCase.execute(
        _PrepareFileUploadObserver(this, PersistenceType.api), req);
  }

  void onGetFiles(GetFilesRequestInterface req, String type) {
    if (req is GetFilesApiRequest) {
      _getFilesUseCase.execute(
          _GetFilesObserver(this, PersistenceType.api, type), req);
    } else {
      _getFilesDbUseCase.execute(
          _GetFilesObserver(this, PersistenceType.db, type), req);
    }
  }

  @override
  void dispose() {
    _stickitsUseCase.dispose();
    _transactionsUseCase.dispose();
    _objectUseCase.dispose();
    _getObjectReactionsUseCase.dispose();
    _uploadUseCase.dispose();
    _prepareUploadUseCase.dispose();
    _getFilesUseCase.dispose();
  }
}

class _GetStickitsObserver implements Observer<List<Stickit>> {
  DetailStickitPresenter _presenter;
  PersistenceType _type;

  _GetStickitsObserver(this._presenter, this._type);

  void onNext(List<Stickit>? stickits) {
    _presenter.getStickitsOnNext(stickits, _type);
  }

  void onComplete() {
    _presenter.getStickitsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getStickitsOnError(e, _type);
  }
}

class _GetTransactionsObserver implements Observer<List<PhTransaction>> {
  DetailStickitPresenter _presenter;
  PersistenceType _type;

  _GetTransactionsObserver(this._presenter, this._type);

  void onNext(List<PhTransaction>? users) {
    _presenter.getTransactionsOnNext(users, _type);
  }

  void onComplete() {
    _presenter.getTransactionsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTransactionsOnError(e, _type);
  }
}

class _GetObjectsObserver implements Observer<List<PhObject>> {
  DetailStickitPresenter _presenter;
  PersistenceType _type;

  _GetObjectsObserver(this._presenter, this._type);

  void onNext(List<PhObject>? objects) {
    _presenter.getObjectsOnNext(objects, _type);
  }

  void onComplete() {
    _presenter.getObjectsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getObjectsOnError(e, _type);
  }
}

class _GetObjectReactionsObserver implements Observer<List<ObjectReactions>> {
  DetailStickitPresenter _presenter;

  _GetObjectReactionsObserver(this._presenter);

  void onNext(List<ObjectReactions>? result) {
    _presenter.getObjectReactionOnNext(result);
  }

  void onComplete() {
    _presenter.getObjectReactionOnComplete();
  }

  void onError(e) {
    _presenter.getObjectReactionOnError(e);
  }
}

class _GiveReactionObserver implements Observer<bool> {
  DetailStickitPresenter _presenter;
  PersistenceType _type;

  _GiveReactionObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.sendReactionOnNext(result, _type);
  }

  void onComplete() {
    _presenter.sendReactionOnComplete(_type);
  }

  void onError(e) {
    _presenter.sendReactionOnError(e, _type);
  }
}

class _StickitTransactionObserver implements Observer<bool> {
  DetailStickitPresenter _presenter;
  PersistenceType _type;

  _StickitTransactionObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.stickitTransactionOnNext(result, _type);
  }

  void onComplete() {
    _presenter.stickitTransactionOnComplete(_type);
  }

  void onError(e) {
    _presenter.stickitTransactionOnError(e, _type);
  }
}

class _UploadFileObserver implements Observer<BaseApiResponse> {
  DetailStickitPresenter _presenter;
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
  DetailStickitPresenter _presenter;
  PersistenceType _type;

  _PrepareFileUploadObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.prepareFileUploadOnNext(result, _type);
  }

  void onComplete() {
    _presenter.prepareFileUploadOnComplete(_type);
  }

  void onError(e) {
    _presenter.prepareFileUploadOnError(e, _type);
  }
}

class _GetFilesObserver implements Observer<List<File>> {
  DetailStickitPresenter _presenter;
  PersistenceType _ptype;
  String _type;

  _GetFilesObserver(this._presenter, this._ptype, this._type);

  void onNext(List<File>? files) {
    _presenter.getFilesOnNext(files, _ptype, _type);
  }

  void onComplete() {
    _presenter.getFilesOnComplete(_ptype);
  }

  void onError(e) {
    _presenter.getFilesOnError(e, _ptype);
  }
}
