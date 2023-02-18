import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class CreateLobbyRoomTaskDBRequest
    implements CreateLobbyRoomTaskRequestInterface {
  String roomId;
  Ticket ticket;

  CreateLobbyRoomTaskDBRequest(this.roomId, this.ticket);
}
