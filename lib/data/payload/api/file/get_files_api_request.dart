import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetFilesApiRequest
    implements GetFilesRequestInterface, ApiRequestInterface {
  List<int>? ids = [];
  List<String>? phids = [];
  List<String>? authorIds = [];
  List<String>? subscribers = [];
  int? limit;
  int? offset;
  String? after;
  String? nameLike;

  GetFilesApiRequest({
    this.ids,
    this.phids,
    this.authorIds,
    this.subscribers,
    this.limit,
    this.offset,
    this.after,
    this.nameLike,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['constraints'] = {
      'ids': Map<dynamic, dynamic>(),
      'phids': Map<dynamic, dynamic>(),
      'authorPHIDs': Map<dynamic, dynamic>(),
      'subscribers': Map<dynamic, dynamic>(),
      'name': this.nameLike,
    };

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

    if (!this.phids.isNullOrEmpty()) {
      var dataPhids = Map<String, String>();
      var counter = 0;
      this.phids?.asMap().forEach((key, value) {
        if (!dataPhids.containsValue(value.toString())) {
          dataPhids[(counter++).toString()] = value;
        }
      });
      req['constraints']['phids'] = dataPhids;
    }

    if (!this.authorIds.isNullOrEmpty()) {
      var dataAuthorIds = Map<String, String>();
      var counter = 0;
      this.authorIds?.asMap().forEach((key, value) {
        if (!dataAuthorIds.containsValue(value.toString())) {
          dataAuthorIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['authorPHIDs'] = dataAuthorIds;
    }

    if (!this.subscribers.isNullOrEmpty()) {
      var dataSubscribers = Map<String, String>();
      var counter = 0;
      this.subscribers?.asMap().forEach((key, value) {
        if (!dataSubscribers.containsValue(value.toString())) {
          dataSubscribers[(counter++).toString()] = value;
        }
      });
      req['constraints']['subscribers'] = dataSubscribers;
    }

    if (limit != null) req['limit'] = this.limit.toString();
    if (offset != null) req['offset'] = this.offset.toString();
    if (after != null && after != "0") req['after'] = this.after;

    return req;
  }
}
