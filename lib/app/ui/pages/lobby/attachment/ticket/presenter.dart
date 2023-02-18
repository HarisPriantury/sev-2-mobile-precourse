import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_tasks_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_tickets.dart';

class RoomTicketPresenter extends Presenter {
  GetLobbyRoomTicketsUseCase _ticketUseCase;

  RoomTicketPresenter(this._ticketUseCase);

  // tickets
  late Function getLobbyRoomTicketsOnNext;
  late Function getLobbyRoomTicketsOnComplete;
  late Function getLobbyRoomTicketsOnError;

  void onGetLobbyRoomTickets(GetLobbyRoomTasksRequestInterface req) {
    if (req is GetLobbyRoomTasksApiRequest) {
      _ticketUseCase.execute(_GetLobbyRoomTicketsObserver(this), req);
    }
  }

  @override
  void dispose() {
    _ticketUseCase.dispose();
  }
}

class _GetLobbyRoomTicketsObserver implements Observer<List<Ticket>> {
  RoomTicketPresenter _presenter;

  _GetLobbyRoomTicketsObserver(this._presenter);

  void onNext(List<Ticket>? tickets) {
    _presenter.getLobbyRoomTicketsOnNext(tickets);
  }

  void onComplete() {
    _presenter.getLobbyRoomTicketsOnComplete();
  }

  void onError(e) {
    _presenter.getLobbyRoomTicketsOnError(e);
  }
}
