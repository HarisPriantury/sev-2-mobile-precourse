import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class UpdateRoomApiRequest
    implements UpdateRoomRequestInterface, ApiRequestInterface {
  String roomId;
  String name;
  String topic;

  UpdateRoomApiRequest(this.roomId, this.name, this.topic);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['objectIdentifier'] = this.roomId;
    req['transactions'] = {
      "0": {"type": "name", "value": this.name},
      "1": {"type": "topic", "value": this.topic},
    };

    return req;
  }
}
