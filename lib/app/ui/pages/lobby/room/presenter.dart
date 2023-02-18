import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/delete_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/send_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/get_flags_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_calendar_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_stickits_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_tasks_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/delete_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/flag.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/calendar/get_events.dart';
import 'package:mobile_sev2/use_cases/chat/delete_message.dart';
import 'package:mobile_sev2/use_cases/chat/get_messages.dart';
import 'package:mobile_sev2/use_cases/chat/send_message.dart';
import 'package:mobile_sev2/use_cases/file/create_file.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/file/prepare_create_file.dart';
import 'package:mobile_sev2/use_cases/flag/get_flags.dart';
import 'package:mobile_sev2/use_cases/lobby/get_list_user_db.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_calendar.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_files.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_stickits.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_tickets.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_rooms.dart';
import 'package:mobile_sev2/use_cases/reaction/get_object_reactions.dart';
import 'package:mobile_sev2/use_cases/reaction/get_reactions.dart';
import 'package:mobile_sev2/use_cases/reaction/give_reaction.dart';
import 'package:mobile_sev2/use_cases/room/add_participants.dart';
import 'package:mobile_sev2/use_cases/room/delete_room.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class LobbyRoomPresenter extends Presenter {
  GetMessagesUseCase _messageUseCase;
  GetMessagesUseCase _messageDbUseCase;
  SendMessageUseCase _sendUseCase;
  SendMessageUseCase _sendDbUseCase;
  DeleteMessageUseCase _deleteMessageUseCase;
  DeleteRoomUseCase _deleteRoomUseCase;
  GetFilesUseCase _getFilesUseCase;
  GetFilesUseCase _getFilesDbUseCase;
  GetLobbyRoomsUseCase _roomsUseCase;
  GetLobbyRoomStickitsUseCase _stickitUseCase;
  GetLobbyRoomCalendarUseCase _calendarUseCase;
  GetLobbyRoomFilesUseCase _fileUseCase;
  GetLobbyRoomTicketsUseCase _lobbyTicketUseCase;
  CreateFileUseCase _uploadUseCase;
  PrepareCreateFileUseCase _prepareUploadUseCase;
  GetUsersUseCase _getUsersUseCase;
  GetRoomParticipantsUseCase _participantsUseCase;
  AddRoomParticipantsUseCase _addParticipantsUseCase;
  GiveReactionUseCase _giveReactionUseCase;
  GetObjectReactionsUseCase _getObjectReactionsUseCase;
  GetListUserDbUseCase _getListUserDbUseCase;
  GetReactionsUseCase _reactions;
  GetTicketsUseCase _ticketsUseCase;
  GetEventsUseCase _eventsUseCase;
  GetFlagsUseCase _getFlagsUseCase;

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

  // delete room
  late Function deleteRoomOnNext;
  late Function deleteRoomOnComplete;
  late Function deleteRoomOnError;

  // get attachment
  late Function getFilesOnNext;
  late Function getFilesOnComplete;
  late Function getFilesOnError;

  // get lobby rooms
  late Function getLobbyRoomsOnNext;
  late Function getLobbyRoomsOnComplete;
  late Function getLobbyRoomsOnError;

  // get stickits
  late Function getLobbyRoomStickitsOnNext;
  late Function getLobbyRoomStickitsOnComplete;
  late Function getLobbyRoomStickitsOnError;

  // calendar
  late Function getLobbyRoomCalendarOnNext;
  late Function getLobbyRoomCalendarOnComplete;
  late Function getLobbyRoomCalendarOnError;

  // files
  late Function getLobbyRoomFilesOnNext;
  late Function getLobbyRoomFilesOnComplete;
  late Function getLobbyRoomFilesOnError;

  // tickets
  late Function getLobbyRoomTicketsOnNext;
  late Function getLobbyRoomTicketsOnComplete;
  late Function getLobbyRoomTicketsOnError;

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

  // get participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  // add participant
  late Function addParticipantsOnNext;
  late Function addParticipantsOnComplete;
  late Function addParticipantsOnError;

  // send reaction
  late Function sendReactionOnNext;
  late Function sendReactionOnComplete;
  late Function sendReactionOnError;

  // get object reaction
  late Function getObjectReactionOnNext;
  late Function getObjectReactionOnComplete;
  late Function getObjectReactionOnError;

  // get list User from Db
  late Function getListUserFromDbOnNext;
  late Function getListUserFromDbOnComplete;
  late Function getListUserFromDbOnError;

  //get reaction
  late Function getReactionsOnNext;
  late Function getReactionsOnComplete;
  late Function getReactionsOnError;

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // for get calendar events
  late Function getEventsOnNext;
  late Function getEventsOnComplete;
  late Function getEventsOnError;

  // get reported message list
  late Function getFlagsOnNext;
  late Function getFlagsOnComplete;
  late Function getFlagsOnError;

  LobbyRoomPresenter(
    this._messageUseCase,
    this._messageDbUseCase,
    this._sendUseCase,
    this._sendDbUseCase,
    this._deleteMessageUseCase,
    this._deleteRoomUseCase,
    this._getFilesUseCase,
    this._getFilesDbUseCase,
    this._roomsUseCase,
    this._stickitUseCase,
    this._calendarUseCase,
    this._fileUseCase,
    this._lobbyTicketUseCase,
    this._uploadUseCase,
    this._prepareUploadUseCase,
    this._getUsersUseCase,
    this._participantsUseCase,
    this._addParticipantsUseCase,
    this._giveReactionUseCase,
    this._getObjectReactionsUseCase,
    this._getListUserDbUseCase,
    this._reactions,
    this._ticketsUseCase,
    this._eventsUseCase,
    this._getFlagsUseCase,
  );

  void onGetMessages(GetMessagesRequestInterface req) {
    if (req is GetMessagesApiRequest) {
      _messageUseCase.execute(_GetMessagesObserver(this, PersistenceType.api), req);
    } else {
      _messageDbUseCase.execute(_GetMessagesObserver(this, PersistenceType.db), req);
    }
  }

  void onSendMessage(SendMessageRequestInterface req) {
    if (req is SendMessageApiRequest) {
      _sendUseCase.execute(_SendMessageObserver(this, PersistenceType.api), req);
    } else {
      _sendDbUseCase.execute(_SendMessageObserver(this, PersistenceType.db), req);
    }
  }

  void onDeleteMessage(DeleteMessageApiRequest req) {
    if (req is DeleteMessageApiRequest) {
      _deleteMessageUseCase.execute(_DeleteMessageObserver(this, PersistenceType.api), req);
    }
  }

  void onDeleteRoom(DeleteRoomRequestInterface req) {
    if (req is DeleteRoomApiRequest) {
      _deleteRoomUseCase.execute(_DeleteRoomObserver(this, PersistenceType.api), req);
    }
  }

  void onGetFiles(GetFilesRequestInterface req, String type) {
    if (req is GetFilesApiRequest) {
      _getFilesUseCase.execute(_GetFilesObserver(this, PersistenceType.api, type), req);
    } else {
      _getFilesDbUseCase.execute(_GetFilesObserver(this, PersistenceType.db, type), req);
    }
  }

  void onGetLobbyRooms(GetLobbyRoomsRequestInterface req) {
    if (req is GetLobbyRoomsApiRequest) {
      _roomsUseCase.execute(_GetLobbyRoomsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetLobbyRoomStickits(GetLobbyRoomStickitsRequestInterface req) {
    if (req is GetLobbyRoomStickitsApiRequest) {
      _stickitUseCase.execute(_GetLobbyRoomStickitsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetLobbyRoomCalendar(GetLobbyRoomCalendarRequestInterface req) {
    if (req is GetLobbyRoomCalendarApiRequest) {
      _calendarUseCase.execute(_GetLobbyRoomCalendarObserver(this, PersistenceType.api), req);
    }
  }

  void onGetLobbyRoomFiles(GetLobbyRoomFilesRequestInterface req) {
    if (req is GetLobbyRoomFilesApiRequest) {
      _fileUseCase.execute(_GetLobbyRoomFilesObserver(this, PersistenceType.api), req);
    }
  }

  void onGetLobbyRoomTickets(GetLobbyRoomTasksRequestInterface req) {
    if (req is GetLobbyRoomTasksApiRequest) {
      _lobbyTicketUseCase.execute(_GetLobbyRoomTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onUploadFile(CreateFileRequestInterface req) {
    _uploadUseCase.execute(_UploadFileObserver(this, PersistenceType.api), req);
  }

  void onPrepareUploadFile(PrepareCreateFileRequestInterface req) {
    _prepareUploadUseCase.execute(_PrepareFileUploadObserver(this, PersistenceType.api), req);
  }

  void onGetUsers(GetUsersRequestInterface req, String from, {bool isNewMessage = false}) {
    _getUsersUseCase.execute(
        _GetUsersObserver(
          this,
          PersistenceType.api,
          from,
          isNewMessage,
        ),
        req);
  }

  void onGetParticipants(GetParticipantsRequestInterface req) {
    _participantsUseCase.execute(_GetParticipantsObserver(this, PersistenceType.api), req);
  }

  void onAddParticipants(AddParticipantsRequestInterface req) {
    _addParticipantsUseCase.execute(_AddParticipantsObserver(this, PersistenceType.api), req);
  }

  void onSendReaction(GiveReactionRequestInterface req) {
    if (req is GiveReactionApiRequest) {
      _giveReactionUseCase.execute(_GiveReactionObserver(this, PersistenceType.api), req);
    }
  }

  void onGetObjectReactions(GetObjectReactionsRequestInterface req, {bool isNewMessage = false}) {
    if (req is GetObjectReactionsApiRequest) {
      _getObjectReactionsUseCase.execute(_GetObjectReactionsObserver(this, isNewMessage), req);
    }
  }

  void onGetListUserFromDb(GetListUserFromDbRequestInterface req) {
    _getListUserDbUseCase.execute(_GetUserListFromDbObserver(this, PersistenceType.db), req);
  }

  void onGetReactions(GetReactionsRequestInterface req) {
    if (req is GetReactionsApiRequest) {
      _reactions.execute(_GetReactionUseCaseObserver(this, PersistenceType.api), req);
    }
  }

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketsUseCase.execute(_GetTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetCalendars(GetEventsRequestInterface req) {
    if (req is GetEventsApiRequest) {
      _eventsUseCase.execute(_GetEventsObserver(this), req);
    }
  }

  void onGetFlags(GetFlagsRequestInterface req) {
    if (req is GetFlagsApiRequest) {
      _getFlagsUseCase.execute(
        _GetFlagsObserver(
          this,
          PersistenceType.api,
        ),
        req,
      );
    }
  }

  @override
  void dispose() {
    _messageUseCase.dispose();
    _messageDbUseCase.dispose();
    _sendUseCase.dispose();
    _sendDbUseCase.dispose();
    _deleteMessageUseCase.dispose();
    _deleteRoomUseCase.dispose();
    _roomsUseCase.dispose();
    _stickitUseCase.dispose();
    _calendarUseCase.dispose();
    _fileUseCase.dispose();
    _lobbyTicketUseCase.dispose();
    _uploadUseCase.dispose();
    _prepareUploadUseCase.dispose();
    _getUsersUseCase.dispose();
    _participantsUseCase.dispose();
    _addParticipantsUseCase.dispose();
    _giveReactionUseCase.dispose();
    _getObjectReactionsUseCase.dispose();
    _getListUserDbUseCase.dispose();
    _reactions.dispose();
    _ticketsUseCase.dispose();
    _eventsUseCase.dispose();
    _getFilesUseCase.dispose();
    _getFlagsUseCase.dispose();
  }
}

class _GetMessagesObserver implements Observer<List<Chat>> {
  LobbyRoomPresenter _presenter;
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
  LobbyRoomPresenter _presenter;
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
  LobbyRoomPresenter _presenter;
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

class _DeleteRoomObserver implements Observer<bool> {
  LobbyRoomPresenter _presenter;
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

class _GetFilesObserver implements Observer<List<File>> {
  LobbyRoomPresenter _presenter;
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

class _GetLobbyRoomsObserver implements Observer<List<Room>> {
  LobbyRoomPresenter _presenter;
  PersistenceType _type;

  _GetLobbyRoomsObserver(this._presenter, this._type);

  void onNext(List<Room>? rooms) {
    _presenter.getLobbyRoomsOnNext(rooms, _type);
  }

  void onComplete() {
    _presenter.getLobbyRoomsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getLobbyRoomsOnError(e, _type);
  }
}

class _GetLobbyRoomStickitsObserver implements Observer<List<Stickit>> {
  LobbyRoomPresenter _presenter;
  PersistenceType _type;

  _GetLobbyRoomStickitsObserver(this._presenter, this._type);

  void onNext(List<Stickit>? stickits) {
    _presenter.getLobbyRoomStickitsOnNext(stickits, _type);
  }

  void onComplete() {
    _presenter.getLobbyRoomStickitsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getLobbyRoomStickitsOnError(e, _type);
  }
}

class _GetLobbyRoomCalendarObserver implements Observer<List<Calendar>> {
  LobbyRoomPresenter _presenter;
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

class _GetLobbyRoomTicketsObserver implements Observer<List<Ticket>> {
  LobbyRoomPresenter _presenter;
  PersistenceType _type;

  _GetLobbyRoomTicketsObserver(this._presenter, this._type);

  void onNext(List<Ticket>? tickets) {
    _presenter.getLobbyRoomTicketsOnNext(tickets, _type);
  }

  void onComplete() {
    _presenter.getLobbyRoomTicketsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getLobbyRoomTicketsOnError(e, _type);
  }
}

class _GetLobbyRoomFilesObserver implements Observer<List<File>> {
  LobbyRoomPresenter _presenter;
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

class _PrepareFileUploadObserver implements Observer<bool> {
  LobbyRoomPresenter _presenter;
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
  LobbyRoomPresenter _presenter;
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

class _GetUsersObserver implements Observer<List<User>> {
  LobbyRoomPresenter _presenter;
  PersistenceType _type;
  String from;
  bool _isNewMessage;

  _GetUsersObserver(
    this._presenter,
    this._type,
    this.from,
    this._isNewMessage,
  );

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users, _type, from, _isNewMessage);
  }

  void onComplete() {
    _presenter.getUsersOnComplete(_type);
  }

  void onError(e) {
    _presenter.getUsersOnError(e, _type);
  }
}

class _GetParticipantsObserver implements Observer<List<User>> {
  LobbyRoomPresenter _presenter;
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
  LobbyRoomPresenter _presenter;
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

class _GetReactionUseCaseObserver implements Observer<List<Reaction>> {
  LobbyRoomPresenter _presenter;
  PersistenceType _type;

  _GetReactionUseCaseObserver(this._presenter, this._type);

  void onNext(List<Reaction>? result) {
    _presenter.getReactionsOnNext(result, _type);
  }

  void onComplete() {
    _presenter.getReactionsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getReactionsOnError(e, _type);
  }
}

class _GiveReactionObserver implements Observer<bool> {
  LobbyRoomPresenter _presenter;
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
  LobbyRoomPresenter _presenter;
  bool _isNewMessage;

  _GetObjectReactionsObserver(this._presenter, this._isNewMessage);

  void onNext(List<ObjectReactions>? result) {
    _presenter.getObjectReactionOnNext(result, _isNewMessage);
  }

  void onComplete() {
    _presenter.getObjectReactionOnComplete();
  }

  void onError(e) {
    _presenter.getObjectReactionOnError(e);
  }
}

class _GetUserListFromDbObserver implements Observer<List<User>> {
  LobbyRoomPresenter _presenter;
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
  LobbyRoomPresenter _presenter;
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
  LobbyRoomPresenter _presenter;

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

class _GetFlagsObserver implements Observer<List<Flag>> {
  LobbyRoomPresenter _presenter;
  PersistenceType _type;

  _GetFlagsObserver(this._presenter, this._type);

  void onNext(List<Flag>? result) {
    _presenter.getFlagsOnNext(result, _type);
  }

  void onComplete() {
    _presenter.getFlagsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getFlagsOnError(e, _type);
  }
}
