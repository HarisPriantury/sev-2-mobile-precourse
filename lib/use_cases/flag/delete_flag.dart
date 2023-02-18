import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/flag_repository.dart';

class DeleteFlagUseCase extends UseCase<bool, DeleteFlagRequestInterface> {
  FlagRepository _repository;

  DeleteFlagUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(DeleteFlagRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.delete(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }

}