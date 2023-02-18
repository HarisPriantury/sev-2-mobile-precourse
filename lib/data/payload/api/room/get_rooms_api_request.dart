import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetRoomsApiRequest
    implements GetRoomsRequestInterface, ApiRequestInterface {
  List<String>? ids;
  int? limit;
  int? offset;

  GetRoomsApiRequest({this.ids, this.limit, this.offset});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['isDeleted'] = 0;
    if (!this.ids.isNullOrEmpty()) {
      var dataIds = Map<String, String>();
      var counter = 0;
      this.ids?.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['phids'] = dataIds;
    }

    if (limit != null) req['limit'] = this.limit.toString();
    if (offset != null) req['offset'] = this.offset.toString();

    return req;
  }
}
