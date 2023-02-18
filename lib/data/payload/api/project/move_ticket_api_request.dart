import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class MoveTicketApiRequest implements MoveTicketRequestInterface, ApiRequestInterface {
  String projectId;
  String columnId;
  List<String> ticketId;

  MoveTicketApiRequest(
    this.projectId,
    this.columnId,
    this.ticketId,
  );

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    req['projectPHID'] = this.projectId;
    req['columnPHID'] = this.columnId;
    if (this.ticketId.length > 1) {
      var tasks = Map<String, String>();
      var counter = 0;
      this.ticketId.asMap().forEach((key, value) {
        if (!tasks.containsValue(value.toString())) {
          tasks[(counter++).toString()] = value;
        }
      });
      req['taskPHID'] = tasks;
    } else {
      req['taskPHID'] = this.ticketId.first;
    }
    return req;
  }
}
