import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class DeleteRoomDBRequest implements DeleteRoomRequestInterface {
  String roomId;

  DeleteRoomDBRequest(this.roomId);
}
