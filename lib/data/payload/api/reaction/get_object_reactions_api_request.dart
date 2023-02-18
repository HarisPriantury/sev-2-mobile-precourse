import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetObjectReactionsApiRequest implements GetObjectReactionsRequestInterface, ApiRequestInterface {
  List<String>? ids;
  List<String>? authorIds;
  List<String>? objectIds;

  GetObjectReactionsApiRequest({
    this.ids,
    this.authorIds,
    this.objectIds,
  });

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
      req['tokenPHIDs'] = dataIds;
    }

    if (!this.authorIds.isNullOrEmpty()) {
      var dataAuthorIds = Map<String, String>();
      var counter = 0;
      this.authorIds!.asMap().forEach((key, value) {
        if (!dataAuthorIds.containsValue(value.toString())) {
          dataAuthorIds[(counter++).toString()] = value;
        }
      });
      req['authorPHIDs'] = dataAuthorIds;
    }

    if (!this.objectIds.isNullOrEmpty()) {
      var dataObjectIds = Map<String, String>();
      var counter = 0;
      this.objectIds!.asMap().forEach((key, value) {
        if (!dataObjectIds.containsValue(value.toString())) {
          dataObjectIds[(counter++).toString()] = value;
        }
      });
      req['objectPHIDs'] = dataObjectIds;
    }

    return req;
  }
}
