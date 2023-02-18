import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/user_repository_interface.dart';
import 'package:mobile_sev2/domain/user.dart';

class GetUsersUseCase extends UseCase<List<User>, GetUsersRequestInterface> {
  UserRepository _repository;

  GetUsersUseCase(this._repository);

  @override
  Future<Stream<List<User>?>> buildUseCaseStream(
      GetUsersRequestInterface? params) async {
    final StreamController<List<User>> _controller = StreamController();
    try {
      List<User> users = await _repository.findAll(params!);
      _controller.add(users);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
