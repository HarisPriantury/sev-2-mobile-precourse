import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';

class GetSuiteProfileApiRequest
    implements GetSuiteProfileRequestInterface, ApiRequestInterface {
  String id;

  GetSuiteProfileApiRequest(this.id);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['userPHID'] = this.id;
    return req;
  }
}
