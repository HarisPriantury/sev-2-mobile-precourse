import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';

class GetFlagsApiRequest
    implements GetFlagsRequestInterface, ApiRequestInterface {
  List<String>? ownerPHIDs;
  List<String>? types;
  List<String>? objectPHIDs;
  int? offset;
  int? limit;

  GetFlagsApiRequest({
    this.ownerPHIDs,
    this.types,
    this.objectPHIDs,
    this.offset,
    this.limit,
  });

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();

    if (this.ownerPHIDs != null && this.ownerPHIDs!.isNotEmpty) {
      var dataOwnerPHIDs = Map<String, String>();
      var counter = 0;
      this.ownerPHIDs?.asMap().forEach((key, value) {
        if (!dataOwnerPHIDs.containsValue(value.toString())) {
          dataOwnerPHIDs[(counter++).toString()] = value;
        }
      });
      req['ownerPHIDs'] = dataOwnerPHIDs;
    }

    if (this.types != null && this.types!.isNotEmpty) {
      var dataTypes = Map<String, String>();
      var counter = 0;
      this.types?.asMap().forEach((key, value) {
        if (!dataTypes.containsValue(value.toString())) {
          dataTypes[(counter++).toString()] = value;
        }
      });
      req['types'] = dataTypes;
    }

    if (this.objectPHIDs != null && this.objectPHIDs!.isNotEmpty) {
      var dataObjectPHIDs = Map<String, String>();
      var counter = 0;
      this.objectPHIDs?.asMap().forEach((key, value) {
        if (!dataObjectPHIDs.containsValue(value.toString())) {
          dataObjectPHIDs[(counter++).toString()] = value;
        }
      });
      req['objectPHIDs'] = dataObjectPHIDs;
    }

    if (limit != null) req['limit'] = this.limit;
    if (offset != null) req['offset'] = this.offset;
    return req;
  }
}
