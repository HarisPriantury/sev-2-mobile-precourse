import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class AddParticipantDBRequest implements AddParticipantsRequestInterface {
  String roomId;
  String userId;

  AddParticipantDBRequest(this.roomId, this.userId);
}
