import 'package:mobile_sev2/domain/base.dart';

class Embrace extends BaseDomain {
  String id;
  String name;
  String type;
  String title;
  String description;
  String note; // can be filled with project title
  DateTime createdAt;

  Embrace(this.id, this.name, this.type, this.title, this.description, this.note, this.createdAt);

  @override
  clone() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
