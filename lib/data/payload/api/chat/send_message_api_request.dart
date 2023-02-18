import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';

class SendMessageApiRequest
    implements SendMessageRequestInterface, ApiRequestInterface {
  String roomId;
  String message;

  SendMessageApiRequest(this.roomId, this.message);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['roomPHID'] = roomId;
    req['text'] = message;
    return req;
  }
}
