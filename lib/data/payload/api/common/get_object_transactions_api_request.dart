import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetObjectTransactionsApiRequest implements GetObjectTransactionsRequestInterface, ApiRequestInterface {
  String? identifier;
  String? type;
  List<String>? ids;
  List<String>? authorIds;
  int? limit;
  String? after;

  GetObjectTransactionsApiRequest({
    this.identifier,
    this.type,
    this.ids,
    this.authorIds,
    this.limit,
    this.after,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['constraints'] = {'authorPHIDs': Map<dynamic, dynamic>(), 'phids': Map<dynamic, dynamic>()};

    var dataIds = Map<String, String>();
    var counter = 0;
    if (!this.ids.isNullOrEmpty()) {
      this.ids!.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['phids'] = dataIds;
    }

    var dataAuthorIds = Map<String, String>();
    counter = 0;
    if (!this.authorIds.isNullOrEmpty()) {
      this.authorIds!.asMap().forEach((key, value) {
        if (!dataAuthorIds.containsValue(value.toString())) {
          dataAuthorIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['phids'] = dataAuthorIds;
    }

    if (identifier != null) req['objectIdentifier'] = this.identifier;
    if (type != null) req['objectType'] = this.type;
    if (limit != null) req['limit'] = this.limit;
    if (after != null && after != "0") req['after'] = this.after;

    return req;
  }
}
