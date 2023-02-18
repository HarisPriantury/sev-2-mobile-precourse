import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/mood.dart';

class MoodMapper {
  DateUtilInterface _dateUtil;

  MoodMapper(this._dateUtil);

  List<Mood> convertGetMoodApiResponse(Map<String, dynamic> response) {
    var moods = List<Mood>.empty(growable: true);

    var data = response['result']['data'];
    if (data != null) {
      data.forEach((value) {
        moods.add(Mood(
          value['phid'] ?? "",
          value['fields']['mood'],
          value['fields']['message'],
          _dateUtil.fromSeconds(value['fields']['dateCreated']),
        ));
      });
    }

    return moods;
  }
}
