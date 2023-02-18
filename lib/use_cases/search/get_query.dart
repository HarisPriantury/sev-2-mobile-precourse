import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/repositories/db/search_db_repository.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/domain/query.dart';

class GetQueryUseCase extends UseCase<List<Query>, GetQueryRequestInterface> {
  SearchDBRepository _repository;

  GetQueryUseCase(this._repository);

  @override
  Future<Stream<List<Query>?>> buildUseCaseStream(GetQueryRequestInterface? params) async {
    final StreamController<List<Query>> _controller = StreamController();
    try {
      List<Query> queries = await _repository.findAllQueries(params!);
      _controller.add(queries);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
