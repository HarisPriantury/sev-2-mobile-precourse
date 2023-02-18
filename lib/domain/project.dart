import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'project.g.dart';

@HiveType(typeId: 15)
class Project extends PhObject {
  @HiveField(7)
  String image;

  @HiveField(8)
  int totalTickets = 0;

  @HiveField(9)
  double totalStoryPoints = 0;

  @HiveField(10)
  double totalFinishedStoryPoints = 0;

  @HiveField(11)
  int totalRSP = 0;

  @HiveField(12)
  List<Ticket> tickets = [];

  bool isGroup = false;

  bool isForRsp = false;

  bool isForDev = false;

  bool isArchived = false;

  bool isMilestone = false;

  List<User>? members = [];

  String description, viewPolicy, editPolicy;

  int? intId = 0;

  int? depth = 0;

  DateTime? startDate;

  DateTime? endDate;

  Project(
    id,
    this.image,
    this.tickets, {
    this.totalTickets = 0,
    this.totalStoryPoints = 0,
    this.totalFinishedStoryPoints = 0,
    this.totalRSP = 0,
    this.isGroup = false,
    this.description = "",
    this.isForRsp = false,
    this.isForDev = false,
    this.isArchived = false,
    this.isMilestone = false,
    this.members,
    this.intId,
    this.depth,
    this.editPolicy = "",
    this.viewPolicy = "",
    this.endDate,
    this.startDate,
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
        'image': image,
        'total_tickets': totalTickets,
        'total_story_points': totalStoryPoints,
        'total_finished_story_points': totalFinishedStoryPoints,
        'total_rsp': totalRSP,
        'tickets': jsonEncode(tickets),
        'isGroup': isGroup,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
        'description': description,
        'isForRsp': false,
        'isForDev': false,
        'isArchived': false,
        'isMilestone': false,
        'members': members,
        'int_id': intId,
        'depth': depth,
      };

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      json['id'],
      json['image'],
      (jsonDecode(json['tickets']) as List)
          .map((e) => Ticket.fromJson(e))
          .toList(),
      isGroup: json['isGroup'],
      totalTickets: json['total_tickets'],
      totalStoryPoints: json['total_story_points'],
      totalFinishedStoryPoints: json['total_finished_story_points'],
      totalRSP: json['total_rsp'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
      description: json['description'],
      isForRsp: json['isForRsp'],
      isForDev: json['isForDev'],
      isArchived: json['isArchived'],
      isMilestone: json['isMilestone'],
      members: (jsonDecode(json['phid']) as List)
          .map((e) => User.fromJson(e))
          .toList(),
    );
  }

  static String getName() {
    return 'project';
  }

  @override
  Project clone() {
    return Project(
      this.id,
      this.image,
      this.tickets,
      totalTickets: this.totalTickets,
      totalStoryPoints: this.totalStoryPoints,
      totalFinishedStoryPoints: this.totalFinishedStoryPoints,
      totalRSP: this.totalRSP,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
      description: this.description,
      isForRsp: this.isForRsp,
      isForDev: this.isForDev,
      isArchived: this.isArchived,
      isMilestone: this.isMilestone,
      members: this.members,
      intId: this.intId,
      depth: this.depth,
    );
  }
}

class ProjectColumn {
  String id;
  String name;
  String? type;
  bool? isMilestone;
  String? visibility;
  int? sequence;
  Map<String, dynamic>? properties;
  DateTime? dateCreated;
  DateTime? dateModified;
  List<Ticket>? tasks;

  ProjectColumn(
    this.id,
    this.name, {
    this.type,
    this.isMilestone,
    this.visibility,
    this.sequence,
    this.properties,
    this.dateCreated,
    this.dateModified,
    this.tasks,
  });

  ProjectColumn clone() {
    return ProjectColumn(
      id,
      name,
      type: type,
      isMilestone: isMilestone,
      visibility: visibility,
      sequence: sequence,
      properties: properties,
      dateCreated: dateCreated,
      dateModified: dateModified,
      tasks: List.from(tasks ?? []),
    );
  }

  bool isHidden() {
    if ((type ?? "").toLowerCase().contains("hidden")) {
      return true;
    } else {
      return false;
    }
  }
}
