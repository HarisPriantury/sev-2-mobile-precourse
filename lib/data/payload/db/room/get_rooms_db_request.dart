import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';

class GetRoomsDBRequest implements GetRoomsRequestInterface {
  String workspaceId;

  GetRoomsDBRequest(this.workspaceId);
}
