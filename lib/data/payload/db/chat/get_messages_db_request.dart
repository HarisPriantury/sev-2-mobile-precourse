import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';

class GetMessagesDBRequest implements GetMessagesRequestInterface {
  String roomId;

  GetMessagesDBRequest(this.roomId);
}
