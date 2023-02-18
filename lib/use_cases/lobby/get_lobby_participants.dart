import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/user.dart';

class GetLobbyParticipantsUseCase
    extends UseCase<List<User>, GetLobbyParticipantsRequestInterface> {
  LobbyRepository _repository;

  GetLobbyParticipantsUseCase(this._repository);

  @override
  Future<Stream<List<User>?>> buildUseCaseStream(
      GetLobbyParticipantsRequestInterface? params) async {
    final StreamController<List<User>> _controller = StreamController();
    try {
      List<User> users = await _repository.getParticipants(params!);
      _controller.add(users);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
