import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';

class CreateFlagApiRequest
    implements CreateFlagRequestInterface, ApiRequestInterface {
  String objectPHID;
  int? color;
  String? note;

  CreateFlagApiRequest({
    required this.objectPHID,
    this.color,
    this.note,
  });

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    req['objectPHID'] = objectPHID;

    if (color != null) {
      req['color'] = color;
    }

    if (note != null) {
      req['note'] = note;
    }
    print("CreateFlagApiRequest, $req");
    return req;
  }
}
