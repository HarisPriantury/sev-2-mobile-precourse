import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class GetLobbyParticipantsApiRequest
    implements GetLobbyParticipantsRequestInterface, ApiRequestInterface {
  static const QUERY_IN_LOBBY = "lobby";
  static const QUERY_WORKING = "working";
  static const QUERY_BREAK = "break";
  static const QUERY_UNAVAILABLE = "unavailable";
  static const QUERY_ALL = "all";

  String? queryKey;
  List<String>? ids;
  List<String>? ownerIds;
  String? currentChannel;
  bool? isWorking;
  List<String>? breakStatuses;
  String? after;
  int? limit;

  GetLobbyParticipantsApiRequest({
    this.queryKey,
    this.ids,
    this.ownerIds,
    this.currentChannel,
    this.isWorking,
    this.breakStatuses,
    this.after,
    this.limit,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['constraints'] = {
      'phids': Map<dynamic, dynamic>(),
      'ownerPHIDs': Map<dynamic, dynamic>(),
      'isWorking': Map<dynamic, dynamic>(),
      'break': Map<dynamic, dynamic>(),
      'currentChannel': "",
    };

    if (!this.ids.isNullOrEmpty()) {
      var dataIds = Map<String, String>();
      var counter = 0;
      this.ids!.asMap().forEach((key, value) {
        if (!dataIds.containsValue(value.toString())) {
          dataIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['phids'] = dataIds;
    }

    if (!this.ownerIds.isNullOrEmpty()) {
      var dataOwnerIds = Map<String, String>();
      var counter = 0;
      this.ownerIds!.asMap().forEach((key, value) {
        if (!dataOwnerIds.containsValue(value.toString())) {
          dataOwnerIds[(counter++).toString()] = value;
        }
      });
      req['constraints']['ownerPHIDs'] = dataOwnerIds;
    }

    if (!this.breakStatuses.isNullOrEmpty()) {
      var dataBreakStatuses = Map<String, String>();
      var counter = 0;
      this.breakStatuses!.asMap().forEach((key, value) {
        if (!dataBreakStatuses.containsValue(value.toString())) {
          dataBreakStatuses[(counter++).toString()] = value;
        }
      });
      req['constraints']['break'] = dataBreakStatuses;
    }

    if (queryKey != null) req['queryKey'] = this.queryKey.toString();
    if (currentChannel != null)
      req['constraints']['currentChannel'] = this.currentChannel.toString();
    if (isWorking != null) req['isWorking'] = this.isWorking.toString();
    if (limit != null) req['limit'] = this.limit.toString();
    if (after != null) req['after'] = this.after.toString();

    return req;
  }
}
