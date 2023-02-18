import 'dart:developer';

import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/feed.dart';
import 'package:mobile_sev2/domain/user.dart';

class FeedMapper {
  DateUtilInterface _dateUtil;

  FeedMapper(this._dateUtil);

  List<Feed> convertGetFeedsApiResponse(Map<String, dynamic> response) {
    List<Feed> feeds = [];
    var data = response['result'];
    if (data != null) {
      data.forEach((value) {
        feeds.add(
          Feed(
            value['phid'],
            User(
              value['author']['phid'],
              avatar: value['author']['profileImageURI'],
            ),
            value['message']['text'],
            _dateUtil.fromMilliseconds(value['dateCreated'] * 1000),
            chronoKey: value['chronologicalKey'],
            objectPHID: value['objectPHID'],
          ),
        );
      });
    }
    return feeds;
  }
}
