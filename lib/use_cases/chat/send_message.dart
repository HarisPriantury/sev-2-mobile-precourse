import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/chat_repository_interface.dart';

class SendMessageUseCase extends UseCase<bool, SendMessageRequestInterface> {
  ChatRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(
      SendMessageRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool results = await _repository.sendMessage(params!);
      _controller.add(results);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
