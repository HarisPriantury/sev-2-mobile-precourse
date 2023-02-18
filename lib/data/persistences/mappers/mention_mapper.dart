import 'dart:developer';

import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/feed.dart';
import 'package:mobile_sev2/domain/mention.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

class MentionMapper {
  DateUtilInterface _dateUtil;

  MentionMapper(this._dateUtil);

  List<Mention> convertGetMentionsApiResponse(Map<String, dynamic> response) {
    List<Mention> mentions = [];
    var data = response['result']['data'];
    if (data != null) {
      data.forEach((value) {
        List<User> mentionedUser = [];
        for (var user in value['fields']['mentionedUsers']) {
          mentionedUser.add(
            User(
              user['userPHID'],
              name: user['userName'],
              fullName: user['realName'],
              avatar: user['profileImageURI'],
            ),
          );
        }
        mentions.add(
          Mention(
            value['phid'],
            User(
              value['fields']['creator']['userPHID'],
              name: value['fields']['creator']['userName'],
              fullName: value['fields']['creator']['realName'],
              avatar: value['fields']['creator']['profileImageURI'],
            ),
            value['fields']['message']['text'],
            _dateUtil.fromMilliseconds(value['fields']['dateCreated'] * 1000),
            object: PhObject(
              value['fields']['object']['phid'],
              name: value['fields']['object']['title'],
            ),
            intId: value['id'],
            mentionedUsers: mentionedUser,
          ),
        );
      });
    }
    return mentions;
  }
}
