import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';

class SearchFeedsDBRequest implements SearchFeedsRequestInterface {
  String query;

  SearchFeedsDBRequest(this.query);
}
