import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/project_repository_interface.dart';
import 'package:mobile_sev2/domain/project.dart';

class GetProjectColumnsUseCase extends UseCase<List<ProjectColumn>, GetProjectColumnsRequestInterface> {
  ProjectRepository _repository;

  GetProjectColumnsUseCase(this._repository);

  @override
  Future<Stream<List<ProjectColumn>?>> buildUseCaseStream(GetProjectColumnsRequestInterface? params) async {
    final StreamController<List<ProjectColumn>> _controller = StreamController();
    try {
      List<ProjectColumn> columns = await _repository.getColumns(params!);
      _controller.add(columns);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
