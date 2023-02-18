import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/push_notification_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/push_notification.dart';

class GetPushNotificationUseCase
    extends UseCase<List<PushNotification>, GetPushNotificationsRequestInterface> {
  PushNotificationRepositoryInterface _repository;

  GetPushNotificationUseCase(this._repository);

  @override
  Future<Stream<List<PushNotification>?>> buildUseCaseStream(
      GetPushNotificationsRequestInterface? req) async {
    final StreamController<List<PushNotification>> _controller = StreamController();
    try {
      List<PushNotification> result = await _repository.findAll(req!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
