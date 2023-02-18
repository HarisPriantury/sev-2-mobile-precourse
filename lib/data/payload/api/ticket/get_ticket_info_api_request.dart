import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';

class GetTicketInfoApiRequest implements GetTicketInfoRequestInterface, ApiRequestInterface {
  String intId;

  GetTicketInfoApiRequest(this.intId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['task_id'] = this.intId;
    return req;
  }
}
