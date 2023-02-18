import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/project_repository_interface.dart';

class MoveTicketUseCase extends UseCase<List<BaseApiResponse>, MoveTicketRequestInterface> {
  ProjectRepository _repository;

  MoveTicketUseCase(this._repository);

  @override
  Future<Stream<List<BaseApiResponse>?>> buildUseCaseStream(
    MoveTicketRequestInterface? request,
  ) async {
    final StreamController<List<BaseApiResponse>> _controller =
        StreamController();
    try {
      List<BaseApiResponse> result = await _repository.moveTicket(request!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
