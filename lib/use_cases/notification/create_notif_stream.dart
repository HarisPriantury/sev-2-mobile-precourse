import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/notification_repository_interface.dart';

class CreateNotifStreamUseCase extends UseCase<bool, CreateNotifStreamRequestInterface> {
  NotificationRepository _repository;

  CreateNotifStreamUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(CreateNotifStreamRequestInterface? req) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.createStream(req!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
