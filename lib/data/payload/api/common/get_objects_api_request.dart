import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';

class GetObjectsApiRequest
    implements GetObjectsRequestInterface, ApiRequestInterface {
  List<String> ids;

  GetObjectsApiRequest(this.ids);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    var dataIds = Map<String, String>();
    var counter = 0;
    this.ids.asMap().forEach((key, value) {
      if (!dataIds.containsValue(value.toString())) {
        dataIds[(counter++).toString()] = value;
      }
    });

    req['phids'] = dataIds;

    return req;
  }
}
