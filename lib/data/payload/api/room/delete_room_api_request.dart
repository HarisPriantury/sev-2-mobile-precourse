import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class DeleteRoomApiRequest implements DeleteRoomRequestInterface, ApiRequestInterface {
  String roomId;

  DeleteRoomApiRequest(this.roomId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req["phid"] = this.roomId;
    return req;
  }
}
