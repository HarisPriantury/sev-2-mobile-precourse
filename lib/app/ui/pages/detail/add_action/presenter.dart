import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_ticket_info_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/use_cases/project/get_project_column_ticket.dart';
import 'package:mobile_sev2/use_cases/ticket/get_ticket_projects.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';

class AddActionPresenter extends Presenter {
  GetTicketsUseCase _ticketsUseCase;
  GetProjectColumnTicketUseCase _columnTicketUseCase;
  final GetTicketProjectsUseCase _ticketProjectsUseCase;

  AddActionPresenter(
    this._ticketsUseCase,
    this._columnTicketUseCase,
    this._ticketProjectsUseCase,
  );

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // get columns
  late Function getColumnsTicketOnNext;
  late Function getColumnsTicketOnComplete;
  late Function getColumnsTicketOnError;

  // get ticket projects
  late Function getTicketProjectsOnNext;
  late Function getTicketProjectsOnComplete;
  late Function getTicketProjectsOnError;

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketsUseCase.execute(
        _GetTicketsObserver(this, PersistenceType.api),
        req,
      );
    }
  }

  void onGetColumnTicket(GetProjectColumnTicketRequestInterface req) {
    if (req is GetProjectColumnTicketApiRequest) {
      _columnTicketUseCase.execute(_GetColumnTicketObserver(this), req);
    }
  }

  void onGetTicketProjects(GetTicketInfoRequestInterface req) {
    if (req is GetTicketInfoApiRequest) {
      _ticketProjectsUseCase.execute(
          _GetTicketProjectsObserver(this, PersistenceType.api), req);
    }
  }

  @override
  void dispose() {
    _ticketsUseCase.dispose();
    _columnTicketUseCase.dispose();
    _ticketProjectsUseCase.dispose();
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  AddActionPresenter _presenter;
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

class _GetColumnTicketObserver implements Observer<List<ProjectColumn>> {
  AddActionPresenter _presenter;

  _GetColumnTicketObserver(this._presenter);

  void onNext(List<ProjectColumn>? columns) {
    _presenter.getColumnsTicketOnNext(columns);
  }

  void onComplete() {
    _presenter.getColumnsTicketOnComplete();
  }

  void onError(e) {
    _presenter.getColumnsTicketOnError(e);
  }
}

class _GetTicketProjectsObserver implements Observer<TicketProjectInfo> {
  final AddActionPresenter _presenter;
  final PersistenceType _type;

  _GetTicketProjectsObserver(this._presenter, this._type);

  @override
  void onNext(TicketProjectInfo? response) {
    _presenter.getTicketProjectsOnNext(response, _type);
  }

  @override
  void onComplete() {
    _presenter.getTicketProjectsOnComplete(_type);
  }

  @override
  void onError(e) {
    _presenter.getTicketProjectsOnError(e, _type);
  }
}
