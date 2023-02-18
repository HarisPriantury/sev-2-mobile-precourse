import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/repositories/db/search_db_repository.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';

class DeleteQueryUseCase extends UseCase<bool, DeleteQueryRequestInterface> {
  SearchDBRepository _repository;

  DeleteQueryUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(DeleteQueryRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool state = await _repository.deleteQuery(params!);
      _controller.add(state);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
