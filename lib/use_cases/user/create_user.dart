import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/user_repository_interface.dart';

class CreateUserUseCase extends UseCase<bool, CreateUserRequestInterface> {
  UserRepository _repository;

  CreateUserUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(
      CreateUserRequestInterface? req) async {
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
