import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/reaction_repository_interface.dart';

class GiveReactionUseCase extends UseCase<bool, GiveReactionRequestInterface> {
  ReactionRepository _repository;

  GiveReactionUseCase(this._repository);

  @override
  Future<Stream<bool?>> buildUseCaseStream(
      GiveReactionRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.give(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
