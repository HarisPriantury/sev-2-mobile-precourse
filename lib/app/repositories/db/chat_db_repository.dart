import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/chat/get_messages_db_request.dart';
import 'package:mobile_sev2/data/payload/db/chat/send_message_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/chat_repository_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';

class ChatDBRepository implements ChatRepository {
  Box<Chat> _box;

  ChatDBRepository(this._box);

  @override
  Future<List<Chat>> findAll(GetMessagesRequestInterface params) {
    var request = params as GetMessagesDBRequest;
    var chats = _box.values.where((c) => c.roomId == request.roomId).toList();

    return Future.value(chats);
  }

  @override
  Future<bool> sendMessage(SendMessageRequestInterface request) async {
    var params = request as SendMessageDBRequest;
    await _box.put(params.chat.roomId, params.chat);
    return Future.value(true);
  }

  @override
  Future<bool> deleteMessage(DeleteMessageRequestInterface request) {
    // TODO: implement deleteMessage
    throw UnimplementedError();
  }
}
