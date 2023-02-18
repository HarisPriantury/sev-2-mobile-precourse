import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/reaction.dart';

part 'phtransaction.g.dart';

@HiveType(typeId: 13)
class PhTransaction extends BaseDomain {
  @HiveField(0)
  String id;

  @HiveField(1)
  int idInt;

  @HiveField(2)
  String? type;

  @HiveField(3)
  String phobjectId;

  @HiveField(4)
  String groupId;

  @HiveField(5)
  PhObject actor;

  @HiveField(6)
  PhObject target;

  @HiveField(7)
  String action;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  DateTime updatedAt;

  PhObject? oldRelation;
  PhObject? newRelation;
  List<File>? attachments;
  List<Reaction>? reactions;

  PhTransaction(
    this.id,
    this.idInt,
    this.phobjectId,
    this.groupId,
    this.actor,
    this.target,
    this.action,
    this.createdAt,
    this.updatedAt, {
    this.type,
    this.oldRelation,
    this.newRelation,
    this.attachments,
    this.reactions,
  });

  static String getName() {
    return 'ph_transaction';
  }

  bool isReactable() {
    return this.type == "comment";
  }

  // check if a chat has image inside its attachments
  bool hasImage() {
    return this.attachments != null &&
        this.attachments!.where((at) => at.fileType == FileType.image).toList().isNotEmpty;
  }

  // check if a chat has video inside its video
  bool hasVideo() {
    return this.attachments != null &&
        this.attachments!.where((at) => at.fileType == FileType.video).toList().isNotEmpty;
  }

  // check if a chat has doc inside its attachments
  bool hasDocument() {
    return this.attachments != null &&
        this.attachments!.where((at) => at.fileType == FileType.document).toList().isNotEmpty;
  }

  @override
  clone() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
