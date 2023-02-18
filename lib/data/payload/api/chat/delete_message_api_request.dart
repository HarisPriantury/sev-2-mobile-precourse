import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';

class DeleteMessageApiRequest
    implements DeleteMessageRequestInterface, ApiRequestInterface {
  List<String> messageIds;
  DeleteMessageApiRequest(this.messageIds);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    if (!this.messageIds.isNullOrEmpty()) {
      var messageIds = Map<String, String>();
      var counter = 0;
      this.messageIds.asMap().forEach((key, value) {
        if (!messageIds.containsValue(value.toString())) {
          messageIds[(counter++).toString()] = value;
        }
      });
      req['transactionPHIDs'] = messageIds;
    }
    print("DeleteMessageApiRequest : $req");
    return req;
  }
}
