import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class GetLobbyRoomTasksDBRequest implements GetLobbyRoomTasksRequestInterface {
  String roomId;

  GetLobbyRoomTasksDBRequest(this.roomId);
}
