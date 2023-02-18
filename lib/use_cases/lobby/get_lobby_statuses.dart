import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';

class GetLobbyStatusesUseCase
    extends UseCase<List<LobbyStatus>, GetLobbyStatusesRequestInterface> {
  LobbyRepository _repository;

  GetLobbyStatusesUseCase(this._repository);

  @override
  Future<Stream<List<LobbyStatus>?>> buildUseCaseStream(
      GetLobbyStatusesRequestInterface? params) async {
    final StreamController<List<LobbyStatus>> _controller = StreamController();
    try {
      List<LobbyStatus> rooms = await _repository.getStatuses(params!);
      _controller.add(rooms);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
