import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/room_repository_interface.dart';
import 'package:mobile_sev2/domain/user.dart';

class GetRoomParticipantsUseCase
    extends UseCase<List<User>, GetParticipantsRequestInterface> {
  RoomRepository _repository;

  GetRoomParticipantsUseCase(this._repository);

  @override
  Future<Stream<List<User>?>> buildUseCaseStream(
      GetParticipantsRequestInterface? params) async {
    final StreamController<List<User>> _controller = StreamController();
    try {
      List<User> participants = await _repository.getParticipants(params!);
      _controller.add(participants);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
