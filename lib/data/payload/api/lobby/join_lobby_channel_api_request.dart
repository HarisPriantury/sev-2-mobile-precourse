import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class JoinLobbyChannelApiRequest
    implements JoinLobbyChannelRequestInterface, ApiRequestInterface {
  String channelId;

  JoinLobbyChannelApiRequest(this.channelId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['channelPHID'] = this.channelId;
    return req;
  }
}
