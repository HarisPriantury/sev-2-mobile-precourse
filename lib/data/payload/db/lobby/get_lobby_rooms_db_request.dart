import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class GetLobbyRoomsDBRequest implements GetLobbyRoomsRequestInterface {
  String workspaceId;

  GetLobbyRoomsDBRequest(this.workspaceId);
}