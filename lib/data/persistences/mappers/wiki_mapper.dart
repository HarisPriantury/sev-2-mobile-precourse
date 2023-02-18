import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/wiki.dart';

class WikiMapper {
  WikiMapper(this._dateUtil);

  DateUtilInterface _dateUtil;

  List<Wiki> convertGetWikisApiResponse(Map<String, dynamic> response) {
    var wikis = List<Wiki>.empty(growable: true);

    if (response['result'] == null) return wikis;
    var data = response['result']['data'];

    for (var wiki in data) {
      var field = wiki['fields'];
      var attachment = wiki['attachments']['content'];
      var w = Wiki(
        wiki['phid'],
        author: User(attachment['authorPHID']),
        createdAt: _dateUtil.fromSeconds(field['dateCreated']),
        description: attachment['content']['raw'],
        documentPHID: field['documentPHID'],
        idInt: wiki['id'],
        title: attachment['title'].toString().replaceAll("-", " "),
      );
      wikis.add(w);
    }
    return wikis;
  }
}
