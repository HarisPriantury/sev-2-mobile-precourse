import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';

class CreateLobbyRoomTicketApiRequest
    implements
        CreateLobbyRoomTaskRequestInterface,
        TaskTransactionRequestInterface,
        ApiRequestInterface {
  String? objectIdentifier;
  String? parentId;
  List<String>? columns;
  String? space;
  String? title;
  String? assigneeId;
  String? priority;
  String? status;
  double? point;
  String? description;
  List<String>? addedParentIds;
  List<String>? removedParentIds;
  List<String>? setParentIds;
  List<String>? addedSubtaskIds;
  List<String>? removedSubtaskIds;
  List<String>? setSubtaskIds;
  List<String>? addedCommitIds;
  List<String>? removedCommitIds;
  List<String>? setCommitIds;
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
  String? subtype;
  String? reportedBy;
  String? comment;

  CreateLobbyRoomTicketApiRequest({
    this.objectIdentifier,
    this.parentId,
    this.columns,
    this.space,
    this.title,
    this.assigneeId,
    this.priority,
    this.status,
    this.reportedBy,
    this.point,
    this.description,
    this.addedParentIds,
    this.removedParentIds,
    this.setParentIds,
    this.addedSubtaskIds,
    this.removedSubtaskIds,
    this.setSubtaskIds,
    this.addedCommitIds,
    this.removedCommitIds,
    this.setCommitIds,
    this.addedRoomIds,
    this.removedRoomIds,
    this.setRoomIds,
    this.viewPolicy,
    this.editPolicy,
    this.addedProjectIds,
    this.removedProjectIds,
    this.setProjectIds,
    this.addedSubscriberIds,
    this.removedSubscriberIds,
    this.setSubscriberIds,
    this.subtype,
    this.comment,
  });

  @override
  Map<dynamic, dynamic> encode() {
    var req = Map<dynamic, dynamic>();
    var transactions = List<Map<dynamic, dynamic>>.empty(growable: true);

    if (title != null) {
      transactions.add({'type': 'title', 'value': title});
    }

    if (parentId != null) {
      transactions.add({'type': 'parent', 'value': parentId});
    }

    if (columns != null) {
      if (!this.columns.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.columns?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'column', 'value': dataIds});
      }
    }

    if (space != null) {
      transactions.add({'type': 'space', 'value': space});
    }

    if (assigneeId != null) {
      transactions.add({'type': 'owner', 'value': assigneeId});
    }

    if (priority != null) {
      transactions.add({'type': 'priority', 'value': priority});
    }

    if (point != null) {
      transactions.add({'type': 'points', 'value': point});
    }

    if (description != null) {
      transactions.add({'type': 'description', 'value': description});
    }

    if (status != null) {
      transactions.add({'type': 'status', 'value': status});
    }

    if (addedParentIds != null) {
      if (!this.addedParentIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.addedParentIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'parents.add', 'value': dataIds});
      }
    }

    if (removedParentIds != null) {
      if (!this.removedParentIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.removedParentIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'parents.remove', 'value': dataIds});
      }
    }

    if (setParentIds != null) {
      if (!this.setParentIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.setParentIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'parents.set', 'value': dataIds});
      }
    }

    if (addedSubtaskIds != null) {
      if (!this.addedSubtaskIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.addedSubtaskIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'subtasks.add', 'value': dataIds});
      }
    }

    if (removedSubtaskIds != null) {
      if (!this.removedSubtaskIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.removedSubtaskIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'subtasks.remove', 'value': dataIds});
      }
    }

    if (setSubtaskIds != null) {
      if (!this.setSubtaskIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.setSubtaskIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'subtasks.set', 'value': dataIds});
      }
    }

    if (addedCommitIds != null) {
      if (!this.addedCommitIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.addedCommitIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'commits.add', 'value': dataIds});
      }
    }

    if (removedCommitIds != null) {
      if (!this.removedCommitIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.removedCommitIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'commits.remove', 'value': dataIds});
      }
    }

    if (setCommitIds != null) {
      if (!this.setCommitIds.isNullOrEmpty()) {
        var dataIds = Map<String, String>();
        var counter = 0;
        this.setCommitIds?.asMap().forEach((key, value) {
          if (!dataIds.containsValue(value.toString())) {
            dataIds[(counter++).toString()] = value;
          }
        });
        transactions.add({'type': 'commits.set', 'value': dataIds});
      }
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

    if (subtype != null) {
      transactions.add({'type': 'subtype', 'value': subtype});
    }

    if (comment != null) {
      transactions.add({'type': 'comment', 'value': comment});
    }

    if (objectIdentifier != null) {
      req['objectIdentifier'] = objectIdentifier;
    }

    if (reportedBy != null) {
      transactions.add({'type': 'custom.bug:reported-by', 'value': reportedBy});
    }

    req['transactions'] = transactions;
    return req;
  }
}
