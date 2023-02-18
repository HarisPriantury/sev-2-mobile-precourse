import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/repositories/db/search_db_repository.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';

class AddSearchHistoryUseCase extends UseCase<bool, AddSearchHistoryRequestInterface> {
  SearchDBRepository _repository;

  AddSearchHistoryUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(AddSearchHistoryRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool state = await _repository.create(params!);
      _controller.add(state);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
