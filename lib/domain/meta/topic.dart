import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'topic.g.dart';

@HiveType(typeId: 45)
class Topic extends BaseDomain {
  @HiveField(0)
  String workspaceId;

  @HiveField(1)
  String topicId;

  static String getName() {
    return 'topic';
  }

  Topic(this.workspaceId, this.topicId);

  @override
  clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
