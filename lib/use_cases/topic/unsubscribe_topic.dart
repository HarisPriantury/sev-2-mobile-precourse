import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/topic_repository_interface.dart';

class UnsubscribeTopicUseCase extends UseCase<void, SubscribeTopicRequestInterface> {
  TopicRepository _repository;

  UnsubscribeTopicUseCase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(SubscribeTopicRequestInterface? params) async {
    final StreamController<void> _controller = StreamController();
    try {
      void results = await _repository.unsubscribe(params!);
      _controller.add(results);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
