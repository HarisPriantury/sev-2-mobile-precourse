import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'package:mobile_sev2/data/payload/contracts/mood_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/mood_repository_interface.dart';
import 'package:mobile_sev2/domain/mood.dart';

class GetMoodsUseCase extends UseCase<List<Mood>, GetMoodsRequestInterface> {
  MoodRepository _repository;

  GetMoodsUseCase(this._repository);

  @override
  Future<Stream<List<Mood>?>> buildUseCaseStream(GetMoodsRequestInterface? params) async {
    final StreamController<List<Mood>> _controller = StreamController();
    try {
      List<Mood> moods = await _repository.findAll(params!);
      _controller.add(moods);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
