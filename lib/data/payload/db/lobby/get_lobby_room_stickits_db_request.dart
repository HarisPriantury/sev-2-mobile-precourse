import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class GetLobbyRoomStickitsDBRequest
    implements GetLobbyRoomStickitsRequestInterface {
  String roomId;

  GetLobbyRoomStickitsDBRequest(this.roomId);
}
