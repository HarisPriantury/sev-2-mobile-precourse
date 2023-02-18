import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';

class GetFeedsApiRequest
    implements GetFeedsRequestInterface, ApiRequestInterface {
  List<String>? ids;
  int? limit;
  String? after;
  String? before;

  GetFeedsApiRequest({
    this.ids,
    this.limit = 10,
    this.after,
    this.before,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    if (ids != null) req['phids'] = this.ids;
    if (limit != null) req['limit'] = this.limit;
    if (after != null && after != "0") req['after'] = this.after;
    if (before != null) req['before'] = this.before;

    return req;
  }
}
