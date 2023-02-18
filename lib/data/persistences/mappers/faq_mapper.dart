import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/faq.dart';

class FaqMapper {
  late DateUtilInterface _dateUtil;

  FaqMapper(this._dateUtil);

  List<Faq> convertGetFaqsApiResponse(Map<String, dynamic> response) {
    var faqs = List<Faq>.empty(growable: true);

    var data = response['result']['data'];
    for (var f in data) {
      faqs.add(
        Faq(
          f['phid'],
          f['fields']['title'],
          f['fields']['content'],
          f['fields']['answerSummary'],
          f['fields']['status'],
          _dateUtil.fromMilliseconds(f['fields']['dateModified']),
        ),
      );
    }
    return faqs;
  }
}
