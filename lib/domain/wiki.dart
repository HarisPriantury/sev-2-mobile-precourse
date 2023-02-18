import 'dart:convert';

import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 49)
class Wiki extends PhObject {
  Wiki(
    id, {
    this.author,
    this.idInt = 0,
    this.documentPHID,
    this.title,
    this.description = "",
    this.createdAt,
  }) : super(
          id,
        );

  @HiveField(10)
  User? author;

  @HiveField(12)
  DateTime? createdAt;

  @HiveField(11)
  String description;

  @HiveField(8)
  String? documentPHID;

  @HiveField(7)
  int idInt;

  @HiveField(9)
  String? title;

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'intId': idInt,
        'author': jsonEncode(author),
        'documentPHID': documentPHID,
        'title': title,
        'description': description,
        'dateCreated':
            createdAt == null ? 0 : createdAt?.millisecondsSinceEpoch,
      };
}
