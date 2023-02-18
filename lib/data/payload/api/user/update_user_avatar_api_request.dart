import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';

class UpdateAvatarUserApiRequest implements UpdateAvatarUserRequestInterface, ApiRequestInterface {
  String dataBase64;
  UpdateAvatarUserApiRequest(this.dataBase64);
  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['data_base64'] = this.dataBase64;
    return req;
  }
}
