import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/ticket_repository_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class GetTicketSubscribersUseCase extends UseCase<TicketSubscriberInfo, GetTicketInfoRequestInterface> {
  TicketRepository _repository;

  GetTicketSubscribersUseCase(this._repository);

  @override
  Future<Stream<TicketSubscriberInfo?>> buildUseCaseStream(GetTicketInfoRequestInterface? params) async {
    final StreamController<TicketSubscriberInfo> _controller = StreamController();
    try {
      TicketSubscriberInfo subs = await _repository.findInfo(params!);
      _controller.add(subs);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
