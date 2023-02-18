import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'lobby_status.g.dart';

@HiveType(typeId: 32)
class LobbyStatus extends BaseDomain {
  @HiveField(0)
  int id;

  @HiveField(1)
  String status;

  @HiveField(2)
  String icon;

  LobbyStatus(
    this.id,
    this.status,
    this.icon,
  );

  @override
  LobbyStatus clone() {
    return LobbyStatus(
      id,
      status,
      icon,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'icon': icon,
      };

  factory LobbyStatus.fromJson(Map<String, dynamic> json) {
    return LobbyStatus(
      json['id'],
      json['status'],
      json['icon'],
    );
  }

  static String getName() {
    return 'lobby_status';
  }
}
