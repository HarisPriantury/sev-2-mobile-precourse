import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';

class DeleteFlagApiRequest
    implements DeleteFlagRequestInterface, ApiRequestInterface {
  int? flagId;
  String objectPHID;

  DeleteFlagApiRequest({required this.objectPHID, this.flagId});

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    if (flagId != null) {
      req['id'] = flagId;
    }
    req['objectPHID'] = objectPHID;

    return req;
  }
}
