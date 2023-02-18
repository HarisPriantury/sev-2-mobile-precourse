import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';
import 'package:mobile_sev2/domain/meta/push_notification.dart';

class StorePushNotificationsDBRequest extends StorePushNotificationRequestInterface {
  PushNotification notification;

  StorePushNotificationsDBRequest(this.notification);
}