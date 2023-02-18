import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/faq_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetFaqsApiRequest implements GetFaqsRequestInterface, ApiRequestInterface {
  String? queryKey;
  List<String>? projectIds;
  List<String>? spaceIds;
  int? limit;
  String? after;

  GetFaqsApiRequest({
    this.queryKey,
    this.projectIds = const ["PHID-PROJ-7gy3rht6b4y5i4h7muwr"],
    this.spaceIds,
    this.limit,
    this.after,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['constraints'] = {'projects': Map<dynamic, dynamic>(), 'spaces': Map<dynamic, dynamic>()};

    var dataProjectIds = Map<String, String>();
    var counter = 0;
    if (!this.projectIds.isNullOrEmpty()) {
      this.projectIds!.asMap().forEach((key, value) {
        if (!dataProjectIds.containsValue(value.toString())) {
          dataProjectIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['projects'] = dataProjectIds;
    }

    var dataSpaceIds = Map<String, String>();
    counter = 0;
    if (!this.spaceIds.isNullOrEmpty()) {
      this.spaceIds!.asMap().forEach((key, value) {
        if (!dataSpaceIds.containsValue(value.toString())) {
          dataSpaceIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['spaces'] = dataSpaceIds;
    }

    if (queryKey != null) req['queryKey'] = this.queryKey;
    if (limit != null) req['limit'] = this.limit;
    if (after != null && after != "0") req['after'] = this.after;

    return req;
  }
}
