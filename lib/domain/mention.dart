import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'mention.g.dart';

@HiveType(typeId: 47)
class Mention extends PhObject {
  @HiveField(7)
  User author;

  @HiveField(8)
  String content;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  List<User> mentionedUsers;

  @HiveField(11)
  PhObject? object;

  int intId;

  Mention(
    id,
    this.author,
    this.content,
    this.createdAt, {
    this.mentionedUsers = const [],
    this.object,
    this.intId = 0,
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
        'user': jsonEncode(author),
        'content': content,
        'created_at': createdAt.millisecondsSinceEpoch,
        'full_name': fullName,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri
      };

  factory Mention.fromJson(Map<String, dynamic> json) {
    return Mention(
      json['id'],
      jsonDecode(json['user']),
      json['content'],
      DateTime.fromMillisecondsSinceEpoch(json['created_at']),
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
  Mention clone() {
    return Mention(
      this.id,
      this.author,
      this.content,
      this.createdAt,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
    );
  }
}
