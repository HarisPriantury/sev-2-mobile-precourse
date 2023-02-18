import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/file.dart';

class CreateLobbyRoomFileDBRequest
    implements CreateLobbyRoomFileRequestInterface {
  String roomId;
  File file;

  CreateLobbyRoomFileDBRequest(this.roomId, this.file);
}
