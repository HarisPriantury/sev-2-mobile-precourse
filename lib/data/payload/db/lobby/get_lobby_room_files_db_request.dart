import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class GetLobbyRoomFilesDBRequest implements GetLobbyRoomFilesRequestInterface {
  String roomId;

  GetLobbyRoomFilesDBRequest(this.roomId);
}
