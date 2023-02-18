import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/repositories/db/search_db_repository.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';

class DeleteSearchHistoryUseCase extends UseCase<bool, DeleteSearchHistoryRequestInterface> {
  SearchDBRepository _repository;

  DeleteSearchHistoryUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(DeleteSearchHistoryRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool state = await _repository.delete(params!);
      _controller.add(state);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
