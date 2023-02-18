import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/ticket_repository_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class GetTicketsUseCase extends UseCase<List<Ticket>, GetTicketsRequestInterface> {
  TicketRepository _repository;

  GetTicketsUseCase(this._repository);

  @override
  Future<Stream<List<Ticket>?>> buildUseCaseStream(GetTicketsRequestInterface? params) async {
    final StreamController<List<Ticket>> _controller = StreamController();
    try {
      List<Ticket> tickets = await _repository.findAll(params!);
      _controller.add(tickets);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
