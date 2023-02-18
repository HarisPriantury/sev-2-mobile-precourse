import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/project_repository_interface.dart';

class EditColumnUseCase extends UseCase<BaseApiResponse, EditColumnRequestInterface> {
  ProjectRepository _repository;

  EditColumnUseCase(this._repository);

  @override
  Future<Stream<BaseApiResponse?>> buildUseCaseStream(
    EditColumnRequestInterface? request,
  ) async {
    final StreamController<BaseApiResponse> _controller = StreamController();
    try {
      BaseApiResponse result = await _repository.editColumn(request!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
