import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';

class GetQueryDBRequest implements GetQueryRequestInterface {
  String workspace;

  GetQueryDBRequest(this.workspace);
}
