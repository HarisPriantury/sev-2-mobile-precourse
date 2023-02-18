import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/ticket_repository_interface.dart';

class TaskTransactionUseCase extends UseCase<bool, TaskTransactionRequestInterface> {
  TicketRepository _repository;
  TaskTransactionUseCase(this._repository);
  @override
  Future<Stream<bool?>> buildUseCaseStream(TaskTransactionRequestInterface? req) async {
    final StreamController<bool> _controller = StreamController();

    try {
      bool result = await _repository.taskTransaction(req!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
