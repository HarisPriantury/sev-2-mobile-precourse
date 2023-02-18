import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/phobject.dart';

part 'notif_stream.g.dart';

@HiveType(typeId: 41)
class NotifStream extends BaseDomain {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String type;

  @HiveField(3)
  PhObject? target;

  @HiveField(4)
  bool isRead;

  @HiveField(5)
  String icon;

  @HiveField(6)
  DateTime? createdAt;

  NotifStream(
    this.id, {
    this.title = "",
    this.type = "",
    this.target,
    this.createdAt,
    this.isRead = false,
    this.icon = "",
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type,
        'target': jsonEncode(target),
        'is_read': isRead,
        'icon': icon,
        'created_at': createdAt == null ? 0 : createdAt?.millisecondsSinceEpoch,
      };

  factory NotifStream.fromJson(Map<String, dynamic> json) {
    return NotifStream(
      json['id'],
      title: json['title'],
      type: json['type'],
      target: jsonDecode(json['description']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      isRead: json['is_read'],
      icon: json['icon'],
    );
  }

  static String getName() {
    return 'notif_stream';
  }

  @override
  NotifStream clone() {
    return NotifStream(
      id,
      title: this.title,
      type: this.type,
      target: this.target,
      createdAt: this.createdAt,
      isRead: this.isRead,
      icon: this.icon,
    );
  }
}
