import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/file_repository_interface.dart';
import 'package:mobile_sev2/domain/file.dart';

class GetFilesUseCase extends UseCase<List<File>, GetFilesRequestInterface> {
  FileRepository _repository;

  GetFilesUseCase(this._repository);

  @override
  Future<Stream<List<File>?>> buildUseCaseStream(
      GetFilesRequestInterface? params) async {
    final StreamController<List<File>> _controller = StreamController();
    try {
      List<File> files = await _repository.findAll(params!);
      _controller.add(files);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
