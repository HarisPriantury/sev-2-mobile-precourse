import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/domain/embrace.dart';
import 'package:mobile_sev2/domain/meta/notif_stream.dart';
import 'package:mobile_sev2/domain/notification.dart';

abstract class NotificationRepository {
  Future<bool> create(CreateNotificationRequestInterface request);
  Future<List<Notification>> findAll(GetNotificationsRequestInterface params);
  Future<List<NotifStream>> getNotifStreams(GetNotifStreamsRequestInterface params);
  Future<List<Embrace>> getEmbraces(GetEmbracesRequestInterface params);
  Future<bool> markAllRead(MarkNotificationsReadRequestInterface request);
  Future<bool> createStream(CreateNotifStreamRequestInterface request);
}
