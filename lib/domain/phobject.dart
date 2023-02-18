import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'phobject.g.dart';

@HiveType(typeId: 12)
class PhObject extends BaseDomain {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? uri;

  @HiveField(2)
  String? typeName;

  @HiveField(3)
  String? type;

  @HiveField(4)
  String? name;

  @HiveField(5)
  String? fullName;

  @HiveField(6)
  String? status;

  @HiveField(255)
  String? avatar;

  PhObject(
    this.id, {
    this.uri,
    this.typeName,
    this.type,
    this.name,
    this.fullName,
    this.status,
    this.avatar = "",
  }) {
    this._setAvatar();
  }

  String? getFullName() {
    return this.name;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'uri': uri,
        'type_name': typeName,
        'type': type,
        'name': name,
        'full_name': fullName,
        'status': status,
        'avatar': avatar,
      };

  factory PhObject.fromJson(Map<String, dynamic> json) {
    return PhObject(
      json['id'],
      uri: json['uri'],
      typeName: json['typeName'],
      type: json['type'],
      name: json['name'],
      fullName: json['fullName'],
      status: json['status'],
      avatar: json['avatar'],
    );
  }

  String? _setAvatar() {
    if (!(avatar != null && avatar!.isNotEmpty)) {
      avatar = "https://www.gravatar.com/avatar/${md5.convert(utf8.encode(id))}?s=64&d=identicon&r=G";
    }

    return avatar;
  }

  static String getName() {
    return 'ph_object';
  }

  PhObject clone() {
    return PhObject(
      this.id,
      uri: this.uri,
      typeName: this.typeName,
      type: this.type,
      name: this.name,
      fullName: this.fullName,
      status: this.status,
    );
  }
}
