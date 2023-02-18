import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetEmbracesApiRequest implements GetEmbracesRequestInterface, ApiRequestInterface {
  List<String>? ids;
  int? limit;
  String? after;

  GetEmbracesApiRequest({this.ids, this.limit, this.after});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    if (!this.ids.isNullOrEmpty()) {
      var dataIds = Map<String, String>();
      var counter = 0;
      this.ids!.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['phids'] = dataIds;
    }

    if (limit != null) req['limit'] = this.limit;
    if (after != null && after != "0") req['after'] = this.after;

    return req;
  }
}
