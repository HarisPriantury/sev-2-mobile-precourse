import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';

class GetProfileDBRequest implements GetProfileRequestInterface {
  String userId;

  GetProfileDBRequest(this.userId);
}
