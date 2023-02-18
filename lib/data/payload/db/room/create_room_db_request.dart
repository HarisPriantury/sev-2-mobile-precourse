import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/domain/room.dart';

class CreateRoomDBRequest implements CreateRoomRequestInterface {
  Room room;

  CreateRoomDBRequest(this.room);
}
