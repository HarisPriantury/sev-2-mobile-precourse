import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/mood_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/mood_repository_interface.dart';

class SendMoodUseCase extends UseCase<bool, SendMoodRequestInterface> {
  MoodRepository _repository;

  SendMoodUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(SendMoodRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.sendMood(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
