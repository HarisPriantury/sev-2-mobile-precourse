import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class CreateRoomApiRequest
    implements CreateRoomRequestInterface, ApiRequestInterface {
  String name;
  String topic;
  List<String> participants;
  String? objectIdentifier;

  CreateRoomApiRequest(this.name, this.topic, this.participants, {this.objectIdentifier});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    var dataParticipants = Map<String, String>();
    var counter = 0;
    this.participants.asMap().forEach((key, value) {
      if (!dataParticipants.containsValue(value.toString())) {
        dataParticipants[(counter++).toString()] = value;
      }
    });

    req['transactions'] = {
      "0": {"type": "name", "value": this.name},
      "1": {"type": "topic", "value": this.topic},
      "2": {"type": "participants.set", "value": dataParticipants}
    };

    if (objectIdentifier != null) {
      req['objectIdentifier'] = objectIdentifier;
    }

    return req;
  }
}
