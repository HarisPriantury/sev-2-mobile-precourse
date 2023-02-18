import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class GetLobbyRoomCalendarDBRequest
    implements GetLobbyRoomCalendarRequestInterface {
  String roomId;

  GetLobbyRoomCalendarDBRequest(this.roomId);
}
