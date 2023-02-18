import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/calendar_repository_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';

class GetEventsUseCase extends UseCase<List<Calendar>, GetEventsRequestInterface> {
  CalendarRepository _repository;

  GetEventsUseCase(this._repository);

  @override
  Future<Stream<List<Calendar>?>> buildUseCaseStream(GetEventsRequestInterface? params) async {
    final StreamController<List<Calendar>> _controller = StreamController();
    try {
      List<Calendar> cals = await _repository.findAll(params!);
      _controller.add(cals);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
