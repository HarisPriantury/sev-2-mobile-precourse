import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'feed.g.dart';

@HiveType(typeId: 4)
class Feed extends PhObject {
  @HiveField(7)
  User user;

  @HiveField(8)
  String content;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  List<String>? tags;

  @HiveField(11)
  String chronoKey = "0";

  String? objectPHID;

  @HiveField(12)
  bool isRead = true;

  Feed(
    id,
    this.user,
    this.content,
    this.createdAt, {
    this.tags,
    this.chronoKey = "0",
    this.isRead = true,
    this.objectPHID,
    uri,
    typeName,
    type,
    name,
    fullName,
    status,
  }) : super(
          id,
          uri: uri,
          typeName: typeName,
          type: type,
          name: name,
          fullName: fullName,
          status: status,
        );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'user': jsonEncode(user),
        'content': content,
        'created_at': createdAt.millisecondsSinceEpoch,
        'tags': jsonEncode(tags),
        'chrono_key': chronoKey,
        'is_read': isRead,
        'full_name': fullName,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri
      };

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      json['id'],
      jsonDecode(json['user']),
      json['content'],
      DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      tags: jsonDecode(json['tags']),
      chronoKey: json['chrono_key'],
      isRead: json['is_read'],
      fullName: json['full_name'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
    );
  }

  static String getName() {
    return 'feed';
  }

  @override
  Feed clone() {
    return Feed(this.id, this.user, this.content, this.createdAt,
        tags: this.tags,
        chronoKey: this.chronoKey,
        isRead: this.isRead,
        name: this.name,
        status: this.status,
        type: this.type,
        typeName: this.typeName,
        uri: this.uri);
  }
}
