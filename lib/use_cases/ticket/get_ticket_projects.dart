import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/ticket_repository_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class GetTicketProjectsUseCase extends UseCase<TicketProjectInfo, GetTicketInfoRequestInterface> {
  TicketRepository _repository;

  GetTicketProjectsUseCase(this._repository);

  @override
  Future<Stream<TicketProjectInfo?>> buildUseCaseStream(GetTicketInfoRequestInterface? params) async {
    final StreamController<TicketProjectInfo> _controller = StreamController();
    try {
      TicketProjectInfo subs = await _repository.findProjectInfo(params!);
      _controller.add(subs);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
