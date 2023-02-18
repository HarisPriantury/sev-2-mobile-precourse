import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/topic_repository_interface.dart';

class GetSubscribeListUseCase extends UseCase<void, SubscribeListRequestInterface> {
  TopicRepository _repository;

  GetSubscribeListUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(SubscribeListRequestInterface? params) async {
    final StreamController<void> _controller = StreamController();
    try {
      void results = await _repository.subscribeList(params!);
      _controller.add(results);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
