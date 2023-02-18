import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/domain/notification.dart';

class CreateNotificationDBRequest
    implements CreateNotificationRequestInterface {
  Notification notification;

  CreateNotificationDBRequest(this.notification);
}
