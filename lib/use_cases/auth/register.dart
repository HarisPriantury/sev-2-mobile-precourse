import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/auth_repository_interface.dart';

class RegisterUseCase extends UseCase<BaseApiResponse, RegisterRequestInterface> {
  AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Stream<BaseApiResponse?>> buildUseCaseStream(RegisterRequestInterface? params) async {
    final StreamController<BaseApiResponse> _controller = StreamController();
    try {
      BaseApiResponse results = await _repository.register(params!);
      _controller.add(results);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }

}