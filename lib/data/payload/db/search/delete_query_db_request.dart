import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/domain/query.dart';

class DeleteQueryDBRequest implements DeleteQueryRequestInterface {
  Query query;

  DeleteQueryDBRequest(this.query);
}
