import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';

class GetSearchHistoryDBRequest implements GetSearchHistoryRequestInterface {
  String workspace;

  GetSearchHistoryDBRequest(this.workspace);
}