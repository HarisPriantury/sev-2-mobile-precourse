import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/repositories/db/search_db_repository.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/domain/meta/search_history.dart';

class GetSearchHistoryUseCase extends UseCase<List<SearchHistory>, GetSearchHistoryRequestInterface> {
  SearchDBRepository _repository;

  GetSearchHistoryUseCase(this._repository);

  @override
  Future<Stream<List<SearchHistory>?>> buildUseCaseStream(
      GetSearchHistoryRequestInterface? params) async {
    final StreamController<List<SearchHistory>> _controller = StreamController();
    try {
      List<SearchHistory> histories = await _repository.findAll(params!);
      _controller.add(histories);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
