import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/auth_repository_interface.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class GetWorkspaceUseCase extends UseCase<List<Workspace>, GetWorkspaceRequestInterface> {
  AuthRepository _repository;

  GetWorkspaceUseCase(this._repository);

  @override
  Future<Stream<List<Workspace>>> buildUseCaseStream(
      GetWorkspaceRequestInterface? params) async {
    final StreamController<List<Workspace>> _controller = StreamController();
    try {
      List<Workspace> result = await _repository.getWorkspace(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}