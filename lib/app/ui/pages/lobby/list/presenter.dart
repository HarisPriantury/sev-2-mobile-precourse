import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/flag/create_flag_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/delete_flag_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/get_flags_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_room_hq_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/join_lobby_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/join_lobby_channel_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/restore_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_lobby_rooms_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/create_room_db_request.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/country.dart';
import 'package:mobile_sev2/domain/flag.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/chat/get_messages.dart';
import 'package:mobile_sev2/use_cases/chat/send_message.dart';
import 'package:mobile_sev2/use_cases/country/getCountries.dart';
import 'package:mobile_sev2/use_cases/flag/create_flag.dart';
import 'package:mobile_sev2/use_cases/flag/delete_flag.dart';
import 'package:mobile_sev2/use_cases/flag/get_flags.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_participants.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_rooms.dart';
import 'package:mobile_sev2/use_cases/lobby/get_room_hq.dart';
import 'package:mobile_sev2/use_cases/lobby/join_lobby.dart';
import 'package:mobile_sev2/use_cases/lobby/join_lobby_channel.dart';
import 'package:mobile_sev2/use_cases/lobby/restore_room.dart';
import 'package:mobile_sev2/use_cases/lobby/store_list_user_db.dart';
import 'package:mobile_sev2/use_cases/room/create_room.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/user/get_profile_info.dart';

class LobbyPresenter extends Presenter {
  GetLobbyRoomsUseCase _roomsUseCase;
  GetLobbyRoomsUseCase _roomsDBUseCase;
  GetLobbyParticipantsUseCase _participantsUseCase;
  GetRoomHQUseCase _hqUseCase;
  JoinLobbyChannelUseCase _joinChannelUseCase;
  JoinLobbyUseCase _joinLobbyUseCase;
  GetMessagesUseCase _messagesUseCase;
  GetMessagesUseCase _messagesDbUseCase;
  SendMessageUseCase _sendDbUseCase;
  RestoreRoomUseCase _restoreRoomUseCase;
  StoreListUserDbUseCase _storeListUserToDbUseCase;
  CreateRoomUseCase _createDbUseCase;
  GetFlagsUseCase _getFlagsUseCase;
  CreateFlagUseCase _createFlagUseCase;
  DeleteFlagUseCase _deleteFlagUseCase;
  GetTicketsUseCase _ticketUseCase;
  GetProfileUseCase _profileUsecase;
  GetCountriesUseCase _getCountriesUseCase;

  LobbyPresenter(
    this._hqUseCase,
    this._roomsUseCase,
    this._roomsDBUseCase,
    this._participantsUseCase,
    this._joinChannelUseCase,
    this._joinLobbyUseCase,
    this._messagesUseCase,
    this._messagesDbUseCase,
    this._sendDbUseCase,
    this._restoreRoomUseCase,
    this._storeListUserToDbUseCase,
    this._createDbUseCase,
    this._getFlagsUseCase,
    this._createFlagUseCase,
    this._deleteFlagUseCase,
    this._ticketUseCase,
    this._profileUsecase,
    this._getCountriesUseCase,
  );

  // get lobby rooms
  late Function getLobbyRoomsOnNext;
  late Function getLobbyRoomsOnComplete;
  late Function getLobbyRoomsOnError;

  // get lobby participants
  late Function getLobbyParticipantsOnNext;
  late Function getLobbyParticipantsOnComplete;
  late Function getLobbyParticipantsOnError;

  // get HQ
  late Function getRoomHQOnNext;
  late Function getRoomHQOnComplete;
  late Function getRoomHQOnError;

  // get my rooms
  late Function getMyRoomsOnNext;
  late Function getMyRoomsOnComplete;
  late Function getMyRoomsOnError;

  // join lobby
  late Function joinLobbyOnNext;
  late Function joinLobbyOnComplete;
  late Function joinLobbyOnError;

  // join lobby channel
  late Function joinLobbyChannelOnNext;
  late Function joinLobbyChannelOnComplete;
  late Function joinLobbyChannelOnError;

  // get messages
  late Function getMessagesOnNext;
  late Function getMessagesOnComplete;
  late Function getMessagesOnError;

  // send message
  late Function sendMessageOnNext;
  late Function sendMessageOnComplete;
  late Function sendMessageOnError;

  //restore room
  late Function restoreRoomOnNext;
  late Function restoreRoomOnComplete;
  late Function restoreRoomOnError;

  //store list user to DB
  late Function storeListUserToDbOnNext;
  late Function storeListUserToDbOnComplete;
  late Function storeListUserToDbOnError;

  // create room
  late Function createRoomOnNext;
  late Function createRoomOnComplete;
  late Function createRoomOnError;

  // get flags
  late Function getFlagsOnNext;
  late Function getFlagsOnComplete;
  late Function getFlagsOnError;

  // create flag
  late Function createFlagOnNext;
  late Function createFlagOnComplete;
  late Function createFlagOnError;

  // delete flag
  late Function deleteFlagOnNext;
  late Function deleteFlagOnComplete;
  late Function deleteFlagOnError;

  // get outstanding ticket
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // for get profile
  late Function getProfileOnNext;
  late Function getProfileOnComplete;
  late Function getProfileOnError;

  // for get countriesGraphQL
  late Function getCountriesOnNext;
  late Function getCountriesOnComplete;
  late Function getCountriesOnError;

  void onGetLobbyRooms(GetLobbyRoomsRequestInterface req) {
    if (req is GetLobbyRoomsApiRequest) {
      _roomsUseCase.execute(
        _GetLobbyRoomsObserver(
          this,
          PersistenceType.api,
        ),
        req,
      );
    } else if (req is GetLobbyRoomsDBRequest) {
      _roomsDBUseCase.execute(
        _GetLobbyRoomsObserver(
          this,
          PersistenceType.db,
        ),
        req,
      );
    }
  }

  void onGetLobbyParticipants(GetLobbyParticipantsRequestInterface req) {
    if (req is GetLobbyParticipantsApiRequest) {
      _participantsUseCase.execute(
          _GetLobbyParticipantsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetRoomHQ(GetRoomHQRequestInterface req) {
    if (req is GetRoomHQApiRequest) {
      _hqUseCase.execute(_GetRoomHQObserver(this, PersistenceType.api), req);
    }
  }

  void onJoinLobby(JoinLobbyRequestInterface req) {
    if (req is JoinLobbyApiRequest) {
      _joinLobbyUseCase.execute(
          _JoinLobbyObserver(this, PersistenceType.api), req);
    }
  }

  void onJoinLobbyChannel(JoinLobbyChannelRequestInterface req, Room room) {
    if (req is JoinLobbyChannelApiRequest) {
      _joinChannelUseCase.execute(
          _JoinLobbyChannelObserver(this, PersistenceType.api, room), req);
    }
  }

  void onGetMessages(GetMessagesRequestInterface req, {String from = "room"}) {
    if (req is GetMessagesApiRequest) {
      _messagesUseCase.execute(
          _GetMessagesObserver(this, PersistenceType.api, from), req);
    } else {
      _messagesDbUseCase.execute(
          _GetMessagesObserver(this, PersistenceType.db, from), req);
    }
  }

  void onSendDBMessage(SendMessageRequestInterface req) {
    _sendDbUseCase.execute(_SendMessageObserver(this, PersistenceType.db), req);
  }

  void onRestoreRoom(RestoreRoomRequestInterface req) {
    if (req is RestoreRoomApiRequesst) {
      _restoreRoomUseCase.execute(
          _RestoreRoomObserver(this, PersistenceType.api), req);
    }
  }

  void onStoreListUserDb(StoreListUserDbRequestInterface req) {
    _storeListUserToDbUseCase.execute(
        _StoreListUserToDb(this, PersistenceType.db), req);
  }

  void onCreateRoom(CreateRoomRequestInterface req) {
    if (req is CreateRoomDBRequest) {
      _createDbUseCase.execute(
        _CreateRoomObserver(
          this,
          PersistenceType.db,
        ),
        req,
      );
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

  void onCreateFlag(CreateFlagRequestInterface req) {
    if (req is CreateFlagApiRequest) {
      _createFlagUseCase.execute(
        _CreateFlagObserver(
          this,
          PersistenceType.api,
        ),
        req,
      );
    }
  }

  void onDeleteFlag(DeleteFlagRequestInterface req) {
    if (req is DeleteFlagApiRequest) {
      _deleteFlagUseCase.execute(
        _DeleteFlagObserver(
          this,
          PersistenceType.api,
        ),
        req,
      );
    }
  }

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketUseCase.execute(
          _GetTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetProfile(GetProfileRequestInterface req) {
    if (req is GetProfileApiRequest) {
      _profileUsecase.execute(
          _GetProfileObserver(this, PersistenceType.api), req);
    }
  }

  void onGetCountries(Map<String, dynamic> req) {
    _getCountriesUseCase.execute(_GetCountriesObserver(this), req);
  }

  @override
  void dispose() {
    _hqUseCase.dispose();
    _roomsUseCase.dispose();
    _participantsUseCase.dispose();
    _joinLobbyUseCase.dispose();
    _joinChannelUseCase.dispose();
    _messagesUseCase.dispose();
    _messagesDbUseCase.dispose();
    _sendDbUseCase.dispose();
    _restoreRoomUseCase.dispose();
    _storeListUserToDbUseCase.dispose();
    _createDbUseCase.dispose();
    _getFlagsUseCase.dispose();
    _createFlagUseCase.dispose();
    _deleteFlagUseCase.dispose();
    _ticketUseCase.dispose();
    _profileUsecase.dispose();
  }
}

class _GetRoomHQObserver implements Observer<Room> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _GetRoomHQObserver(this._presenter, this._type);

  void onNext(Room? room) {
    _presenter.getRoomHQOnNext(room, _type);
  }

  void onComplete() {
    _presenter.getRoomHQOnComplete(_type);
  }

  void onError(e) {
    _presenter.getRoomHQOnError(e, _type);
  }
}

class _GetLobbyRoomsObserver implements Observer<List<Room>> {
  LobbyPresenter _presenter;
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

class _GetLobbyParticipantsObserver implements Observer<List<User>> {
  LobbyPresenter _presenter;
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

class _GetMyRoomsObserver implements Observer<List<Room>> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _GetMyRoomsObserver(this._presenter, this._type);

  void onNext(List<Room>? rooms) {
    _presenter.getMyRoomsOnNext(rooms, _type);
  }

  void onComplete() {
    _presenter.getMyRoomsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getMyRoomsOnError(e, _type);
  }
}

class _JoinLobbyObserver implements Observer<bool> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _JoinLobbyObserver(this._presenter, this._type);

  void onNext(bool? room) {
    _presenter.joinLobbyOnNext(room, _type);
  }

  void onComplete() {
    _presenter.joinLobbyOnComplete(_type);
  }

  void onError(e) {
    _presenter.joinLobbyOnError(e, _type);
  }
}

class _JoinLobbyChannelObserver implements Observer<bool> {
  LobbyPresenter _presenter;
  PersistenceType _type;
  Room _room;

  _JoinLobbyChannelObserver(this._presenter, this._type, this._room);

  void onNext(bool? room) {
    _presenter.joinLobbyChannelOnNext(room, _type);
  }

  void onComplete() {
    _presenter.joinLobbyChannelOnComplete(_type, this._room);
  }

  void onError(e) {
    _presenter.joinLobbyChannelOnError(e, _type);
  }
}

class _GetMessagesObserver implements Observer<List<Chat>> {
  LobbyPresenter _presenter;
  PersistenceType _type;
  String _from;

  _GetMessagesObserver(this._presenter, this._type, this._from);

  void onNext(List<Chat>? messages) {
    _presenter.getMessagesOnNext(messages, _type, _from);
  }

  void onComplete() {
    _presenter.getMessagesOnComplete(_type, _from);
  }

  void onError(e) {
    _presenter.getMessagesOnError(e, _type, _from);
  }
}

class _SendMessageObserver implements Observer<bool> {
  LobbyPresenter _presenter;
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

class _RestoreRoomObserver implements Observer<bool> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _RestoreRoomObserver(this._presenter, this._type);

  @override
  void onNext(bool? result) {
    _presenter.restoreRoomOnNext(result, _type);
  }

  @override
  void onComplete() {
    _presenter.restoreRoomOnComplete(_type);
  }

  @override
  void onError(e) {
    _presenter.restoreRoomOnError(e, _type);
  }
}

class _StoreListUserToDb implements Observer<bool> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _StoreListUserToDb(this._presenter, this._type);

  @override
  void onNext(bool? result) {
    _presenter.storeListUserToDbOnNext(result, _type);
  }

  @override
  void onComplete() {
    _presenter.storeListUserToDbOnComplete(_type);
  }

  @override
  void onError(e) {
    _presenter.storeListUserToDbOnError(e, _type);
  }
}

class _CreateRoomObserver implements Observer<BaseApiResponse> {
  LobbyPresenter _presenter;
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

class _GetFlagsObserver implements Observer<List<Flag>> {
  LobbyPresenter _presenter;
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

class _CreateFlagObserver implements Observer<bool> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _CreateFlagObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.createFlagOnNext(result, _type);
  }

  void onComplete() {
    _presenter.createFlagOnComplete(_type);
  }

  void onError(e) {
    _presenter.createFlagOnError(e, _type);
  }
}

class _DeleteFlagObserver implements Observer<bool> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _DeleteFlagObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.createFlagOnNext(result, _type);
  }

  void onComplete() {
    _presenter.createFlagOnComplete(_type);
  }

  void onError(e) {
    _presenter.createFlagOnError(e, _type);
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _GetTicketsObserver(
    this._presenter,
    this._type,
  );

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

class _GetProfileObserver implements Observer<User> {
  LobbyPresenter _presenter;
  PersistenceType _type;

  _GetProfileObserver(this._presenter, this._type);

  void onNext(User? user) {
    _presenter.getProfileOnNext(user, _type);
  }

  void onComplete() {
    _presenter.getProfileOnComplete(_type);
  }

  void onError(e) {
    _presenter.getProfileOnError(e, _type);
  }
}

class _GetCountriesObserver implements Observer<List<Country>> {
  LobbyPresenter _presenter;

  _GetCountriesObserver(this._presenter);

  void onNext(List<Country>? countries) {
    _presenter.getCountriesOnNext(countries);
  }

  void onComplete() {
    _presenter.getCountriesOnComplete();
  }

  void onError(e) {
    _presenter.getCountriesOnError(e);
  }
}
