import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';

class LoginApiRequest implements LoginRequestInterface, ApiRequestInterface {
  String username;
  String password;

  LoginApiRequest(this.username, this.password);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['username'] = this.username;
    req['password'] = this.password;

    return req;
  }

}