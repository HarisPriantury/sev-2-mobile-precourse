import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/file.dart';

class GetLobbyRoomFilesUseCase
    extends UseCase<List<File>, GetLobbyRoomFilesRequestInterface> {
  LobbyRepository _repository;

  GetLobbyRoomFilesUseCase(this._repository);

  @override
  Future<Stream<List<File>?>> buildUseCaseStream(
      GetLobbyRoomFilesRequestInterface? params) async {
    final StreamController<List<File>> _controller = StreamController();
    try {
      List<File> file = await _repository.getFiles(params!);
      _controller.add(file);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
