import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/public_space_repository_interface.dart';
import 'package:mobile_sev2/domain/room.dart';

class GetPublicSpaceUseCase extends UseCase<Room, GetPublicSpaceRequestInterface> {
  PublicSpaceRepository _repository;

  GetPublicSpaceUseCase(this._repository);

  @override
  Future<Stream<Room?>> buildUseCaseStream(GetPublicSpaceRequestInterface? params) async {
    final StreamController<Room> _controller = StreamController();
    try {
      Room result = await _repository.getPublicSpace(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
