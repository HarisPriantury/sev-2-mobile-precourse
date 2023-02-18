import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';

class GetTicketsApiRequest implements GetTicketsRequestInterface, ApiRequestInterface {
  static const QUERY_ASSIGNED = "assigned";
  static const QUERY_AUTHORED = "authored";
  static const QUERY_OPEN = "open";
  static const QUERY_ALL = "all";

  String? queryKey;
  List<String>? projects = [];
  List<String>? statuses = [];
  List<String>? subscribers = [];
  List<String>? assigned = [];
  List<String>? authors = [];
  List<int>? ids;
  List<String>? phids;
  int? limit;
  String? after;
  String? query;
  int? closedStart;
  int? closedEnd;

  GetTicketsApiRequest({
    this.queryKey,
    this.projects,
    this.statuses,
    this.subscribers,
    this.assigned,
    this.authors,
    this.ids,
    this.phids,
    this.limit,
    this.after,
    this.query,
    this.closedStart,
    this.closedEnd,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    String _query = query ?? '';
    String _idLike = '';
    String _titleLike = '';
    if (_query.isNotEmpty) {
      RegExp regExp = RegExp(r"[T-t][0-9]+");
      if (regExp.hasMatch(_query)) {
        _idLike = _query.substring(1);
      } else {
        _titleLike = _query;
      }
    }
    if (this.queryKey == null) this.queryKey = QUERY_ASSIGNED;
    req['queryKey'] = this.queryKey;

    req['attachments'] = {'projects': true, 'columns': true, 'subscribers': true};
    req['constraints'] = {
      'statuses': Map<dynamic, dynamic>(),
      'projects': Map<dynamic, dynamic>(),
      'subscribers': Map<dynamic, dynamic>(),
      'assigned': Map<dynamic, dynamic>(),
      'authorPHIDs': Map<dynamic, dynamic>(),
      'idLike': _idLike,
      'titleLike': _titleLike,
    };
    if (!this.statuses.isNullOrEmpty()) {
      var dataStatuses = Map<String, String>();
      var counter = 0;
      this.statuses?.asMap().forEach((key, value) {
        if (!dataStatuses.containsValue(value.toString())) {
          dataStatuses[(counter++).toString()] = value;
        }
      });
      req['constraints']['statuses'] = dataStatuses;
    }

    if (!this.projects.isNullOrEmpty()) {
      var dataProjects = new Map<String, String>();
      var counter = 0;
      this.projects?.asMap().forEach((key, value) {
        if (!dataProjects.containsValue(value.toString())) {
          dataProjects[(counter++).toString()] = value;
        }
      });
      req['constraints']['projects'] = dataProjects;
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

    if (!this.assigned.isNullOrEmpty()) {
      var dataAssignee = Map<String, String>();
      var counter = 0;
      this.assigned?.asMap().forEach((key, value) {
        if (!dataAssignee.containsValue(value.toString())) {
          dataAssignee[(counter++).toString()] = value;
        }
      });
      req['constraints']['assigned'] = dataAssignee;
    }

    if (!this.authors.isNullOrEmpty()) {
      var dataAuthors = Map<String, String>();
      var counter = 0;
      this.authors?.asMap().forEach((key, value) {
        if (!dataAuthors.containsValue(value.toString())) {
          dataAuthors[(counter++).toString()] = value;
        }
      });
      req['constraints']['authorPHIDs'] = dataAuthors;
    }

    if (limit != null) req['limit'] = this.limit;
    if (after != null && after != "0") req['after'] = this.after;

    if (this.closedStart != null) {
      req['constraints']['closedStart'] = this.closedStart;
    }
    if (this.closedEnd != null) {
      req['constraints']['closedEnd'] = this.closedEnd;
    }
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
