import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';

class StoreListUserDbUseCase extends UseCase<bool, StoreListUserDbRequestInterface> {
  LobbyRepository _repository;
  StoreListUserDbUseCase(this._repository);
  @override
  Future<Stream<bool?>> buildUseCaseStream(StoreListUserDbRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.storeListUser(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
