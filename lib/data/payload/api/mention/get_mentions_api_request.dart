import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/mention_request_interface.dart';

class GetMentionsApiRequest
    implements GetMentionsRequestInterface, ApiRequestInterface {
  String queryKey;
  List<String>? ids;
  int? limit;
  int? after;
  int? before;

  GetMentionsApiRequest({
    this.queryKey = "mentioned",
    this.ids,
    this.limit = 10,
    this.after,
    this.before,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['queryKey'] = this.queryKey;
    if (ids != null) req['phids'] = this.ids;
    if (limit != null) req['limit'] = this.limit;
    if (after != null && after != 0) req['after'] = this.after.toString();
    if (before != null) req['before'] = this.before.toString();

    return req;
  }
}
