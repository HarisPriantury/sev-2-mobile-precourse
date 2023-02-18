import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'status_history.g.dart';

@HiveType(typeId: 36)
class StatusHistory extends BaseDomain {
  @HiveField(0)
  String action;
  @HiveField(1)
  String target;
  @HiveField(2)
  DateTime createdAt;

  StatusHistory(this.action, this.target, this.createdAt);

  static String getName() {
    return "status_history";
  }

  @override
  clone() {
    return StatusHistory(this.action, this.target, this.createdAt);
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
