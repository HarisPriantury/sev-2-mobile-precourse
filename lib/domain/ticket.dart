import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'ticket.g.dart';

@HiveType(typeId: 20)
class Ticket extends PhObject {
  static const STATUS_UNBREAK = "Unbreak Now!";
  static const STATUS_TRIAGE = "Needs Triage";
  static const STATUS_HIGH = "High";
  static const STATUS_NORMAL = "Normal";
  static const STATUS_LOW = "Low";
  static const STATUS_WISHLIST = "Wishlist";

  @HiveField(7)
  String code;

  @HiveField(8)
  String description;

  @HiveField(9)
  String priority;

  @HiveField(10)
  TicketStatus ticketStatus;

  @HiveField(11)
  double storyPoint;

  @HiveField(12)
  Project? project;

  @HiveField(13)
  DateTime? createdAt;

  @HiveField(14)
  TicketSubscriberInfo? subscriberInfo;

  @HiveField(15)
  User? assignee;

  @HiveField(16)
  User? author;

  @HiveField(17)
  String? rawStatus;

  String? subtype;

  List<Ticket>? parentTask;

  List<Ticket>? subTasks;

  String? htmlDescription;

  int? intId = 0;
  String? position;

  List<Project>? projectList;
  Ticket(
    id, {
    this.code = "",
    this.description = "",
    this.priority = "",
    this.ticketStatus = TicketStatus.open,
    this.storyPoint = 0,
    this.project,
    this.createdAt,
    this.subscriberInfo,
    this.assignee,
    this.author,
    this.intId,
    this.position,
    this.rawStatus,
    this.parentTask,
    this.subTasks,
    this.htmlDescription,
    this.projectList,
    this.subtype,
    uri,
    typeName,
    type,
    name,
    fullName,
    status,
    avatar,
  }) : super(
          id,
          uri: uri,
          typeName: typeName,
          type: type,
          name: name,
          fullName: fullName,
          status: status,
          avatar: avatar,
        );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'description': description,
        'priority': priority,
        'ticket_status':
            ticketStatus == TicketStatus.open ? 'open' : 'resolved',
        'story_point': storyPoint,
        'project': jsonEncode(project),
        'dateCreated':
            createdAt == null ? 0 : createdAt?.millisecondsSinceEpoch,
        'subscriber_info': jsonEncode(subscriberInfo),
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
        'assignee': jsonEncode(assignee),
        'author': jsonEncode(author),
        'raw_status': rawStatus,
        'parents': jsonEncode(parentTask),
        'subTasks': jsonEncode(subTasks),
        'htmlDescription': htmlDescription,
        'subtype': subtype,
      };

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      json['id'],
      code: json['code'],
      description: json['description'],
      priority: json['priority'],
      ticketStatus: json['ticket_status'] == 'open'
          ? TicketStatus.open
          : TicketStatus.resolved,
      storyPoint: json['story_point'],
      project: jsonDecode(json['project']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['dateCreated']),
      subscriberInfo: jsonDecode(json['subscriber_info']),
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
      assignee: jsonDecode(json['assignee']),
      author: jsonDecode(json['author']),
      rawStatus: json['raw_status'],
      parentTask: (jsonDecode(json['parents']) as List)
          .map((e) => Ticket.fromJson(e))
          .toList(),
      subTasks: (jsonDecode(json['subTasks']) as List)
          .map((e) => Ticket.fromJson(e))
          .toList(),
      htmlDescription: json['htmlDescription'],
      subtype: json['subtype'],
    );
  }

  static String getName() {
    return 'ticket';
  }

  static String getPriorityKey(String rawStatus) {
    String key = "normal";
    switch (rawStatus) {
      case STATUS_UNBREAK:
        key = "unbreak";
        break;
      case STATUS_TRIAGE:
        key = "triage";
        break;
      case STATUS_HIGH:
        key = "high";
        break;
      case STATUS_NORMAL:
        key = "normal";
        break;
      case STATUS_LOW:
        key = "low";
        break;
      case STATUS_WISHLIST:
        key = "wish";
        break;
      default:
    }
    return key;
  }

  static String getLabelFromKey(String key) {
    String label = STATUS_UNBREAK;
    switch (key) {
      case "unbreak":
        label = STATUS_UNBREAK;
        break;
      case "triage":
        label = STATUS_TRIAGE;
        break;
      case "high":
        label = STATUS_HIGH;
        break;
      case "normal":
        label = STATUS_NORMAL;
        break;
      case "low":
        label = STATUS_LOW;
        break;
      case "wish":
        label = STATUS_WISHLIST;
        break;
      default:
    }
    return label;
  }

  @override
  Ticket clone() {
    return Ticket(
      this.id,
      code: this.code,
      description: this.description,
      priority: this.priority,
      ticketStatus: this.ticketStatus,
      storyPoint: this.storyPoint,
      project: this.project,
      createdAt: this.createdAt,
      subscriberInfo: this.subscriberInfo,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
      assignee: this.assignee,
      author: this.author,
      rawStatus: this.rawStatus,
      fullName: this.fullName,
      avatar: this.avatar,
      intId: this.intId,
      parentTask: this.parentTask,
      position: this.position,
      subTasks: this.subTasks,
      subtype: this.subtype,
    );
  }
}

@HiveType(typeId: 21)
class TicketSubscriberInfo extends BaseDomain {
  @HiveField(0)
  List<String> subscriberIds = [];

  @HiveField(1)
  int totalSubscriber = 0;

  @HiveField(2)
  int totalRSP = 0;

  TicketSubscriberInfo(this.subscriberIds, this.totalSubscriber, this.totalRSP);

  @override
  Map<String, dynamic> toJson() => {
        'subscriber_ids': subscriberIds,
        'total_subscriber': totalSubscriber,
        'total_rsp': totalRSP,
      };

  factory TicketSubscriberInfo.fromJson(Map<String, dynamic> json) {
    return TicketSubscriberInfo(
      jsonDecode(json['subscriber_ids']),
      json['total_subscriber'],
      json['total_rsp'],
    );
  }

  static String getName() {
    return 'ticket_subscriber_info';
  }

  @override
  TicketSubscriberInfo clone() {
    return TicketSubscriberInfo(
        this.subscriberIds, this.totalSubscriber, this.totalRSP);
  }
}

@HiveType(typeId: 22)
enum TicketStatus {
  @HiveField(0)
  open,
  @HiveField(1)
  resolved
}

@HiveType(typeId: 48)
class TicketProjectInfo extends BaseDomain {
  @HiveField(0)
  List<String> projectIds = [];

  @HiveField(1)
  int totalProject = 0;

  TicketProjectInfo(this.projectIds, this.totalProject);

  static String getName() {
    return 'ticket_project_info';
  }

  @override
  TicketProjectInfo clone() {
    return TicketProjectInfo(this.projectIds, this.totalProject);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'project_ids': projectIds,
      'total_project': totalProject,
    };
  }
}
