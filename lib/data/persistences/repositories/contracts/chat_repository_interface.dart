import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';

abstract class ChatRepository {
  Future<List<Chat>> findAll(GetMessagesRequestInterface params);
  Future<bool> sendMessage(SendMessageRequestInterface request);
  Future<bool> deleteMessage(DeleteMessageRequestInterface request);
}
