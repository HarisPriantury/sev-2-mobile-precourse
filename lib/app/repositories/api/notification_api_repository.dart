import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/notification_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/notification_repository_interface.dart';
import 'package:mobile_sev2/domain/embrace.dart';
import 'package:mobile_sev2/domain/meta/notif_stream.dart';
import 'package:mobile_sev2/domain/notification.dart';

class NotificationApiRepository implements NotificationRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  NotificationMapper _mapper;

  NotificationApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Notification>> findAll(GetNotificationsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.notifications(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetNotificationsApiResponse(resp);
  }

  @override
  Future<bool> markAllRead(MarkNotificationsReadRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.notificationsMarkAllRead(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> create(CreateNotificationRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> createStream(CreateNotifStreamRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<List<NotifStream>> getNotifStreams(GetNotifStreamsRequestInterface params) {
    throw UnimplementedError();
  }

  @override
  Future<List<Embrace>> getEmbraces(GetEmbracesRequestInterface params) {
    var result = List<Embrace>.empty(growable: true);
    return Future.value(result);
  }
}
