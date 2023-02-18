import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class GetParticipantsApiRequest implements GetParticipantsRequestInterface, ApiRequestInterface {
  String roomId;

  GetParticipantsApiRequest(this.roomId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['conpherencePHID'] = this.roomId;

    return req;
  }
}
