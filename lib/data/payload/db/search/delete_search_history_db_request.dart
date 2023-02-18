import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/domain/meta/search_history.dart';

class DeleteSearchHistoryDBRequest implements DeleteSearchHistoryRequestInterface {
  SearchHistory history;

  DeleteSearchHistoryDBRequest(this.history);
}