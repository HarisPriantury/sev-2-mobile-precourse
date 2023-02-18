import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/delete_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/send_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/delete_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/calendar/get_events.dart';
import 'package:mobile_sev2/use_cases/chat/delete_message.dart';
import 'package:mobile_sev2/use_cases/chat/get_messages.dart';
import 'package:mobile_sev2/use_cases/chat/send_message.dart';
import 'package:mobile_sev2/use_cases/file/create_file.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/file/prepare_create_file.dart';
import 'package:mobile_sev2/use_cases/lobby/get_list_user_db.dart';
import 'package:mobile_sev2/use_cases/reaction/give_reaction.dart';
import 'package:mobile_sev2/use_cases/room/delete_room.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class ChatPresenter extends Presenter {
  GetMessagesUseCase _messageUsecase;
  GetMessagesUseCase _messageDbUsecase;
  SendMessageUseCase _sendUseCase;
  SendMessageUseCase _sendDbUseCase;
  DeleteMessageUseCase _deleteMessageUseCase;
  GiveReactionUseCase _reactionUseCase;
  GetFilesUseCase _getFilesUseCase;
  GetFilesUseCase _getFilesDbUseCase;
  CreateFileUseCase _uploadUseCase;
  PrepareCreateFileUseCase _prepareUploadUseCase;
  GetUsersUseCase _getUsersUseCase;
  GetUsersUseCase _getUsersDbUseCase;
  DeleteRoomUseCase _deleteRoomUseCase;
  DeleteRoomUseCase _deleteRoomDbUseCase;
  GetListUserDbUseCase _getListUserDbUseCase;
  GetTicketsUseCase _ticketsUseCase;
  GetEventsUseCase _eventsUseCase;

  // get messages
  late Function getMessagesOnNext;
  late Function getMessagesOnComplete;
  late Function getMessagesOnError;

  // send message
  late Function sendMessageOnNext;
  late Function sendMessageOnComplete;
  late Function sendMessageOnError;

  // delete message
  late Function deleteMessageOnNext;
  late Function deleteMessageOnComplete;
  late Function deleteMessageOnError;

  // send reaction
  late Function sendReactionOnNext;
  late Function sendReactionOnComplete;
  late Function sendReactionOnError;

  // get attachment
  late Function getFilesOnNext;
  late Function getFilesOnComplete;
  late Function getFilesOnError;

  // prepare for upload
  late Function prepareFileUploadOnNext;
  late Function prepareFileUploadOnComplete;
  late Function prepareFileUploadOnError;

  // upload file
  late Function uploadFileOnNext;
  late Function uploadFileOnComplete;
  late Function uploadFileOnError;

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // leave room
  late Function deleteRoomOnNext;
  late Function deleteRoomOnComplete;
  late Function deleteRoomOnError;

  // get list User
  late Function getListUserFromDbOnNext;
  late Function getListUserFromDbOnComplete;
  late Function getListUserFromDbOnError;

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // for get calendar events
  late Function getEventsOnNext;
  late Function getEventsOnComplete;
  late Function getEventsOnError;

  ChatPresenter(
    this._messageUsecase,
    this._messageDbUsecase,
    this._sendUseCase,
    this._sendDbUseCase,
    this._deleteMessageUseCase,
    this._reactionUseCase,
    this._getFilesUseCase,
    this._getFilesDbUseCase,
    this._uploadUseCase,
    this._prepareUploadUseCase,
    this._getUsersUseCase,
    this._getUsersDbUseCase,
    this._deleteRoomUseCase,
    this._deleteRoomDbUseCase,
    this._getListUserDbUseCase,
    this._ticketsUseCase,
    this._eventsUseCase,
  );

  void onGetMessages(GetMessagesRequestInterface req) {
    if (req is GetMessagesApiRequest) {
      _messageUsecase.execute(
          _GetMessagesObserver(this, PersistenceType.api), req);
    } else {
      _messageDbUsecase.execute(
          _GetMessagesObserver(this, PersistenceType.db), req);
    }
  }

  void onSendMessage(SendMessageRequestInterface req) {
    if (req is SendMessageApiRequest) {
      _sendUseCase.execute(
          _SendMessageObserver(this, PersistenceType.api), req);
    } else {
      _sendDbUseCase.execute(
          _SendMessageObserver(this, PersistenceType.db), req);
    }
  }

  void onDeleteMessage(DeleteMessageApiRequest req) {
    if (req is DeleteMessageApiRequest) {
      _deleteMessageUseCase.execute(
          _DeleteMessageObserver(this, PersistenceType.api), req);
    }
  }

  void onSendReaction(GiveReactionRequestInterface req) {
    if (req is GiveReactionApiRequest) {
      _reactionUseCase.execute(
          _GiveReactionObserver(this, PersistenceType.api), req);
    }
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

  void onUploadFile(CreateFileRequestInterface req, {String from = 'chat'}) {
    _uploadUseCase.execute(
        _UploadFileObserver(this, PersistenceType.api, from), req);
  }

  void onPrepareUploadFile(PrepareCreateFileRequestInterface req) {
    _prepareUploadUseCase.execute(
        _PrepareFileUploadObserver(this, PersistenceType.api), req);
  }

  void onGetUsers(GetUsersRequestInterface req, {bool isNewMessage = false}) {
    if (req is GetUsersApiRequest) {
      _getUsersUseCase.execute(
          _GetUsersObserver(this, PersistenceType.api, isNewMessage), req);
    } else {
      _getUsersDbUseCase.execute(
          _GetUsersObserver(this, PersistenceType.db, isNewMessage), req);
    }
  }

  void onDeleteRoom(DeleteRoomRequestInterface req) {
    if (req is DeleteRoomApiRequest) {
      _deleteRoomUseCase.execute(
          _DeleteRoomObserver(this, PersistenceType.api), req);
    }
  }

  void onGetListUserFromDb(GetListUserFromDbRequestInterface req) {
    _getListUserDbUseCase.execute(
        _GetUserListFromDbObserver(this, PersistenceType.db), req);
  }

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketsUseCase.execute(
          _GetTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetCalendars(GetEventsRequestInterface req) {
    if (req is GetEventsApiRequest) {
      _eventsUseCase.execute(_GetEventsObserver(this), req);
    }
  }

  void dispose() {
    _messageUsecase.dispose();
    _messageDbUsecase.dispose();
    _sendUseCase.dispose();
    _sendDbUseCase.dispose();
    _reactionUseCase.dispose();
    _getFilesUseCase.dispose();
    _getFilesDbUseCase.dispose();
    _uploadUseCase.dispose();
    _prepareUploadUseCase.dispose();
    _getUsersUseCase.dispose();
    _getUsersDbUseCase.dispose();
    _deleteRoomUseCase.dispose();
    _deleteRoomDbUseCase.dispose();
    _getListUserDbUseCase.dispose();
    _ticketsUseCase.dispose();
    _eventsUseCase.dispose();
  }
}

class _GetMessagesObserver implements Observer<List<Chat>> {
  ChatPresenter _presenter;
  PersistenceType _type;

  _GetMessagesObserver(this._presenter, this._type);

  void onNext(List<Chat>? chats) {
    _presenter.getMessagesOnNext(chats, _type);
  }

  void onComplete() {
    _presenter.getMessagesOnComplete(_type);
  }

  void onError(e) {
    _presenter.getMessagesOnError(e, _type);
  }
}

class _SendMessageObserver implements Observer<bool> {
  ChatPresenter _presenter;
  PersistenceType _type;

  _SendMessageObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.sendMessageOnNext(result, _type);
  }

  void onComplete() {
    _presenter.sendMessageOnComplete(_type);
  }

  void onError(e) {
    _presenter.sendMessageOnError(e, _type);
  }
}

class _DeleteMessageObserver implements Observer<bool> {
  ChatPresenter _presenter;
  PersistenceType _type;

  _DeleteMessageObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.deleteMessageOnNext(result, _type);
  }

  void onComplete() {
    _presenter.deleteMessageOnComplete(_type);
  }

  void onError(e) {
    _presenter.deleteMessageOnError(e, _type);
  }
}

class _GiveReactionObserver implements Observer<bool> {
  ChatPresenter _presenter;
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

class _GetFilesObserver implements Observer<List<File>> {
  ChatPresenter _presenter;
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

class _PrepareFileUploadObserver implements Observer<bool> {
  ChatPresenter _presenter;
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

class _UploadFileObserver implements Observer<BaseApiResponse> {
  ChatPresenter _presenter;
  PersistenceType _type;
  String _from;

  _UploadFileObserver(this._presenter, this._type, this._from);

  void onNext(BaseApiResponse? result) {
    _presenter.uploadFileOnNext(result, _type, _from);
  }

  void onComplete() {
    _presenter.uploadFileOnComplete(_type, _from);
  }

  void onError(e) {
    _presenter.uploadFileOnError(e, _type, _from);
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  ChatPresenter _presenter;
  PersistenceType _type;
  bool _isNewMessage;

  _GetUsersObserver(
    this._presenter,
    this._type,
    this._isNewMessage,
  );

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users, _type, _isNewMessage);
  }

  void onComplete() {
    _presenter.getUsersOnComplete(_type, _isNewMessage);
  }

  void onError(e) {
    _presenter.getUsersOnError(e, _type, _isNewMessage);
  }
}

class _DeleteRoomObserver implements Observer<bool> {
  ChatPresenter _presenter;
  PersistenceType _type;

  _DeleteRoomObserver(this._presenter, this._type);

  void onNext(bool? users) {
    _presenter.deleteRoomOnNext(users, _type);
  }

  void onComplete() {
    _presenter.deleteRoomOnComplete(_type);
  }

  void onError(e) {
    _presenter.deleteRoomOnError(e, _type);
  }
}

class _GetUserListFromDbObserver implements Observer<List<User>> {
  ChatPresenter _presenter;
  PersistenceType _type;

  _GetUserListFromDbObserver(this._presenter, this._type);

  void onNext(List<User>? users) {
    _presenter.getListUserFromDbOnNext(users, _type);
  }

  void onComplete() {
    _presenter.getListUserFromDbOnComplete(_type);
  }

  void onError(e) {
    _presenter.getListUserFromDbOnError(e, _type);
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  ChatPresenter _presenter;
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

class _GetEventsObserver implements Observer<List<Calendar>> {
  ChatPresenter _presenter;

  _GetEventsObserver(this._presenter);

  void onNext(List<Calendar>? calendars) {
    _presenter.getEventsOnNext(calendars);
  }

  void onComplete() {
    _presenter.getEventsOnComplete();
  }

  void onError(e) {
    _presenter.getEventsOnError(e);
  }
}