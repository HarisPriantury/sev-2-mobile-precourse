import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/user_repository_interface.dart';
import 'package:mobile_sev2/domain/user.dart';

class GetSuiteProfileUseCase
    extends UseCase<User, GetSuiteProfileRequestInterface> {
  UserRepository _repository;

  GetSuiteProfileUseCase(this._repository);

  @override
  Future<Stream<User?>> buildUseCaseStream(
      GetSuiteProfileRequestInterface? params) async {
    final StreamController<User> _controller = StreamController();
    try {
      User user = await _repository.getSuiteProfile(params!);
      _controller.add(user);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
