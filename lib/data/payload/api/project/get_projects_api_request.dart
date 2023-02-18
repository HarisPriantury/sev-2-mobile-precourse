import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetProjectsApiRequest
    implements GetProjectsRequestInterface, ApiRequestInterface {
  static const QUERY_JOINED = "joined";
  static const QUERY_ACTIVE = "active";
  static const QUERY_ALL = "all";

  List<String>? ids = [];
  List<String>? members = [];
  List<String>? parents = [];
  String? nameLike;
  int? limit;
  String? after;
  bool membersAttached;
  String? queryKey;

  GetProjectsApiRequest({
    this.ids,
    this.members,
    this.parents,
    this.nameLike,
    this.membersAttached = false,
    this.limit,
    this.after,
    this.queryKey,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    req['constraints'] = {
      'phids': Map<dynamic, dynamic>(),
      'members': Map<dynamic, dynamic>(),
      'parents': Map<dynamic, dynamic>(),
      'nameLike': this.nameLike,
    };

    req['attachments'] = {
      'members': membersAttached,
    };

    if (limit != null) req['limit'] = this.limit.toString();
    if (after != null && after != "0") req['after'] = this.after;

    if (!this.ids.isNullOrEmpty()) {
      var dataIds = Map<String, String>();
      var counter = 0;
      this.ids?.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['phids'] = dataIds;
    }

    if (!this.members.isNullOrEmpty()) {
      var dataMembers = Map<String, String>();
      var counter = 0;
      this.members?.asMap().forEach((key, value) {
        if (!dataMembers.containsValue(value.toString())) {
          dataMembers[(counter++).toString()] = value;
        }
      });
      req['constraints']['members'] = dataMembers;
    }

    if (!this.parents.isNullOrEmpty()) {
      var dataParents = Map<String, String>();
      var counter = 0;
      this.parents?.asMap().forEach((key, value) {
        if (!dataParents.containsValue(value.toString())) {
          dataParents[(counter++).toString()] = value;
        }
      });
      req['constraints']['parents'] = dataParents;
    }

    if (this.queryKey != null) req['queryKey'] = this.queryKey;
    return req;
  }
}
