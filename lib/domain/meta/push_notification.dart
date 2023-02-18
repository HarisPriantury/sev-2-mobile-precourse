import 'package:hive/hive.dart';

import '../base.dart';

part 'push_notification.g.dart';

@HiveType(typeId: 46)
class PushNotification extends BaseDomain {
  @HiveField(0)
  String conpherencePHID;

  @HiveField(1)
  String authorPHID;

  @HiveField(2)
  String title;

  @HiveField(3)
  String body;

  @HiveField(4)
  String workspace;

  PushNotification({
    required this.conpherencePHID,
    required this.authorPHID,
    required this.title,
    required this.body,
    required this.workspace,
  });

  static String getName() {
    return 'push_notification';
  }

  @override
  clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
