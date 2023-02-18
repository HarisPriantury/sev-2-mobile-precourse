import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/push_notification_repository_interface.dart';

class StorePushNotificationUseCase
    extends UseCase<bool, StorePushNotificationRequestInterface> {
  PushNotificationRepositoryInterface _repository;

  StorePushNotificationUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(
      StorePushNotificationRequestInterface? req) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.store(req!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
