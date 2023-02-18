import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_ticket_info_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/file/create_file.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/file/prepare_create_file.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_task.dart';
import 'package:mobile_sev2/use_cases/phobject/get_object_transactions.dart';
import 'package:mobile_sev2/use_cases/phobject/get_objects.dart';
import 'package:mobile_sev2/use_cases/project/get_project_column_ticket.dart';
import 'package:mobile_sev2/use_cases/reaction/get_object_reactions.dart';
import 'package:mobile_sev2/use_cases/reaction/give_reaction.dart';
import 'package:mobile_sev2/use_cases/ticket/get_ticket_subscribers.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class DetailTicketPresenter extends Presenter {
  GetUsersUseCase _usersUseCase;
  GetObjectTransactionsUseCase _transactionsUseCase;
  GetObjectsUseCase _objectUseCase;
  GetTicketSubscribersUseCase _ticketSubscribersUseCase;
  GetTicketsUseCase _ticketsUseCase;
  GetProjectColumnTicketUseCase _columnTicketUseCase;

  // for comment
  GiveReactionUseCase _giveReactionUseCase;
  CreateLobbyRoomTaskUseCase _createTaskUseCase;
  GetObjectReactionsUseCase _getObjectReactionsUseCase;

  // for files
  CreateFileUseCase _uploadUseCase;
  PrepareCreateFileUseCase _prepareUploadUseCase;
  GetFilesUseCase _getFilesUseCase;
  GetFilesUseCase _getFilesDbUseCase;

  DetailTicketPresenter(
    this._usersUseCase,
    this._transactionsUseCase,
    this._objectUseCase,
    this._ticketSubscribersUseCase,
    this._createTaskUseCase,
    this._giveReactionUseCase,
    this._getObjectReactionsUseCase,
    this._ticketsUseCase,
    this._uploadUseCase,
    this._prepareUploadUseCase,
    this._getFilesUseCase,
    this._getFilesDbUseCase,
    this._columnTicketUseCase,
  );

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // get transactions
  late Function getTransactionsOnNext;
  late Function getTransactionsOnComplete;
  late Function getTransactionsOnError;

  // get object
  late Function getObjectsOnNext;
  late Function getObjectsOnComplete;
  late Function getObjectsOnError;

  // get ticket subscribers
  late Function getTicketSubscribersOnNext;
  late Function getTicketSubscribersOnComplete;
  late Function getTicketSubscribersOnError;

  late Function taskTransactionOnNext;
  late Function taskTransactionOnComplete;
  late Function taskTransactionOnError;

  // send reaction
  late Function sendReactionOnNext;
  late Function sendReactionOnComplete;
  late Function sendReactionOnError;

  // get object reaction
  late Function getObjectReactionOnNext;
  late Function getObjectReactionOnComplete;
  late Function getObjectReactionOnError;

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

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

  // get object columns
  late Function getColumnsTicketOnNext;
  late Function getColumnsTicketOnComplete;
  late Function getColumnsTicketOnError;

  void onGetUsers(GetUsersRequestInterface req, String role) {
    if (req is GetUsersApiRequest) {
      _usersUseCase.execute(
          _GetUsersObserver(this, PersistenceType.api, role), req);
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

  void onGetTicketSubscribers(GetTicketInfoRequestInterface req) {
    if (req is GetTicketInfoApiRequest) {
      _ticketSubscribersUseCase.execute(
          _GetTicketSubscribersObserver(this, PersistenceType.api), req);
    }
  }

  void onTaskTransaction(CreateLobbyRoomTaskRequestInterface req) {
    if (req is CreateLobbyRoomTicketApiRequest) {
      _createTaskUseCase.execute(
          _TaskTransactionObserver(this, PersistenceType.api), req);
    }
  }

  void onSendReaction(GiveReactionRequestInterface req) {
    if (req is GiveReactionApiRequest) {
      _giveReactionUseCase.execute(
          _GiveReactionObserver(this, PersistenceType.api), req);
    }
  }

  void onGetObjectReactions(GetObjectReactionsRequestInterface req) {
    if (req is GetObjectReactionsApiRequest) {
      _getObjectReactionsUseCase.execute(
          _GetObjectReactionsObserver(this), req);
    }
  }

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketsUseCase.execute(
          _GetTicketsObserver(this, PersistenceType.api), req);
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

  void onGetColumnTicket(GetProjectColumnTicketRequestInterface req) {
    if (req is GetProjectColumnTicketApiRequest) {
      _columnTicketUseCase.execute(_GetColumnTicketObserver(this), req);
    }
  }

  @override
  void dispose() {
    _usersUseCase.dispose();
    _transactionsUseCase.dispose();
    _objectUseCase.dispose();
    _createTaskUseCase.dispose();
    _giveReactionUseCase.dispose();
    _getObjectReactionsUseCase.dispose();
    _ticketSubscribersUseCase.dispose();
    _ticketsUseCase.dispose();
    _uploadUseCase.dispose();
    _prepareUploadUseCase.dispose();
    _getFilesUseCase.dispose();
    _columnTicketUseCase.dispose();
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  DetailTicketPresenter _presenter;
  PersistenceType _type;
  String _role;

  _GetUsersObserver(this._presenter, this._type, this._role);

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users, _type, _role);
  }

  void onComplete() {
    _presenter.getUsersOnComplete(_type);
  }

  void onError(e) {
    _presenter.getUsersOnError(e, _type);
  }
}

class _GetTransactionsObserver implements Observer<List<PhTransaction>> {
  DetailTicketPresenter _presenter;
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
  DetailTicketPresenter _presenter;
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

class _GetTicketSubscribersObserver implements Observer<TicketSubscriberInfo> {
  DetailTicketPresenter _presenter;
  PersistenceType _type;

  _GetTicketSubscribersObserver(this._presenter, this._type);

  void onNext(TicketSubscriberInfo? subscriberInfo) {
    _presenter.getTicketSubscribersOnNext(subscriberInfo, _type);
  }

  void onComplete() {
    _presenter.getTicketSubscribersOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTicketSubscribersOnError(e, _type);
  }
}

class _TaskTransactionObserver implements Observer<bool> {
  DetailTicketPresenter _presenter;
  PersistenceType _type;

  _TaskTransactionObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.taskTransactionOnNext(result, _type);
  }

  void onComplete() {
    _presenter.taskTransactionOnComplete(_type);
  }

  void onError(e) {
    _presenter.taskTransactionOnError(e, _type);
  }
}

class _GiveReactionObserver implements Observer<bool> {
  DetailTicketPresenter _presenter;
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

class _GetObjectReactionsObserver implements Observer<List<ObjectReactions>> {
  DetailTicketPresenter _presenter;

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

class _GetTicketsObserver implements Observer<List<Ticket>> {
  DetailTicketPresenter _presenter;
  PersistenceType _type;

  _GetTicketsObserver(this._presenter, this._type);

  void onNext(List<Ticket>? tickets) {
    _presenter.getTicketsOnNext(tickets, _type);
  }

  void onComplete() {
    _presenter.getTicketsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTicketsOnError(e, _type);
  }
}

class _UploadFileObserver implements Observer<BaseApiResponse> {
  DetailTicketPresenter _presenter;
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
  DetailTicketPresenter _presenter;
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
  DetailTicketPresenter _presenter;
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

class _GetColumnTicketObserver implements Observer<List<ProjectColumn>> {
  DetailTicketPresenter _presenter;

  _GetColumnTicketObserver(this._presenter);

  void onNext(List<ProjectColumn>? columns) {
    _presenter.getColumnsTicketOnNext(columns);
  }

  void onComplete() {
    _presenter.getColumnsTicketOnComplete();
  }

  void onError(e) {
    _presenter.getColumnsTicketOnError(e);
  }
}