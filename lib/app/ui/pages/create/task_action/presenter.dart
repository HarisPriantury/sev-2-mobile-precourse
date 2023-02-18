import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/ticket/task_transaction.dart';

class TaskActionPresenter extends Presenter {
  GetTicketsUseCase _ticketsUseCase;
  TaskTransactionUseCase _taskTransactionUseCase;

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  late Function taskTransactionOnNext;
  late Function taskTransactionOnComplete;
  late Function taskTransactionOnError;

  TaskActionPresenter(
    this._ticketsUseCase,
    this._taskTransactionUseCase,
  );

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketsUseCase.execute(_GetTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onRemoveSubtask(TaskTransactionRequestInterface req) {
    if (req is CreateLobbyRoomTicketApiRequest) {
      _taskTransactionUseCase.execute(_TaskTransactionObserver(this), req);
    }
  }

  void onAddSubtask(TaskTransactionRequestInterface req) {
    if (req is CreateLobbyRoomTicketApiRequest) {
      _taskTransactionUseCase.execute(_TaskTransactionObserver(this), req);
    }
  }

  void onMergedTask(TaskTransactionRequestInterface req) {
    if (req is CreateLobbyRoomTicketApiRequest) {
      _taskTransactionUseCase.execute(_TaskTransactionObserver(this), req);
    }
  }

  void onRemoveMergedTask(TaskTransactionRequestInterface req) {
    if (req is CreateLobbyRoomTicketApiRequest) {
      _taskTransactionUseCase.execute(_TaskTransactionObserver(this), req);
    }
  }

  @override
  void dispose() {
    _ticketsUseCase.dispose();
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  TaskActionPresenter _presenter;
  PersistenceType _type;

  _GetTicketsObserver(this._presenter, this._type);

  void onNext(List<Ticket>? tickets) {
    _presenter.getTicketsOnNext(tickets, _type);
  }

  void onComplete() {
    _presenter.getTicketsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTicketsOnError(e, _type);
  }
}

class _TaskTransactionObserver implements Observer<bool> {
  TaskActionPresenter _presenter;

  _TaskTransactionObserver(this._presenter);

  void onNext(bool? result) {
    _presenter.taskTransactionOnNext(result);
  }

  void onComplete() {
    _presenter.taskTransactionOnComplete();
  }

  void onError(e) {
    _presenter.taskTransactionOnError(e);
  }
}
