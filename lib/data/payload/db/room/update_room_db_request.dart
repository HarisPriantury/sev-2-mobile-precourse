import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/domain/room.dart';

class UpdateRoomDBRequest implements CreateRoomRequestInterface {
  String roomId;
  Room room;

  UpdateRoomDBRequest(this.roomId, this.room);
}
