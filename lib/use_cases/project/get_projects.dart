import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/project_repository_interface.dart';
import 'package:mobile_sev2/domain/project.dart';

class GetProjectsUseCase
    extends UseCase<List<Project>, GetProjectsRequestInterface> {
  ProjectRepository _repository;

  GetProjectsUseCase(this._repository);

  @override
  Future<Stream<List<Project>?>> buildUseCaseStream(
      GetProjectsRequestInterface? params) async {
    final StreamController<List<Project>> _controller = StreamController();
    try {
      List<Project> projects = await _repository.findAll(params!);
      _controller.add(projects);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
