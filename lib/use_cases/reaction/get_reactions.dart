import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/reaction_repository_interface.dart';
import 'package:mobile_sev2/domain/reaction.dart';

class GetReactionsUseCase extends UseCase<List<Reaction>, GetReactionsRequestInterface> {
  ReactionRepository _repository;

  GetReactionsUseCase(this._repository);

  @override
  Future<Stream<List<Reaction>?>> buildUseCaseStream(GetReactionsRequestInterface? params) async {
    final StreamController<List<Reaction>> _controller = StreamController();
    try {
      List<Reaction> reactions = await _repository.findAll(params!);
      _controller.add(reactions);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
