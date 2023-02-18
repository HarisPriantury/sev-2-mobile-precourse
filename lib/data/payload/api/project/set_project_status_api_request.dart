import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class SetProjectStatusApiRequest
    implements SetProjectStatusRequestInterface, ApiRequestInterface {
  static const String STATUS_ACTIVE = "active";
  static const String STATUS_ARCHIVE = "archive";

  String projectId;
  String status;

  SetProjectStatusApiRequest(
    this.projectId,
    this.status,
  );

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    req['projectPHID'] = this.projectId;
    req['status'] = this.status;

    return req;
  }
}
