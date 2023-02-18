import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/room_repository_interface.dart';

class RestoreRoomUseCase extends UseCase<bool, RestoreRoomRequestInterface> {
  RoomRepository _repository;
  RestoreRoomUseCase(this._repository);
  @override
  Future<Stream<bool?>> buildUseCaseStream(RestoreRoomRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.restoreRoom(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
