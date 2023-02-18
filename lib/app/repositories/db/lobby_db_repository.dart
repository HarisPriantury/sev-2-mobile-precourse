import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/lobby/create_lobby_room_file_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/create_lobby_room_stickit_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/create_lobby_room_task_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_lobby_room_calendar_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_lobby_room_files_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_lobby_room_stickits_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_lobby_room_tasks_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_lobby_rooms_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/store_list_reaction_to_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/store_list_user_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/lobby_room_info.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

class LobbyDBRepository implements LobbyRepository {
  Box<LobbyRoomInfo> _box;
  Box<Room> _roomBox;
  Box<LobbyStatus> _statusBox;
  Box<User> _userBox;
  Box<Reaction> _reactionBox;

  LobbyDBRepository(this._box, this._roomBox, this._statusBox, this._userBox,
      this._reactionBox);

  @override
  Future<Room> getHQ(GetRoomHQRequestInterface params) {
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getParticipants(
      GetLobbyParticipantsRequestInterface params) {
    throw UnimplementedError();
  }

  @override
  Future<List<Room>> getRooms(GetLobbyRoomsRequestInterface params) {
    late List<Room> rooms;
    if (params is GetLobbyRoomsDBRequest) {
      rooms = _roomBox.values
          .where((element) => element.workspaceId == params.workspaceId)
          .toList(growable: true);
    } else {
      rooms = [];
    }
    return Future.value(rooms);
  }

  @override
  Future<bool> updateStatus(UpdateStatusRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> join(Object request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> joinChannel(JoinLobbyChannelRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> leaveWork(LeaveWorkRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> workOnTask(WorkOnTaskRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<List<Calendar>> getCalendars(
      GetLobbyRoomCalendarRequestInterface request) {
    var param = request as GetLobbyRoomCalendarDBRequest;
    var data = _box.get(param.roomId);
    return Future.value(data?.calendars);
  }

  @override
  Future<List<File>> getFiles(GetLobbyRoomFilesRequestInterface request) {
    var param = request as GetLobbyRoomFilesDBRequest;
    var data = _box.get(param.roomId);
    return Future.value(data?.files);
  }

  @override
  Future<List<Stickit>> getStickits(
      GetLobbyRoomStickitsRequestInterface request) {
    var param = request as GetLobbyRoomStickitsDBRequest;
    var data = _box.get(param.roomId);
    return Future.value(data?.stickits);
  }

  @override
  Future<List<Ticket>> getTickets(GetLobbyRoomTasksRequestInterface request) {
    var param = request as GetLobbyRoomTasksDBRequest;
    var data = _box.get(param.roomId);
    return Future.value(data?.tickets);
  }

  @override
  Future<bool> createFile(CreateLobbyRoomFileRequestInterface request) {
    var param = request as CreateLobbyRoomFileDBRequest;
    var data = _box.get(param.roomId);
    data?.files?.add(param.file);
    return Future.value(true);
  }

  @override
  Future<bool> createStickit(CreateLobbyRoomStickitRequestInterface request) {
    var param = request as CreateLobbyRoomStickitDBRequest;
    var data = _box.get(param.roomId);
    data?.stickits?.add(param.stickit);
    return Future.value(true);
  }

  @override
  Future<bool> createTask(CreateLobbyRoomTaskRequestInterface request) {
    var param = request as CreateLobbyRoomTaskDBRequest;
    var data = _box.get(param.roomId);
    data?.tickets?.add(param.ticket);
    return Future.value(true);
  }

  @override
  Future<List<LobbyStatus>> getStatuses(
      GetLobbyStatusesRequestInterface request) {
    var statuses = _statusBox.values.toList();
    return Future.value(statuses);
  }

  @override
  Future<bool> setAsReadStickit(SetAsReadStickitRequestInterface request) {
    // TODO: implement setAsReadStickit
    throw UnimplementedError();
  }

  @override
  Future<bool> storeListUser(StoreListUserDbRequestInterface request) {
    var param = request as StoreUserListDbRequest;
    try {
      _userBox.putAll(param.newListUsers);
    } catch (e) {
      print("store list user error : $e");
    }
    return Future.value(true);
  }

  @override
  Future<List<User>> getListUser(GetListUserFromDbRequestInterface params) {
    var users = _userBox.values.toList();
    return Future.value(users);
  }

  @override
  Future<bool> storeListReactions(
      StoreListReactionToDbRequestInterface request) {
    var param = request as StoreUserReactionToDbRequest;
    try {
      _reactionBox.putAll(param.reactions);
    } catch (e) {
      print("store list reactions error : $e");
    }
    return Future.value(true);
  }
}
