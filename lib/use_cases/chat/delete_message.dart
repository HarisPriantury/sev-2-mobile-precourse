import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/chat_repository_interface.dart';

class DeleteMessageUseCase extends UseCase<bool, DeleteMessageRequestInterface> {
  ChatRepository _repository;
  DeleteMessageUseCase(this._repository);
  @override
  Future<Stream<bool?>> buildUseCaseStream(DeleteMessageRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.deleteMessage(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
