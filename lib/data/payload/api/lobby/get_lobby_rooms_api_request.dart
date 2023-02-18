import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class GetLobbyRoomsApiRequest
    implements GetLobbyRoomsRequestInterface, ApiRequestInterface {
  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    return req;
  }
}
