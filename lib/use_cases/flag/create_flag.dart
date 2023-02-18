import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/flag_repository.dart';

class CreateFlagUseCase extends UseCase<bool, CreateFlagRequestInterface> {
  FlagRepository _repository;

  CreateFlagUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(CreateFlagRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.create(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }

}