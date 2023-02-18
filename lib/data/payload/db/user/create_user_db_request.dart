import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';

class CreateUserDBRequest implements CreateUserRequestInterface {
  User user;

  CreateUserDBRequest(this.user);
}
