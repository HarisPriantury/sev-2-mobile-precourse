import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/calendar_repository_interface.dart';

class JoinEventUseCase extends UseCase<bool, JoinEventRequestInterface> {
  CalendarRepository _repository;

  JoinEventUseCase(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(JoinEventRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool results = await _repository.join(params!);
      _controller.add(results);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
