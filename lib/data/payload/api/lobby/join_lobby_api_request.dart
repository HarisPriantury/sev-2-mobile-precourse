import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class JoinLobbyApiRequest
    implements JoinLobbyRequestInterface, ApiRequestInterface {
  String? device;
  bool? resetTask;

  JoinLobbyApiRequest({this.device = "phone", this.resetTask});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['device'] = this.device;
    if (this.resetTask != null) req['reset_task'] = this.resetTask;
    return req;
  }
}
