import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/project_repository_interface.dart';

class CreateColumnUseCase extends UseCase<BaseApiResponse, CreateColumnRequestInterface> {
  ProjectRepository _repository;

  CreateColumnUseCase(this._repository);

  @override
  Future<Stream<BaseApiResponse?>> buildUseCaseStream(
    CreateColumnRequestInterface? params,
  ) async {
    final StreamController<BaseApiResponse> _controller = StreamController();
    try {
      BaseApiResponse result = await _repository.createColumn(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
