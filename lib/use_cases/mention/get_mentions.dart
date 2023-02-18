import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/mention_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/mention_repository.dart';
import 'package:mobile_sev2/domain/mention.dart';

class GetMentionsUseCase extends UseCase<List<Mention>, GetMentionsRequestInterface> {
  MentionRepository _repository;

  GetMentionsUseCase(this._repository);

  @override
  Future<Stream<List<Mention>?>> buildUseCaseStream(
      GetMentionsRequestInterface? params) async {
    final StreamController<List<Mention>> _controller = StreamController();
    try {
      List<Mention> feeds = await _repository.findAll(params!);
      _controller.add(feeds);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
