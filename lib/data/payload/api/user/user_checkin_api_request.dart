import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';

class UserCheckinApiRequest
    implements UserCheckinRequestInterface, ApiRequestInterface {
  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    return req;
  }
}
