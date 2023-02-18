import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class GetLobbyRoomTicketsUseCase
    extends UseCase<List<Ticket>, GetLobbyRoomTasksRequestInterface> {
  LobbyRepository _repository;

  GetLobbyRoomTicketsUseCase(this._repository);

  @override
  Future<Stream<List<Ticket>?>> buildUseCaseStream(
      GetLobbyRoomTasksRequestInterface? params) async {
    final StreamController<List<Ticket>> _controller = StreamController();
    try {
      List<Ticket> tickets = await _repository.getTickets(params!);
      _controller.add(tickets);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
