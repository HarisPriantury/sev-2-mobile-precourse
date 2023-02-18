import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/reaction_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';

class GetObjectReactionsUseCase
    extends UseCase<List<ObjectReactions>, GetObjectReactionsRequestInterface> {
  ReactionRepository _repository;

  GetObjectReactionsUseCase(this._repository);

  @override
  Future<Stream<List<ObjectReactions>?>> buildUseCaseStream(
      GetObjectReactionsRequestInterface? params) async {
    final StreamController<List<ObjectReactions>> _controller =
        StreamController();
    try {
      List<ObjectReactions> reactions =
          await _repository.findObjectReactions(params!);
      _controller.add(reactions);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
