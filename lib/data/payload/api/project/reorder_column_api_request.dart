import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class ReorderColumnApiRequest implements ReorderColumnRequestInterface, ApiRequestInterface {
  String projectId;
  String columnId;
  String sequenceNo;
  ReorderColumnApiRequest(
    this.projectId,
    this.columnId,
    this.sequenceNo,
  );
  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    req['projectPHID'] = this.projectId;
    req['columnPHID'] = this.columnId;
    req['sequence'] = this.sequenceNo;

    return req;
  }
}
