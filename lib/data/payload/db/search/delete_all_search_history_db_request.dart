import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';

class DeleteAllSearchHistoryDBRequest implements DeleteAllSearchHistoryRequestInterface {
  String workspace;

  DeleteAllSearchHistoryDBRequest(this.workspace);
}