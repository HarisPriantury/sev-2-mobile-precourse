import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/stickit.dart';

class CreateLobbyRoomStickitDBRequest
    implements CreateLobbyRoomStickitRequestInterface {
  String roomId;
  Stickit stickit;

  CreateLobbyRoomStickitDBRequest(this.roomId, this.stickit);
}
