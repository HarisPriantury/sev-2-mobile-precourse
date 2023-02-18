import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';

class JoinEventApiRequest implements JoinEventRequestInterface, ApiRequestInterface {
  String id;
  bool willJoin;

  JoinEventApiRequest(this.id, this.willJoin);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['calendarPHID'] = this.id;
    req['action'] = willJoin ? 'accept' : 'decline';

    return req;
  }
}
