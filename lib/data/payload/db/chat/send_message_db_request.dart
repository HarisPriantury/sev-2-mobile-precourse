import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';

class SendMessageDBRequest implements SendMessageRequestInterface {
  Chat chat;

  SendMessageDBRequest(this.chat);
}
