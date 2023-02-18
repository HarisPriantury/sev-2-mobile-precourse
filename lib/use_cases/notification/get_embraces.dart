import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/notification_repository_interface.dart';
import 'package:mobile_sev2/domain/embrace.dart';

class GetEmbracesUseCase extends UseCase<List<Embrace>, GetEmbracesRequestInterface> {
  NotificationRepository _repository;

  GetEmbracesUseCase(this._repository);

  @override
  Future<Stream<List<Embrace>?>> buildUseCaseStream(GetEmbracesRequestInterface? params) async {
    final StreamController<List<Embrace>> _controller = StreamController();
    try {
      List<Embrace> embraces = await _repository.getEmbraces(params!);
      _controller.add(embraces);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
