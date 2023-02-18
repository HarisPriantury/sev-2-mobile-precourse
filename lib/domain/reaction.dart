// Represent a token/emoji given for a chat

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'reaction.g.dart';

@HiveType(typeId: 16)
class Reaction extends BaseDomain {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  // IconData? emoticon;
  String? emoticon;

  @HiveField(3)
  Color? color;

  Reaction(
    this.id, {
    this.name,
    this.emoticon,
    this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoticon': emoticon,
        'color': color,
      };

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      json['id'],
      name: json['name'],
      emoticon: json['emoticon'],
      color: json['color'],
    );
  }

  static String getName() {
    return 'reaction';
  }

  @override
  Reaction clone() {
    return Reaction(
      this.id,
      name: this.name,
      emoticon: this.emoticon,
      color: this.color,
    );
  }
}
