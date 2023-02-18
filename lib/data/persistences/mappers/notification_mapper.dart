import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/embrace.dart';
import 'package:mobile_sev2/domain/notification.dart';

class NotificationMapper {
  DateUtilInterface _dateUtil;

  NotificationMapper(this._dateUtil);

  List<Notification> convertGetNotificationsApiResponse(Map<String, dynamic> response) {
    var notifications = List<Notification>.empty(growable: true);

    var data = response['result']['stories'];
    for (var notification in data) {
      notifications.add(
        Notification(
          notification['phid'] ?? "",
          title: notification['title'],
          description: notification['body'],
          isRead: notification['has_read'],
          url: notification['href'],
          icon: notification['icon'],
          chronoKey: notification['chronoKey'],
          createdAt: _dateUtil.fromMilliseconds(notification['timestamp'] * 1000),
        ),
      );
    }

    return notifications;
  }

  List<Embrace> convertGetEmbracesApiResponse(Map<String, dynamic> response) {
    var embraces = List<Embrace>.empty(growable: true);
    return embraces;
  }
}
