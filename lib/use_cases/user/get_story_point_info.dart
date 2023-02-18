import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/user_repository_interface.dart';
import 'package:mobile_sev2/domain/user.dart';

class GetStoryPointUseCase
    extends UseCase<StoryPointInfo, GetStoryPointInfoRequestInterface> {
  UserRepository _repository;

  GetStoryPointUseCase(this._repository);

  @override
  Future<Stream<StoryPointInfo?>> buildUseCaseStream(
      GetStoryPointInfoRequestInterface? params) async {
    final StreamController<StoryPointInfo> _controller = StreamController();
    try {
      StoryPointInfo spInfo = await _repository.getStoryPointInfo(params!);
      _controller.add(spInfo);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
