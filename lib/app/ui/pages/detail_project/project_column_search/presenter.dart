import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/move_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/use_cases/project/get_project_column_ticket.dart';
import 'package:mobile_sev2/use_cases/project/move_ticket.dart';

class ProjectColumnSearchPresenter extends Presenter {
  MoveTicketUseCase _moveTicketUseCase;
  GetProjectColumnTicketUseCase _columnTicketUseCase;
  ProjectColumnSearchPresenter(
      this._moveTicketUseCase, this._columnTicketUseCase);

  late Function moveTicketOnNext;
  late Function moveTicketOnComplete;
  late Function moveTicketOnError;

  late Function getColumnsTicketOnNext;
  late Function getColumnsTicketOnComplete;
  late Function getColumnsTicketOnError;

  // move tickets
  void onMoveTicket(MoveTicketRequestInterface req) {
    if (req is MoveTicketApiRequest) {
      _moveTicketUseCase.execute(_MoveTicketObserver(this), req);
    }
  }

  void onGetColumnTicket(GetProjectColumnTicketRequestInterface req) {
    if (req is GetProjectColumnTicketApiRequest) {
      _columnTicketUseCase.execute(_GetColumnTicketObserver(this), req);
    }
  }

  @override
  void dispose() {}
}

class _MoveTicketObserver implements Observer<List<BaseApiResponse>> {
  ProjectColumnSearchPresenter _presenter;

  _MoveTicketObserver(this._presenter);

  void onNext(List<BaseApiResponse>? response) {
    _presenter.moveTicketOnNext(response);
  }

  void onComplete() {
    _presenter.moveTicketOnComplete();
  }

  void onError(e) {
    _presenter.moveTicketOnError(e);
  }
}

class _GetColumnTicketObserver implements Observer<List<ProjectColumn>> {
  ProjectColumnSearchPresenter _presenter;

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
