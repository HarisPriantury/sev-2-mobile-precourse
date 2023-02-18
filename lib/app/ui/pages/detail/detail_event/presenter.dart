import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/calendar/join_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/use_cases/calendar/create_event.dart';
import 'package:mobile_sev2/use_cases/calendar/get_events.dart';
import 'package:mobile_sev2/use_cases/calendar/join_event.dart';
import 'package:mobile_sev2/use_cases/file/create_file.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/file/prepare_create_file.dart';
import 'package:mobile_sev2/use_cases/phobject/get_object_transactions.dart';
import 'package:mobile_sev2/use_cases/phobject/get_objects.dart';
import 'package:mobile_sev2/use_cases/reaction/get_object_reactions.dart';
import 'package:mobile_sev2/use_cases/reaction/give_reaction.dart';

class DetailEventPresenter extends Presenter {
  DetailEventPresenter(
    this._joinEventUseCase,
    this._eventsUseCase,
    this._transactionsUseCase,
    this._objectUseCase,
    this._createEventUseCase,
    this._getObjectReactionsUseCase,
    this._giveReactionUseCase,
    this._uploadUseCase,
    this._prepareUploadUseCase,
    this._getFilesUseCase,
    this._getFilesDbUseCase,
  );

  // comment
  late Function calendarTransactionOnComplete;
  late Function calendarTransactionOnError;
  late Function calendarTransactionOnNext;

  // get events
  late Function getEventOnNext;
  late Function getEventOnComplete;
  late Function getEventOnError;

  // get object reaction
  late Function getObjectReactionOnComplete;
  late Function getObjectReactionOnError;
  late Function getObjectReactionOnNext;

  // get object
  late Function getObjectsOnComplete;
  late Function getObjectsOnError;
  late Function getObjectsOnNext;

  // get transactions
  late Function getTransactionsOnComplete;
  late Function getTransactionsOnError;
  late Function getTransactionsOnNext;

  // join event
  late Function joinEventOnComplete;
  late Function joinEventOnError;
  late Function joinEventOnNext;

  // send reaction
  late Function sendReactionOnComplete;
  late Function sendReactionOnError;
  late Function sendReactionOnNext;

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

  CreateEventUseCase _createEventUseCase;
  GetEventsUseCase _eventsUseCase;
  GetObjectReactionsUseCase _getObjectReactionsUseCase;
  GiveReactionUseCase _giveReactionUseCase;
  JoinEventUseCase _joinEventUseCase;
  GetObjectsUseCase _objectUseCase;
  GetObjectTransactionsUseCase _transactionsUseCase;
  CreateFileUseCase _uploadUseCase;
  PrepareCreateFileUseCase _prepareUploadUseCase;
  GetFilesUseCase _getFilesUseCase;
  GetFilesUseCase _getFilesDbUseCase;

  @override
  void dispose() {
    _joinEventUseCase.dispose();
    _eventsUseCase.dispose();
    _transactionsUseCase.dispose();
    _objectUseCase.dispose();
    _createEventUseCase.dispose();
    _getObjectReactionsUseCase.dispose();
    _uploadUseCase.dispose();
    _prepareUploadUseCase.dispose();
    _getFilesUseCase.dispose();
  }

  void onJoinEvent(JoinEventRequestInterface req) {
    if (req is JoinEventApiRequest) {
      _joinEventUseCase.execute(
          _JoinEventObserver(this, PersistenceType.api), req);
    }
  }

  void onGetEvent(GetEventsRequestInterface req) {
    _eventsUseCase.execute(_GetEventsObserver(this, PersistenceType.api), req);
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

  void onCalendarTransaction(CreateEventRequestInterface req) {
    if (req is CreateEventApiRequest) {
      _createEventUseCase.execute(
          _CalendarTransactionObserver(this, PersistenceType.api), req);
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
}

class _JoinEventObserver implements Observer<bool> {
  _JoinEventObserver(this._presenter, this._type);

  DetailEventPresenter _presenter;
  PersistenceType _type;

  void onNext(bool? result) {
    _presenter.joinEventOnNext(result, _type);
  }

  void onComplete() {
    _presenter.joinEventOnComplete(_type);
  }

  void onError(e) {
    _presenter.joinEventOnError(e, _type);
  }
}

class _GetEventsObserver implements Observer<List<Calendar>> {
  _GetEventsObserver(this._presenter, this._type);

  DetailEventPresenter _presenter;
  PersistenceType _type;

  void onNext(List<Calendar>? calendar) {
    _presenter.getEventOnNext(calendar, _type);
  }

  void onComplete() {
    _presenter.getEventOnComplete(_type);
  }

  void onError(e) {
    _presenter.getEventOnError(e, _type);
  }
}

class _GetTransactionsObserver implements Observer<List<PhTransaction>> {
  _GetTransactionsObserver(this._presenter, this._type);

  DetailEventPresenter _presenter;
  PersistenceType _type;

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
  _GetObjectsObserver(this._presenter, this._type);

  DetailEventPresenter _presenter;
  PersistenceType _type;

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

class _CalendarTransactionObserver implements Observer<bool> {
  _CalendarTransactionObserver(this._presenter, this._type);

  DetailEventPresenter _presenter;
  PersistenceType _type;

  void onNext(bool? result) {
    _presenter.calendarTransactionOnNext(result, _type);
  }

  void onComplete() {
    _presenter.calendarTransactionOnComplete(_type);
  }

  void onError(e) {
    _presenter.calendarTransactionOnError(e, _type);
  }
}

class _GetObjectReactionsObserver implements Observer<List<ObjectReactions>> {
  _GetObjectReactionsObserver(this._presenter);

  DetailEventPresenter _presenter;

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
  _GiveReactionObserver(this._presenter, this._type);

  DetailEventPresenter _presenter;
  PersistenceType _type;

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

class _UploadFileObserver implements Observer<BaseApiResponse> {
  DetailEventPresenter _presenter;
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
  DetailEventPresenter _presenter;
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
  DetailEventPresenter _presenter;
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
