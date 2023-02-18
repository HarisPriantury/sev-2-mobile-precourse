import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'room_participants.g.dart';

@HiveType(typeId: 35)
class RoomParticipants extends BaseDomain {
  @HiveField(0)
  String roomId;

  @HiveField(1)
  List<String> userIds;

  RoomParticipants(this.roomId, this.userIds);

  static String getName() {
    return "room_participants";
  }

  @override
  clone() {
    return RoomParticipants(this.roomId, this.userIds);
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
