import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/user.dart';

class ChatMapper {
  DateUtilInterface _dateUtil;

  ChatMapper(this._dateUtil);

  List<Chat> convertGetChatsApiResponse(Map<String, dynamic> response) {
    var chats = List<Chat>.empty(growable: true);
    var repliedMessage;
    var data = response['result'];
    if (data != null && data.length != 0) {
      data.forEach((key, value) {
        if (value['transactionComment']
            .toString()
            .split("\n")
            .first
            .contains(RegExp(">|> "))) {
          List<String> c = value['transactionComment']
              .toString()
              .replaceAll(RegExp(">|> "), "")
              .split("\n");
          c.removeLast();
          repliedMessage = c.join("\n");
        } else {
          repliedMessage = "";
        }
        chats.add(
          Chat(
            value['transactionPHID'] ?? "",
            _dateUtil.fromSeconds(int.parse(value['dateCreated'] ?? "")),
            value['transactionComment'] ?? value['transactionTitle'] ?? "",
            value['transactionType'] != "core:comment",
            value['roomPHID'] ?? "",
            sender: User(value['authorPHID'] ?? ""),
            htmlMessage: value['transactionTitle'] ?? "",
            quotedChat: QuotedChat(
              "",
              repliedMessage,
            ),
          ),
        );
      });
    }

    return chats;
  }
}
