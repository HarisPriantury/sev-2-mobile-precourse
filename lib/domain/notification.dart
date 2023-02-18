import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/phobject.dart';

part 'notification.g.dart';

@HiveType(typeId: 11)
class Notification extends PhObject {
  @HiveField(7)
  String title;

  @HiveField(8)
  String description;

  @HiveField(9)
  bool isRead;

  @HiveField(10)
  String url;

  @HiveField(11)
  String icon;

  @HiveField(12)
  String chronoKey = "0";

  @HiveField(13)
  DateTime? createdAt;

  Notification(
    id, {
    this.title = "",
    this.description = "",
    this.createdAt,
    this.isRead = false,
    this.url = "",
    this.icon = "",
    this.chronoKey = "0",
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

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'is_read': isRead,
        'url': url,
        'icon': icon,
        'chrono_key': chronoKey,
        'created_at': createdAt == null ? 0 : createdAt?.millisecondsSinceEpoch,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
      };

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      isRead: json['is_read'],
      url: json['url'],
      icon: json['icon'],
      chronoKey: json['chrono_key'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
    );
  }

  static String getName() {
    return 'notification';
  }

  @override
  Notification clone() {
    return Notification(
      id,
      title: this.title,
      description: this.description,
      createdAt: this.createdAt,
      isRead: this.isRead,
      url: this.url,
      icon: this.icon,
      chronoKey: this.chronoKey,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
    );
  }
}
