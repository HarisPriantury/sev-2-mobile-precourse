import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class GetProjectColumnTicketApiRequest implements GetProjectColumnTicketRequestInterface, ApiRequestInterface {
  String projectId;

  GetProjectColumnTicketApiRequest(this.projectId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['projectPHID'] = this.projectId;

    return req;
  }
}
