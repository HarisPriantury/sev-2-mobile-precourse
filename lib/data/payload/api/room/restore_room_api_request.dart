import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class RestoreRoomApiRequesst
    implements RestoreRoomRequestInterface, ApiRequestInterface {
  String roomId;
  RestoreRoomApiRequesst(this.roomId);
  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['phid'] = this.roomId;
    print("RestoreRoomApiRequesst : $req");
    return req;
  }
}
