import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/notification/create_notif_stream_db_request.dart';
import 'package:mobile_sev2/data/payload/db/notification/create_notification_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/notification_repository_interface.dart';
import 'package:mobile_sev2/domain/embrace.dart';
import 'package:mobile_sev2/domain/meta/notif_stream.dart';
import 'package:mobile_sev2/domain/notification.dart';

class NotificationDBRepository implements NotificationRepository {
  Box<Notification> _notifBox;
  Box<NotifStream> _notifStreamBox;

  NotificationDBRepository(this._notifBox, this._notifStreamBox);

  @override
  Future<List<Notification>> findAll(GetNotificationsRequestInterface params) {
    var notifications = _notifBox.values.toList();
    return Future.value(notifications);
  }

  @override
  Future<bool> markAllRead(MarkNotificationsReadRequestInterface request) {
    _notifBox.values.forEach((n) {
      n.isRead = true;
      n.save();
    });
    return Future.value(true);
  }

  @override
  Future<bool> create(CreateNotificationRequestInterface request) {
    var params = request as CreateNotificationDBRequest;
    _notifBox.put(params.notification.id, params.notification);
    return Future.value(true);
  }

  @override
  Future<bool> createStream(CreateNotifStreamRequestInterface request) {
    var params = request as CreateNotifStreamDBRequest;
    _notifStreamBox.put(params.stream.id, params.stream);
    return Future.value(true);
  }

  @override
  Future<List<NotifStream>> getNotifStreams(GetNotifStreamsRequestInterface params) {
    var notifStreams = _notifStreamBox.values.toList();
    return Future.value(notifStreams);
  }

  @override
  Future<List<Embrace>> getEmbraces(GetEmbracesRequestInterface params) {
    throw UnimplementedError();
  }
}
