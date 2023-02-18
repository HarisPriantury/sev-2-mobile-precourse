import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';

class StoreUserListDbRequest implements StoreListUserDbRequestInterface {
  Map<String, User> newListUsers = {};

  StoreUserListDbRequest(this.newListUsers);
}
