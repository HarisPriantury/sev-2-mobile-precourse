import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';

class SearchApiFeedsRequest
    implements SearchFeedsRequestInterface, ApiRequestInterface {
  String? query;
  String? filter; // can be: unread, ticket, chat, hiring

  SearchApiFeedsRequest({this.query, this.filter});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    return req;
  }
}
