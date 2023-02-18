import 'package:mobile_sev2/domain/phobject.dart';

class Flag extends PhObject {
  String? ownerPHID;
  String? objectPHID;
  String? color;
  String? colorName;
  String? note;

  Flag(
    String id, {
    this.ownerPHID,
    this.objectPHID,
    this.color,
    this.colorName,
    this.note,
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
}
