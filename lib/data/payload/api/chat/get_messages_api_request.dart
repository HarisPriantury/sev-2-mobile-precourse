import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';

class GetMessagesApiRequest
    implements GetMessagesRequestInterface, ApiRequestInterface {
  String? roomId;
  int? limit;
  int? offset;

  GetMessagesApiRequest({this.roomId, this.limit, this.offset});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    if (roomId != null) req['roomPHID'] = this.roomId;
    if (limit != null) req['limit'] = this.limit.toString();
    if (limit != null) req['offset'] = this.offset.toString();
    return req;
  }
}
