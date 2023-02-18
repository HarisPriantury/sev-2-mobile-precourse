import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';

class GetEventsApiRequest implements GetEventsRequestInterface, ApiRequestInterface {
  List<int>? ids;
  List<String>? phids;
  List<String>? invitedPHIDs;
  List<String>? hostPHIDs;
  List<String>? subscribers;
  DateTime? startDate;
  DateTime? endDate;
  String? query;
  int? limit;
  String? after;

  GetEventsApiRequest({
    this.ids,
    this.phids,
    this.invitedPHIDs,
    this.hostPHIDs,
    this.subscribers,
    this.startDate,
    this.endDate,
    this.query,
    this.limit,
    this.after,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    String? _query;
    if (this.query != null) {
      _query = "~${this.query}";
    }

    req['constraints'] = {
      'phids': Map<dynamic, dynamic>(),
      'invitedPHIDs': Map<dynamic, dynamic>(),
      'hostPHIDs': Map<dynamic, dynamic>(),
      'subscribers': Map<dynamic, dynamic>(),
      'query': _query,
    };

    if (limit != null) req['limit'] = this.limit.toString();
    if (after != null && after != "0") req['after'] = this.after;

    // if (startDate != null) {
    //   req['constraints']['rangeDateAfter'] = this.startDate;
    // }
    //
    // if (endDate != null) {
    //   req['constraints']['rangeDateBefore'] = this.endDate;
    // }

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
      req['attachments'] = {'subscribers': true};
    }

    if (this.invitedPHIDs != null && this.invitedPHIDs!.isNotEmpty) {
      var dataInvitedIds = Map<String, String>();
      var counter = 0;
      this.invitedPHIDs?.asMap().forEach((key, value) {
        if (!dataInvitedIds.containsValue(value.toString())) {
          dataInvitedIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['invitedPHIDs'] = dataInvitedIds;
    }

    if (this.hostPHIDs != null && this.hostPHIDs!.isNotEmpty) {
      var dataHostPHIDs = Map<String, String>();
      var counter = 0;
      this.hostPHIDs?.asMap().forEach((key, value) {
        if (!dataHostPHIDs.containsValue(value.toString())) {
          dataHostPHIDs[(counter++).toString()] = value;
        }
      });
      req['constraints']['hostPHIDs'] = dataHostPHIDs;
    }

    if (this.subscribers != null && this.subscribers!.isNotEmpty) {
      var dataSubscribers = Map<String, String>();
      var counter = 0;
      this.subscribers?.asMap().forEach((key, value) {
        if (!dataSubscribers.containsValue(value.toString())) {
          dataSubscribers[(counter++).toString()] = value;
        }
      });
      req['constraints']['subscribers'] = dataSubscribers;
    }

    if (startDate != null) {
      req['constraints']['rangeDateAfter'] = (this.startDate!.toEpoch());
    }

    if (endDate != null) {
      req['constraints']['rangeDateBefore'] = (this.endDate!.toEpoch());
    }
    return req;
  }
}
