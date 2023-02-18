import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/join_lobby_channel_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/room/create_room_db_request.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/chat/get_messages.dart';
import 'package:mobile_sev2/use_cases/chat/send_message.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/lobby/join_lobby_channel.dart';
import 'package:mobile_sev2/use_cases/room/create_room.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_rooms.dart';

class RoomsPresenter extends Presenter {
  GetRoomsUseCase _roomsUsecase;
  GetRoomsUseCase _roomsDbUsecase;
  GetRoomParticipantsUseCase _participantsUseCase;
  GetMessagesUseCase _messagesUseCase;
  GetMessagesUseCase _messagesDbUseCase;
  SendMessageUseCase _sendDbUseCase;
  GetFilesUseCase _filesUseCase;
  GetFilesUseCase _filesDbUseCase;
  CreateRoomUseCase _createRoomDbUseCase;
  JoinLobbyChannelUseCase _joinChannelUseCase;

  // for get rooms
  late Function getRoomsOnNext;
  late Function getRoomsOnComplete;
  late Function getRoomsOnError;

  // get messages
  late Function getMessagesOnNext;
  late Function getMessagesOnComplete;
  late Function getMessagesOnError;

  // send message
  late Function sendMessageOnNext;
  late Function sendMessageOnComplete;
  late Function sendMessageOnError;

  // get room participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  // get objects
  late Function getObjectsOnNext;
  late Function getObjectsOnComplete;
  late Function getObjectsOnError;

  // get files
  late Function getFilesOnNext;
  late Function getFilesOnComplete;
  late Function getFilesOnError;

  // create room
  late Function createRoomOnNext;
  late Function createRoomOnComplete;
  late Function createRoomOnError;

  // join lobby channel
  late Function joinLobbyChannelOnNext;
  late Function joinLobbyChannelOnComplete;
  late Function joinLobbyChannelOnError;

  // update setting
  late Function updateSettingOnNext;
  late Function updateSettingOnComplete;
  late Function updateSettingOnError;

  RoomsPresenter(
    this._roomsUsecase,
    this._roomsDbUsecase,
    this._participantsUseCase,
    this._messagesUseCase,
    this._messagesDbUseCase,
    this._sendDbUseCase,
    this._filesUseCase,
    this._filesDbUseCase,
    this._createRoomDbUseCase,
    this._joinChannelUseCase,
  );

  void onGetRooms(GetRoomsRequestInterface req) {
    if (req is GetRoomsApiRequest) {
      _roomsUsecase.execute(_GetRoomsObserver(this, PersistenceType.api), req);
    } else {
      _roomsDbUsecase.execute(_GetRoomsObserver(this, PersistenceType.db), req);
    }
  }

  void onGetMessages(GetMessagesRequestInterface req) {
    if (req is GetMessagesApiRequest) {
      _messagesUseCase.execute(_GetMessagesObserver(this, PersistenceType.api), req);
    } else {
      _messagesDbUseCase.execute(_GetMessagesObserver(this, PersistenceType.db), req);
    }
  }

  void onSendDBMessage(SendMessageRequestInterface req) {
    _sendDbUseCase.execute(_SendMessageObserver(this, PersistenceType.db), req);
  }

  void onGetRoomParticipants(GetParticipantsRequestInterface req) {
    if (req is GetParticipantsApiRequest) {
      _participantsUseCase.execute(_GetParticipantsObserver(this, req.roomId), req);
    }
  }

  void onGetFiles(GetFilesRequestInterface req) {
    if (req is GetFilesApiRequest) {
      _filesUseCase.execute(_GetFilesObserver(this, PersistenceType.api), req);
    } else {
      _filesDbUseCase.execute(_GetFilesObserver(this, PersistenceType.api), req);
    }
  }

  void onCreateRoom(CreateRoomRequestInterface req) {
    if (req is CreateRoomDBRequest) {
      _createRoomDbUseCase.execute(_CreateRoomObserver(this, PersistenceType.db), req);
    }
  }

  void onJoinLobbyChannel(JoinLobbyChannelRequestInterface req, Room room) {
    if (req is JoinLobbyChannelApiRequest) {
      _joinChannelUseCase.execute(_JoinLobbyChannelObserver(this, PersistenceType.api, room), req);
    }
  }

  void dispose() {
    _roomsUsecase.dispose();
    _roomsDbUsecase.dispose();
    _participantsUseCase.dispose();
    _messagesUseCase.dispose();
    _messagesDbUseCase.dispose();
    _filesUseCase.dispose();
    _filesDbUseCase.dispose();
    _createRoomDbUseCase.dispose();
    _joinChannelUseCase.dispose();
    _sendDbUseCase.dispose();
  }
}

class _GetRoomsObserver implements Observer<List<Room>> {
  RoomsPresenter _presenter;
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
  RoomsPresenter _presenter;
  String _roomId;

  _GetParticipantsObserver(this._presenter, this._roomId);

  void onNext(List<User>? users) {
    _presenter.getParticipantsOnNext(users, _roomId);
  }

  void onComplete() {
    _presenter.getParticipantsOnComplete();
  }

  void onError(e) {
    _presenter.getParticipantsOnError(e, _roomId);
  }
}

class _GetMessagesObserver implements Observer<List<Chat>> {
  RoomsPresenter _presenter;
  PersistenceType _type;

  _GetMessagesObserver(this._presenter, this._type);

  void onNext(List<Chat>? messages) {
    _presenter.getMessagesOnNext(messages, _type);
  }

  void onComplete() {
    _presenter.getMessagesOnComplete(_type);
  }

  void onError(e) {
    _presenter.getMessagesOnError(e, _type);
  }
}

class _SendMessageObserver implements Observer<bool> {
  RoomsPresenter _presenter;
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

class _GetFilesObserver implements Observer<List<File>> {
  RoomsPresenter _presenter;
  PersistenceType _type;

  _GetFilesObserver(this._presenter, this._type);

  void onNext(List<File>? files) {
    _presenter.getFilesOnNext(files, _type);
  }

  void onComplete() {
    _presenter.getFilesOnComplete(_type);
  }

  void onError(e) {
    _presenter.getFilesOnError(e, _type);
  }
}

class _CreateRoomObserver implements Observer<BaseApiResponse> {
  RoomsPresenter _presenter;
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

class _JoinLobbyChannelObserver implements Observer<bool> {
  RoomsPresenter _presenter;
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
