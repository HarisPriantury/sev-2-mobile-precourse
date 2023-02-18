import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';

class GetLobbyRoomCalendarUseCase
    extends UseCase<List<Calendar>, GetLobbyRoomCalendarRequestInterface> {
  LobbyRepository _repository;

  GetLobbyRoomCalendarUseCase(this._repository);

  @override
  Future<Stream<List<Calendar>?>> buildUseCaseStream(
      GetLobbyRoomCalendarRequestInterface? params) async {
    final StreamController<List<Calendar>> _controller = StreamController();
    try {
      List<Calendar> calendars = await _repository.getCalendars(params!);
      _controller.add(calendars);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
