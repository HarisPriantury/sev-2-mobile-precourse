import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';

class RegisterApiRequest implements RegisterRequestInterface, ApiRequestInterface {
  String username;
  String realname;
  String email;
  String password;
  String confirmPassword;

  RegisterApiRequest(
    this.username,
    this.realname,
    this.email,
    this.password,
    this.confirmPassword,
  );

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['username'] = this.username;
    req['realname'] = this.realname;
    req['email'] = this.email;
    req['password'] = this.password;
    req['confirmPassword'] = this.confirmPassword;

    return req;
  }
}
