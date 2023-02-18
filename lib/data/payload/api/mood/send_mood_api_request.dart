import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/mood_request_interface.dart';

class SendMoodApiRequest implements SendMoodRequestInterface, ApiRequestInterface {
  String mood;
  String? message;

  SendMoodApiRequest({
    required this.mood,
    this.message,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['mood'] = mood;
    req['message'] = message;
    return req;
  }
}
