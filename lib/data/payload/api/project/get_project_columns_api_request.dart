import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class GetProjectColumnsApiRequest implements GetProjectColumnsRequestInterface, ApiRequestInterface {
  String projectId;

  GetProjectColumnsApiRequest(this.projectId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    var projectIds = Map<String, String>();
    projectIds['0'] = this.projectId;

    req['constraints'] = {
      'projects': projectIds,
    };

    return req;
  }
}
