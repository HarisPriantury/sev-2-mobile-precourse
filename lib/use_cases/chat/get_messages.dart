import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/chat_repository_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';

class GetMessagesUseCase
    extends UseCase<List<Chat>, GetMessagesRequestInterface> {
  ChatRepository _repository;

  GetMessagesUseCase(this._repository);

  @override
  Future<Stream<List<Chat>?>> buildUseCaseStream(
      GetMessagesRequestInterface? params) async {
    final StreamController<List<Chat>> _controller = StreamController();
    try {
      List<Chat> messages = await _repository.findAll(params!);
      _controller.add(messages);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
