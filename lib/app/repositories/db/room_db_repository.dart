import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/room/add_participant_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/create_room_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/delete_room_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/get_rooms_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/remove_participant_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/update_room_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/room_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/room_participants.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

class RoomDBRepository implements RoomRepository {
  Box<Room> _roomBox;
  Box<RoomParticipants> _participantsBox;

  RoomDBRepository(this._roomBox, this._participantsBox);

  @override
  Future<bool> addParticipants(AddParticipantsRequestInterface request) {
    var param = request as AddParticipantDBRequest;
    // get room participants
    var roomParticipants = _participantsBox.get(param.roomId);
    roomParticipants?.userIds.add(param.userId);

    // save
    _participantsBox.put(param.roomId, roomParticipants!);
    return Future.value(true);
  }

  @override
  Future<BaseApiResponse> create(CreateRoomRequestInterface request) {
    var param = request as CreateRoomDBRequest;
    _roomBox.put(param.room.id, param.room);
    return Future.value(BaseApiResponse(param.room.id));
  }

  @override
  Future<bool> delete(DeleteRoomRequestInterface request) {
    var param = request as DeleteRoomDBRequest;
    _roomBox.delete(param.roomId);
    return Future.value(true);
  }

  @override
  Future<List<Room>> findAll(GetRoomsRequestInterface params) {
    late List<Room> rooms;
    if (params is GetRoomsDBRequest) {
      rooms = _roomBox.values
          .where((element) => element.workspaceId == params.workspaceId)
          .toList(growable: true);
    } else {
      rooms = [];
    }
    return Future.value(rooms);
  }

  @override
  Future<List<User>> getParticipants(GetParticipantsRequestInterface params) {
    throw UnimplementedError();
  }

  @override
  Future<bool> removeParticipants(RemoveParticipantsRequestInterface request) {
    var param = request as RemoveParticipantDBRequest;
    var roomParticipants = _participantsBox.get(param.roomId);
    roomParticipants?.userIds.remove(param.userId);

    // save
    _participantsBox.put(param.roomId, roomParticipants!);
    return Future.value(true);
  }

  @override
  Future<bool> update(UpdateRoomRequestInterface request) {
    var param = request as UpdateRoomDBRequest;
    _roomBox.put(param.roomId, param.room);
    return Future.value(true);
  }

  @override
  Future<bool> restoreRoom(RestoreRoomRequestInterface request) {
    // TODO: implement restoreRoom
    throw UnimplementedError();
  }
}
