import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'stickit.g.dart';

@HiveType(typeId: 19)
class Stickit extends PhObject {
  static const TYPE_MEMO = "memo";
  static const TYPE_MOM = "mom";
  static const TYPE_PRAISE = "praise";
  static const TYPE_PITCH = "pitch";

  @HiveField(7)
  User author;

  @HiveField(8)
  String stickitType;

  @HiveField(9)
  String plainContent;

  @HiveField(10)
  String htmlContent;

  @HiveField(11)
  int seenCount;

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  List<User>? spectators = [];

  Stickit(
    id,
    this.author,
    this.stickitType,
    this.plainContent,
    this.htmlContent,
    this.seenCount,
    this.createdAt, {
    this.spectators,
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
        'author': jsonEncode(author),
        'stickit_type': stickitType,
        'plain_content': plainContent,
        'html_content': htmlContent,
        'seen_count': seenCount,
        'created_at': createdAt.millisecondsSinceEpoch,
        'spectators': jsonEncode(spectators),
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
      };

  factory Stickit.fromJson(Map<String, dynamic> json) {
    return Stickit(
      json['id'],
      jsonDecode(json['author']),
      json['type'],
      json['plain_content'],
      json['html_content'],
      json['seen_count'],
      DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      spectators: (jsonDecode(json['invitees']) as List).map((e) => User.fromJson(e)).toList(),
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
    );
  }

  static String getName() {
    return 'stickit';
  }

  static String getTypeKey(String label) {
    var key = TYPE_MEMO;

    switch (label) {
      case "Announcement":
        key = TYPE_MEMO;
        break;

      case "Pitch an Idea":
        key = TYPE_PITCH;
        break;

      case "Praise":
        key = TYPE_PRAISE;
        break;

      case "Minutes of Meeting":
        key = TYPE_MOM;
        break;
      default:
        break;
    }

    return key;
  }

  static String getKeyFromType(String type) {
    var type = TYPE_MEMO;

    switch (type) {
      case TYPE_MEMO:
        type = "Announcement";
        break;

      case TYPE_PITCH:
        type = "Pitch an Idea";
        break;

      case TYPE_PRAISE:
        type = "Praise";
        break;

      case TYPE_MOM:
        type = "Minutes of Meeting";
        break;
      default:
        break;
    }

    return type;
  }

  @override
  Stickit clone() {
    return Stickit(
      this.id,
      this.author,
      this.stickitType,
      this.plainContent,
      this.htmlContent,
      this.seenCount,
      this.createdAt,
      spectators: List.from(this.spectators ?? []),
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
    );
  }
}
