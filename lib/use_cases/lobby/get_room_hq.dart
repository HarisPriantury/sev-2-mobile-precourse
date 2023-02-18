import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/room.dart';

class GetRoomHQUseCase extends UseCase<Room, GetRoomHQRequestInterface> {
  LobbyRepository _repository;

  GetRoomHQUseCase(this._repository);

  @override
  Future<Stream<Room?>> buildUseCaseStream(
      GetRoomHQRequestInterface? params) async {
    final StreamController<Room> _controller = StreamController();
    try {
      Room room = await _repository.getHQ(params!);
      _controller.add(room);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
