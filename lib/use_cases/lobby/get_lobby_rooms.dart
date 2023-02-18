import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/room.dart';

class GetLobbyRoomsUseCase
    extends UseCase<List<Room>, GetLobbyRoomsRequestInterface> {
  LobbyRepository _repository;

  GetLobbyRoomsUseCase(this._repository);

  @override
  Future<Stream<List<Room>?>> buildUseCaseStream(
      GetLobbyRoomsRequestInterface? params) async {
    final StreamController<List<Room>> _controller = StreamController();
    try {
      List<Room> rooms = await _repository.getRooms(params!);
      _controller.add(rooms);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
