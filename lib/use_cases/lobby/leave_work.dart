import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';

class LeaveWorkUseCase extends UseCase<bool, LeaveWorkRequestInterface> {
  LobbyRepository _repository;

  LeaveWorkUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(
      LeaveWorkRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.leaveWork(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
