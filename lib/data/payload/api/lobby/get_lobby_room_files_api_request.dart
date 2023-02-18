import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class GetLobbyRoomFilesApiRequest
    implements GetLobbyRoomFilesRequestInterface, ApiRequestInterface {
  String roomId;

  GetLobbyRoomFilesApiRequest(this.roomId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['channelPHID'] = this.roomId;
    return req;
  }
}
