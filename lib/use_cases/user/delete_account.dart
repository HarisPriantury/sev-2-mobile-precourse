import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/user_repository_interface.dart';

class UserDeleteAccountUseCase
    extends UseCase<bool, UserDeleteAccountRequestInterface> {
  UserRepository _repository;

  UserDeleteAccountUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(
      UserDeleteAccountRequestInterface? req) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.deleteAccount(req!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
