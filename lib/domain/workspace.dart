import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/room.dart';

part 'workspace.g.dart';

@HiveType(typeId: 42)
class Workspace extends BaseDomain {
  @HiveField(0)
  String workspaceId;

  @HiveField(1)
  String? token;

  String? category;
  String? description;
  int? intId;
  String? imagePath;
  String? name;
  int? subscriptionId;
  DateTime? created;
  DateTime? updated;
  int? userId;
  Room? publicSpace;
  String? status;
  String? type;

  static String getName() {
    return 'workspace';
  }

  Workspace(
    this.workspaceId,
    this.token, {
    this.category,
    this.description,
    this.intId,
    this.imagePath,
    this.name,
    this.subscriptionId,
    this.created,
    this.updated,
    this.userId,
    this.publicSpace,
    this.status,
    this.type,
  });

  @override
  clone() {
    return Workspace(
      this.workspaceId,
      this.token,
      name: this.name,
      category: this.category,
      created: this.created,
      description: this.description,
      imagePath: this.imagePath,
      intId: this.intId,
      publicSpace: this.publicSpace,
      status: this.status,
      type: this.type,
      subscriptionId: this.subscriptionId,
      updated: this.updated,
      userId: this.userId,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
