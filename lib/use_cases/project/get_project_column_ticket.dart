import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/project_repository_interface.dart';
import 'package:mobile_sev2/domain/project.dart';

class GetProjectColumnTicketUseCase extends UseCase<List<ProjectColumn>, GetProjectColumnTicketRequestInterface> {
  ProjectRepository _repository;

  GetProjectColumnTicketUseCase(this._repository);

  @override
  Future<Stream<List<ProjectColumn>?>> buildUseCaseStream(
    GetProjectColumnTicketRequestInterface? params,
  ) async {
    final StreamController<List<ProjectColumn>> _controller = StreamController();
    try {
      List<ProjectColumn> columns = await _repository.getColumnTicket(params!);
      _controller.add(columns);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
