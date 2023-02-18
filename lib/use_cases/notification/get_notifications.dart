import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/notification_repository_interface.dart';
import 'package:mobile_sev2/domain/notification.dart';

class GetNotificationsUseCase
    extends UseCase<List<Notification>, GetNotificationsRequestInterface> {
  NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Stream<List<Notification>?>> buildUseCaseStream(
      GetNotificationsRequestInterface? params) async {
    final StreamController<List<Notification>> _controller = StreamController();
    try {
      List<Notification> notifications = await _repository.findAll(params!);
      _controller.add(notifications);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
