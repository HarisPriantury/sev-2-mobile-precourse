import 'dart:convert';

import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

class Mood extends PhObject {
  User? author;
  String? mood;
  String? message;
  DateTime? createdAt;

  Mood(
    id,
    this.message,
    this.mood,
    this.createdAt, {
    this.author,
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
        'author': jsonEncode(author),
        'mood': mood,
        'message': message,
        'created_at': createdAt!.millisecondsSinceEpoch,
        'id': id,
        'full_name': fullName,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
      };

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      json['id'],
      json['mood'],
      json['message'],
      DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      fullName: json['fullName'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
    );
  }
}
