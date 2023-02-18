import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class WorkOnTaskApiRequest
    implements WorkOnTaskRequestInterface, ApiRequestInterface {
  String taskId;

  WorkOnTaskApiRequest(this.taskId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['task'] = this.taskId;
    return req;
  }
}
