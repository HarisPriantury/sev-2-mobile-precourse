import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class SetAsReadStickitApiRequest implements SetAsReadStickitRequestInterface, ApiRequestInterface {
  String stickitPHID;
  SetAsReadStickitApiRequest(this.stickitPHID);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['stickitPHID'] = this.stickitPHID;
    return req;
  }
}
