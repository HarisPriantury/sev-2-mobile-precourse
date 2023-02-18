import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/calendar_repository_interface.dart';

class CreateEventUseCase extends UseCase<bool, CreateEventRequestInterface> {
  CalendarRepository _repository;

  CreateEventUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(CreateEventRequestInterface? req) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.create(req!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
