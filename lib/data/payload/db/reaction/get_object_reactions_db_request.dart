import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';

class GetObjectReactionsDBRequest
    implements GetObjectReactionsRequestInterface {
  String objectId;

  GetObjectReactionsDBRequest(this.objectId);
}
