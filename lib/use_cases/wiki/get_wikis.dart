import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/wiki_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/wiki_repository_interface.dart';
import 'package:mobile_sev2/domain/wiki.dart';

class GetWikisUseCase extends UseCase<List<Wiki>, GetWikisRequestInterface> {
  GetWikisUseCase(this._repository);

  WikiRepository _repository;

  @override
  Future<Stream<List<Wiki>?>> buildUseCaseStream(
      GetWikisRequestInterface? params) async {
    final StreamController<List<Wiki>> _controller = StreamController();
    try {
      List<Wiki> wikis = await _repository.findAll(params!);
      _controller.add(wikis);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
