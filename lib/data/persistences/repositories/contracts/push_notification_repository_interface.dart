import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';
import 'package:mobile_sev2/domain/meta/push_notification.dart';

abstract class PushNotificationRepositoryInterface {
  Future<List<PushNotification>> findAll(GetPushNotificationsRequestInterface param);
  Future<bool> delete(DeletePushNotificationsRequestInterface param);
  Future<bool> store(StorePushNotificationRequestInterface param);
}