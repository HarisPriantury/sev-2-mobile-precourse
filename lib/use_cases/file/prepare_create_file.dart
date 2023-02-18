import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/file_repository_interface.dart';

class PrepareCreateFileUseCase
    extends UseCase<bool, PrepareCreateFileRequestInterface> {
  FileRepository _repository;

  PrepareCreateFileUseCase(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(
      PrepareCreateFileRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool results = await _repository.prepare(params!);
      _controller.add(results);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
