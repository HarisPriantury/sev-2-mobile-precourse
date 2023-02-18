import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/room_repository_interface.dart';

class AddRoomParticipantsUseCase
    extends UseCase<bool, AddParticipantsRequestInterface> {
  RoomRepository _repository;

  AddRoomParticipantsUseCase(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(
      AddParticipantsRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.addParticipants(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
