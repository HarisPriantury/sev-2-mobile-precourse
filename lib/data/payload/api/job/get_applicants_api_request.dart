import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/job_request_interface.dart';

class GetApplicantsApiRequest
    implements GetApplicantsRequestInterface, ApiRequestInterface {
  String id;

  GetApplicantsApiRequest(this.id);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['projectPHID'] = this.id;
    return req;
  }
}
