import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';

class UpdateStatusApiRequest
    implements UpdateStatusRequestInterface, ApiRequestInterface {
  static const STATUS_IN_LOBBY = "1";
  static const STATUS_IN_CHANNEL = "2";
  static const STATUS_BREAK_BATHROOM = "3";
  static const STATUS_BREAK_LUNCH = "4";
  static const STATUS_BREAK_ME_TIME = "5";
  static const STATUS_BREAK_FAMILY = "6";
  static const STATUS_BREAK_PRAY = "7";
  static const STATUS_BREAK_OTHER = "8";

  String status;

  UpdateStatusApiRequest(this.status);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['status'] = this.status;
    return req;
  }
}
