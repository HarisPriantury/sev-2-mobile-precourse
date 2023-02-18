import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class CreateEventApiRequest
    implements CreateEventRequestInterface, ApiRequestInterface {
  String? objectIdentifier;
  String? space;
  String? name;
  bool? isAllDay;
  bool? isForDev;
  int? start;
  int? end;
  bool? cancelled;
  String? hostId;
  List<String>? invitees;
  String? description;
  String? icon;
  bool? isRecurring;
  String? frequency;
  int? until;
  List<String>? addedRoomIds;
  List<String>? removedRoomIds;
  List<String>? setRoomIds;
  String? viewPolicy;
  String? editPolicy;
  List<String>? addedProjectIds;
  List<String>? removedProjectIds;
  List<String>? setProjectIds;
  List<String>? addedSubscriberIds;
  List<String>? removedSubscriberIds;
  List<String>? setSubscriberIds;
  String? comment;

  CreateEventApiRequest({
    this.objectIdentifier,
    this.space,
    this.name,
    this.isAllDay,
    this.isForDev,
    this.start,
    this.end,
    this.cancelled,
    this.hostId,
    this.invitees,
    this.description,
    this.icon,
    this.isRecurring,
    this.frequency,
    this.until,
    this.addedProjectIds,
    this.removedProjectIds,
    this.setProjectIds,
    this.addedSubscriberIds,
    this.removedSubscriberIds,
    this.setSubscriberIds,
    this.comment,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = Map<dynamic, dynamic>();
    var transactions = List<Map<dynamic, dynamic>>.empty(growable: true);

    if (space != null) {
      transactions.add({'type': 'space', 'value': space});
    }

    if (name != null) {
      transactions.add({'type': 'name', 'value': name});
    }

    if (isAllDay != null) {
      transactions.add({'type': 'isAllDay', 'value': isAllDay});
    }

    if (isForDev != null) {
      transactions.add({'type': 'isForDev', 'value': isForDev});
    }

    if (start != null) {
      transactions.add({'type': 'start', 'value': start});
    }

    if (end != null) {
      transactions.add({'type': 'end', 'value': end});
    }

    if (cancelled != null) {
      transactions.add({'type': 'cancelled', 'value': cancelled});
    }

    if (hostId != null) {
      transactions.add({'type': 'hostPHID', 'value': hostId});
    }

    if (invitees != null) {
      if (!this.invitees.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.invitees?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'inviteePHIDs', 'value': dataIds});
      }
    }

    if (description != null) {
      transactions.add({'type': 'description', 'value': description});
    }

    if (icon != null) {
      transactions.add({'type': 'icon', 'value': icon});
    }

    if (isRecurring != null) {
      transactions.add({'type': 'isRecurring', 'value': isRecurring});
    }

    if (frequency != null) {
      transactions.add({'type': 'frequency', 'value': frequency});
    }

    if (until != null) {
      transactions.add({'type': 'until', 'value': until});
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
        transactions.add({'type': 'conpherence.add', 'value': addedRoomIds});
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

    if (viewPolicy != null) {
      transactions.add({'type': 'view', 'value': viewPolicy});
    }

    if (editPolicy != null) {
      transactions.add({'type': 'edit', 'value': editPolicy});
    }

    if (addedProjectIds != null) {
      if (!this.addedProjectIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.addedProjectIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'projects.add', 'value': dataIds});
      }
    }

    if (removedProjectIds != null) {
      if (!this.removedProjectIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.removedProjectIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'projects.remove', 'value': dataIds});
      }
    }

    if (setProjectIds != null) {
      if (!this.setProjectIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.setProjectIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'projects.set', 'value': dataIds});
      }
    }

    if (addedSubscriberIds != null) {
      if (!this.addedSubscriberIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.addedSubscriberIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'subscribers.add', 'value': dataIds});
      }
    }

    if (removedSubscriberIds != null) {
      if (!this.removedSubscriberIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.removedSubscriberIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'subscribers.remove', 'value': dataIds});
      }
    }

    if (setSubscriberIds != null) {
      if (!this.setSubscriberIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.setSubscriberIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'subscribers.set', 'value': dataIds});
      }
    }

    if (comment != null) {
      transactions.add({'type': 'comment', 'value': comment});
    }

    if (objectIdentifier != null) {
      req['objectIdentifier'] = objectIdentifier;
    }

    req['transactions'] = transactions;
    return req;
  }
}
