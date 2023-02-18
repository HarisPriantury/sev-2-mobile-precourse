import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/auth_repository_interface.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class JoinWorkspaceUseCase extends UseCase<int, JoinWorkspaceRequestInterface> {
  AuthRepository _repository;

  JoinWorkspaceUseCase(this._repository);

  @override
  Future<Stream<int>> buildUseCaseStream(
      JoinWorkspaceRequestInterface? params) async {
    final StreamController<int> _controller = StreamController();
    try {
      int result = await _repository.joinWorkspace(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}