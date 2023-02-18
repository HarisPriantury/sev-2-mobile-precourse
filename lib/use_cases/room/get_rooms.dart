import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/room_repository_interface.dart';
import 'package:mobile_sev2/domain/room.dart';

class GetRoomsUseCase extends UseCase<List<Room>, GetRoomsRequestInterface> {
  RoomRepository _repository;

  GetRoomsUseCase(this._repository);

  @override
  Future<Stream<List<Room>?>> buildUseCaseStream(
      GetRoomsRequestInterface? params) async {
    final StreamController<List<Room>> _controller = StreamController();
    try {
      List<Room> rooms = await _repository.findAll(params!);
      _controller.add(rooms);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
