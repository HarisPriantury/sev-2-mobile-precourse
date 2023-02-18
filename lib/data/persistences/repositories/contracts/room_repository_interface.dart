import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

abstract class RoomRepository {
  Future<List<Room>> findAll(GetRoomsRequestInterface params);
  Future<BaseApiResponse> create(CreateRoomRequestInterface request);
  Future<bool> update(UpdateRoomRequestInterface request);
  Future<bool> delete(DeleteRoomRequestInterface request);
  Future<List<User>> getParticipants(GetParticipantsRequestInterface params);
  Future<bool> addParticipants(AddParticipantsRequestInterface request);
  Future<bool> removeParticipants(RemoveParticipantsRequestInterface request);
  Future<bool> restoreRoom(RestoreRoomRequestInterface request);
}
