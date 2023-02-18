import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/stickit_request_interface.dart';

class GetStickitsApiRequest
    implements GetStickitRequestInterface, ApiRequestInterface {
  static const QUERY_ALL = "all";

  String? queryKey;
  List<int>? ids;
  List<String>? phids;
  bool? attachments;
  String? order;
  String? before;
  String? after;
  int? limit;

  GetStickitsApiRequest({
    this.queryKey,
    this.ids,
    this.phids,
    this.limit,
    this.after,
    this.attachments,
    this.before,
    this.order,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    if (this.queryKey == null) this.queryKey = QUERY_ALL;
    req['queryKey'] = this.queryKey;

    req['constraints'] = {
      'phids': Map<dynamic, dynamic>(),
    };

    if (limit != null) req['limit'] = this.limit;
    if (after != null && after != "0") req['after'] = this.after;

    if (this.ids != null && this.ids!.isNotEmpty) {
      var dataIds = Map<String, int>();
      var counter = 0;
      this.ids?.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['ids'] = dataIds;
    }

    if (this.phids != null && this.phids!.isNotEmpty) {
      var dataIds = Map<String, String>();
      var counter = 0;
      this.phids?.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['phids'] = dataIds;
    }

    return req;
  }
}
