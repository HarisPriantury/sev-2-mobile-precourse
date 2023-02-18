import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'setting.g.dart';

@HiveType(typeId: 18)
class Setting extends BaseDomain {
  @HiveField(1)
  String? currentTask;

  @HiveField(2)
  List<String>? bookmarkedRooms;

  @HiveField(3)
  bool? hasUnopenedNotification;

  @HiveField(4)
  bool? hasUnreadChats;

  // TODO: ADD
  bool? hasUnopenedCalendar;

  Setting({
    this.currentTask,
    this.bookmarkedRooms,
    this.hasUnopenedNotification,
    this.hasUnreadChats,
    this.hasUnopenedCalendar,
  });

  @override
  Map<String, dynamic> toJson() => {
        'current_task': currentTask,
        'bookmarked_rooms': bookmarkedRooms,
        'has_unopened_notification': hasUnopenedNotification,
        'has_unread_chats': hasUnreadChats,
        'has_unopened_calendar': hasUnopenedCalendar,
      };

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      currentTask: json['current_task'],
      bookmarkedRooms: json['bookmarked_rooms'],
      hasUnopenedNotification: json['has_unopened_notification'],
      hasUnreadChats: json['has_unread_chats'],
      hasUnopenedCalendar: json['has_unopened_calendar'],
    );
  }

  static String getName() {
    return 'setting';
  }

  @override
  Setting clone() {
    return Setting(
      currentTask: this.currentTask,
      bookmarkedRooms: this.bookmarkedRooms,
      hasUnopenedNotification: this.hasUnopenedNotification,
      hasUnreadChats: this.hasUnreadChats,
      hasUnopenedCalendar: this.hasUnopenedCalendar,
    );
  }
}

@HiveType(typeId: 38)
class Phone extends BaseDomain {
  @HiveField(0)
  String phone;

  @HiveField(1)
  bool isPrimary;

  Phone(this.phone, this.isPrimary);

  @override
  clone() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  static String getName() {
    return 'phone';
  }
}

@HiveType(typeId: 39)
class Email extends BaseDomain {
  @HiveField(0)
  String email;

  @HiveField(1)
  bool isPrimary;

  Email(this.email, this.isPrimary);

  @override
  clone() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  static String getName() {
    return 'email';
  }
}
