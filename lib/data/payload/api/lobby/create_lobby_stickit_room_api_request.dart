import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class CreateLobbyRoomStickitApiRequest implements CreateLobbyRoomStickitRequestInterface, ApiRequestInterface {
  String? objectIdentifier;
  String? noteType;
  String? title;
  String? content;
  List<String>? addedRoomIds;
  List<String>? removedRoomIds;
  List<String>? setRoomIds;
  String? comment;

  CreateLobbyRoomStickitApiRequest({
    this.objectIdentifier,
    this.noteType,
    this.title,
    this.content,
    this.addedRoomIds,
    this.removedRoomIds,
    this.setRoomIds,
    this.comment,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();
    var transactions = List<Map<dynamic, dynamic>>.empty(growable: true);

    if (noteType != null) {
      transactions.add({'type': 'noteType', 'value': noteType});
    }

    if (title != null) {
      transactions.add({'type': 'title', 'value': title});
    }

    if (content != null) {
      transactions.add({'type': 'content', 'value': content});
    }

    if (comment != null) {
      transactions.add({'type': 'comment', 'value': comment});
    }

    if (addedRoomIds != null) {
      if (!this.addedRoomIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.addedRoomIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'conpherence.add', 'value': dataIds});
      }
    }

    if (removedRoomIds != null) {
      if (!this.removedRoomIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.removedRoomIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'conpherence.remove', 'value': dataIds});
      }
    }

    if (setRoomIds != null) {
      if (!this.setRoomIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.setRoomIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'conpherence.set', 'value': dataIds});
      }
    }

    if (objectIdentifier != null) {
      req['objectIdentifier'] = objectIdentifier;
    }

    req['transactions'] = transactions;

    return req;
  }
}
