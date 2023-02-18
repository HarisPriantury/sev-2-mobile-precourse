import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'unread_chat.g.dart';

@HiveType(typeId: 40)
class UnreadChat extends BaseDomain {
  @HiveField(0)
  String roomId;

  @HiveField(1)
  int count;

  UnreadChat(this.roomId, this.count);

  static String getName() {
    return 'unread_chat';
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
