import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/stickit.dart';

class GetLobbyRoomStickitsUseCase
    extends UseCase<List<Stickit>, GetLobbyRoomStickitsRequestInterface> {
  LobbyRepository _repository;

  GetLobbyRoomStickitsUseCase(this._repository);

  @override
  Future<Stream<List<Stickit>?>> buildUseCaseStream(
      GetLobbyRoomStickitsRequestInterface? params) async {
    final StreamController<List<Stickit>> _controller = StreamController();
    try {
      List<Stickit> stickits = await _repository.getStickits(params!);
      _controller.add(stickits);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
