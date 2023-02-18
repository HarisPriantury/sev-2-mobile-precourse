import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/auth_repository_interface.dart';

class UpdateWorkspaceUseCase extends UseCase<bool, UpdateWorkspaceRequestInterface> {
  AuthRepository _repository;

  UpdateWorkspaceUseCase(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(
      UpdateWorkspaceRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.updateWorkspace(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}