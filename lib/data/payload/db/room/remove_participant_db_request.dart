import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class RemoveParticipantDBRequest implements AddParticipantsRequestInterface {
  String roomId;
  String userId;

  RemoveParticipantDBRequest(this.roomId, this.userId);
}
