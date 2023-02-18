import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'object_reaction.g.dart';

@HiveType(typeId: 33)
class ObjectReactions extends BaseDomain {
  @HiveField(0)
  String objectId;

  @HiveField(1)
  User? author;

  @HiveField(2)
  Reaction reaction;

  ObjectReactions(
    this.objectId,
    this.author,
    this.reaction,
  );

  @override
  ObjectReactions clone() {
    return ObjectReactions(
      this.objectId,
      this.author,
      this.reaction,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'objectPHID': objectId,
        'authorPHID': author?.id,
        'tokenPHID': reaction.id,
      };

  static String getName() {
    return 'object_reaction';
  }
}

@HiveType(typeId: 34)
class ReactionData extends BaseDomain {
  @HiveField(3)
  User? reactor;

  @HiveField(4)
  PhObject? obj;

  @HiveField(5)
  DateTime? createdAt;

  ReactionData(
    this.reactor,
    this.obj,
    this.createdAt,
  );

  @override
  ReactionData clone() {
    return ReactionData(
      this.reactor,
      this.obj,
      this.createdAt,
    );
  }

  @override
  Map<String, dynamic> toJson() =>
      {'reactor': jsonEncode(reactor), 'obj': jsonEncode(obj), 'created_at': createdAt?.millisecondsSinceEpoch};

  factory ReactionData.fromJson(Map<String, dynamic> json) {
    return ReactionData(
      jsonDecode(json['reactor']),
      jsonDecode(json['obj']),
      DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    );
  }

  static String getName() {
    return 'reaction_data';
  }
}
