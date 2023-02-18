import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/public_space_repository_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';

class GetMessagesPublicSpaceUseCase extends UseCase<List<Chat>, GetMessagesPublicSpaceRequestInterface> {
  PublicSpaceRepository _repository;

  GetMessagesPublicSpaceUseCase(this._repository);

  @override
  Future<Stream<List<Chat>?>> buildUseCaseStream(GetMessagesPublicSpaceRequestInterface? params) async {
    final StreamController<List<Chat>> _controller = StreamController();
    try {
      List<Chat> result = await _repository.findAll(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
