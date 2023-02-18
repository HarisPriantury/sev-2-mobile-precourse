import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/domain/query.dart';

class AddQueryDBRequest implements AddQueryRequestInterface {
  Query query;

  AddQueryDBRequest(this.query);
}
