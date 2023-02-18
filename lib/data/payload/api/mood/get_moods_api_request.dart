import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/mood_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetMoodsApiRequest
    implements GetMoodsRequestInterface, ApiRequestInterface {
  int? startDate;
  List<String>? userPHIDs;

  GetMoodsApiRequest(this.startDate, this.userPHIDs);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    if (this.startDate != null) {
      req['constraints'] = {
        "startDate": startDate,
        'userPHIDs': Map<dynamic, dynamic>(),
      };
    }
    if (!this.userPHIDs.isNullOrEmpty()) {
      var userPHIDs = Map<String, String>();
      var counter = 0;
      this.userPHIDs?.asMap().forEach((key, value) {
        if (!userPHIDs.containsValue(value.toString())) {
          userPHIDs[(counter++).toString()] = value;
        }
      });
      req['constraints']['userPHIDs'] = userPHIDs;
    }
    return req;
  }
}
