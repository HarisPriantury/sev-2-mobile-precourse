import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/notification_repository_interface.dart';

class MarkNotificationsReadUseCase
    extends UseCase<bool, MarkNotificationsReadRequestInterface> {
  NotificationRepository _repository;

  MarkNotificationsReadUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(
      MarkNotificationsReadRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      await _repository.markAllRead(params!);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
