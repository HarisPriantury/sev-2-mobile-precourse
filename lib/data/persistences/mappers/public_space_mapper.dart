import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

class PublicSpaceMapper with DataUtil {
  DateUtilInterface _dateUtil;
  String _workspace;

  PublicSpaceMapper(
    this._dateUtil,
    this._workspace,
  );

  Room convertGetPublicSpaceApiResponse(Map<String, dynamic> response) {
    var publicSpace = Room(
      response['channel_phid'],
      lastMessage: response['last_message']['message'],
      lastMessageCreatedAt:
          _dateUtil.fromSeconds(response['last_message']['timestamp']),
      memberCount: response['participant_count'] != null
          ? response['participant_count'].toString()
          : "0",
      workspaceId: _workspace,
    );
    return publicSpace;
  }

  List<Chat> convertGetPublicSpaceChatsApiResponse(List response) {
    var chats = List<Chat>.empty(growable: true);
    for (var data in response) {
      Chat chat = Chat(
        data['transactionPHID'],
        _dateUtil.fromSeconds(data['dateCreated']),
        data['transactionComment'] ?? data['transactionTitle'],
        data['transactionType'] != "core:comment",
        data['roomPHID'],
        fullName: data['authorName'],
        avatar: data['authorAvatar'],
        sender: User(
          data['authorPHID'],
          fullName: data['authorName'],
          avatar: data['authorAvatar'],
        ),
      );
      chats.add(chat);
    }
    return chats;
  }
}
