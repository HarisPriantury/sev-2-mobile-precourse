import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/delete_push_notifications_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/get_push_notifications_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/store_push_notification_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/push_notification_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/push_notification.dart';

class PushNotificationDBRepository
    implements PushNotificationRepositoryInterface {
  Box<PushNotification> _box;

  PushNotificationDBRepository(this._box);

  @override
  Future<bool> delete(DeletePushNotificationsRequestInterface param) async {
    DeletePushNotificationsDBRequest request =
        param as DeletePushNotificationsDBRequest;
    Map<dynamic, PushNotification> mapBox = _box.toMap();
    List<dynamic> deletedKey = [];
    mapBox.forEach((key, value) {
      if (value.conpherencePHID == request.conpherencePHID) {
        deletedKey.add(key);
      }
    });
    await _box.deleteAll(deletedKey);
    return true;
  }

  @override
  Future<List<PushNotification>> findAll(
      GetPushNotificationsRequestInterface param) async {
    GetPushNotificationsDBRequest request =
        param as GetPushNotificationsDBRequest;
    return _box.values
        .where((element) => element.conpherencePHID == request.conpherencePHID)
        .toList();
  }

  @override
  Future<bool> store(StorePushNotificationRequestInterface param) async {
    StorePushNotificationsDBRequest request =
        param as StorePushNotificationsDBRequest;
    await _box.add(request.notification);
    return true;
  }
}
