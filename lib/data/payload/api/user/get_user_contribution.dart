import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';

class GetUserContributionsApiRequest implements GetUserContributionsRequestInterface, ApiRequestInterface {
  String? userPHID;

  GetUserContributionsApiRequest({this.userPHID});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    if (this.userPHID != null) {
      req['userPHID'] = this.userPHID;
    }
    return req;
  }
}
