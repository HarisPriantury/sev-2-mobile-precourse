import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/wiki_request_interface.dart';

class GetWikisApiRequest
    implements GetWikisRequestInterface, ApiRequestInterface {
  GetWikisApiRequest({
    this.limit,
    this.after,
  });

  String? after;
  int? limit;

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    if (limit != null) req['limit'] = this.limit.toString();
    if (after != null && after != "0") req['after'] = this.after;
    req['attachments'] = {'content': true};
    return req;
  }
}
