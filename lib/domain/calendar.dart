import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'calendar.g.dart';

@HiveType(typeId: 1)
class Calendar extends PhObject {
  @HiveField(7)
  String description;

  @HiveField(8)
  User host;

  @HiveField(9)
  bool isCancelled;

  @HiveField(10)
  bool isRecurring;

  @HiveField(11)
  DateTime startTime;

  @HiveField(12)
  DateTime endTime;

  @HiveField(13)
  bool isAllDay;

  @HiveField(14)
  String label;

  @HiveField(15)
  DateTime? untilTime;

  @HiveField(16)
  String? frequency;

  @HiveField(17)
  List<User>? invitees = [];
  List<String>? subcribersPhid = [];

  String? code;

  int? intId = 0;

  Calendar(
    id,
    this.description,
    this.host,
    this.isCancelled,
    this.isRecurring,
    this.startTime,
    this.endTime,
    this.isAllDay,
    this.label, {
    this.untilTime,
    this.frequency,
    this.invitees,
    this.subcribersPhid,
    this.code,
    this.intId,
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
        'description': description,
        'host': jsonEncode(host.toJson()),
        'is_cancelled': isCancelled,
        'is_recurring': isRecurring,
        'start_time': startTime.millisecondsSinceEpoch,
        'end_time': endTime.millisecondsSinceEpoch,
        // 'until_time': untilTime?.millisecondsSinceEpoch,
        'is_all_day': isAllDay,
        'label': label,
        'frequency': frequency,
        'invitees': jsonEncode(invitees?.map((e) => e.toJson()).toList()),
        'id': id,
        'full_name': fullName,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri
      };

  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      json['id'],
      json['description'],
      User.fromJson(jsonDecode(json['host'])),
      json['is_cancelled'],
      json['is_recurring'],
      DateTime.fromMillisecondsSinceEpoch(json['start_time']),
      DateTime.fromMillisecondsSinceEpoch(json['end_time']),
      json['is_all_day'],
      json['label'],
      // untilTime: DateTime.fromMillisecondsSinceEpoch(json['until_time']),
      frequency: json['frequency'],
      invitees: (jsonDecode(json['invitees']) as List).map((e) => User.fromJson(e)).toList(),
      fullName: json['full_name'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
    );
  }

  static String getName() {
    return 'calendar';
  }

  @override
  Calendar clone() {
    return Calendar(
      this.id,
      this.description,
      this.host,
      this.isCancelled,
      this.isRecurring,
      this.startTime,
      this.endTime,
      this.isAllDay,
      this.label,
      untilTime: this.untilTime,
      frequency: this.frequency,
      invitees: this.invitees,
      fullName: this.fullName,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
    );
  }
}
