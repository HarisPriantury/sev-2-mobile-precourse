import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class CreateColumnApiRequest implements CreateColumnRequestInterface, ApiRequestInterface {
  String projectId;
  String columnName;

  CreateColumnApiRequest(this.projectId, this.columnName);

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    req['projectPHID'] = this.projectId;
    req['name'] = this.columnName;

    return req;
  }
}
