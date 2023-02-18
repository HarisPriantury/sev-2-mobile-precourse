import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class RemoveParticipantsApiRequest
    implements RemoveParticipantsRequestInterface, ApiRequestInterface {
  String roomId;
  List<String> participantIds;

  RemoveParticipantsApiRequest(this.roomId, this.participantIds);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['objectIdentifier'] = this.roomId;

    var dataParticipantIds = Map<String, String>();
    var counter = 0;
    this.participantIds.asMap().forEach((key, value) {
      if (!dataParticipantIds.containsValue(value.toString())) {
        dataParticipantIds[(counter++).toString()] = value;
      }
    });

    req['transactions'] = {
      "0": {"type": "participants.remove", "value": dataParticipantIds}
    };

    return req;
  }
}
