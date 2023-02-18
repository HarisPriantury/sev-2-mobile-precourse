import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/edit_column_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/move_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/use_cases/project/edit_column.dart';
import 'package:mobile_sev2/use_cases/project/get_project_column_ticket.dart';
import 'package:mobile_sev2/use_cases/project/move_ticket.dart';

class WorkboardPresenter extends Presenter {
  GetProjectColumnTicketUseCase _columnTicketUseCase;
  MoveTicketUseCase _moveTicketUseCase;
  EditColumnUseCase _editColumnUseCase;

  WorkboardPresenter(
    this._columnTicketUseCase,
    this._moveTicketUseCase,
    this._editColumnUseCase,
  );

  late Function getColumnsTicketOnNext;
  late Function getColumnsTicketOnComplete;
  late Function getColumnsTicketOnError;

  late Function moveTicketOnNext;
  late Function moveTicketOnComplete;
  late Function moveTicketOnError;

  late Function editColumnOnNext;
  late Function editColumnOnComplete;
  late Function editColumnOnError;

  void onGetColumnTicket(GetProjectColumnTicketRequestInterface req) {
    if (req is GetProjectColumnTicketApiRequest) {
      _columnTicketUseCase.execute(_GetColumnTicketObserver(this), req);
    }
  }

  void onMoveTicket(MoveTicketRequestInterface req) {
    if (req is MoveTicketApiRequest) {
      _moveTicketUseCase.execute(_MoveTicketObserver(this), req);
    }
  }

  void onEditColumn(EditColumnRequestInterface req) {
    if (req is EditColumnApiRequest) {
      _editColumnUseCase.execute(_EditColumnObserver(this), req);
    }
  }

  @override
  void dispose() {
    _columnTicketUseCase.dispose();
    _moveTicketUseCase.dispose();
    _editColumnUseCase.dispose();
  }
}

class _GetColumnTicketObserver implements Observer<List<ProjectColumn>> {
  WorkboardPresenter _presenter;

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

class _MoveTicketObserver implements Observer<List<BaseApiResponse>> {
  WorkboardPresenter _presenter;

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

class _EditColumnObserver implements Observer<BaseApiResponse> {
  WorkboardPresenter _presenter;

  _EditColumnObserver(this._presenter);

  void onNext(BaseApiResponse? response) {
    _presenter.editColumnOnNext(response);
  }

  void onComplete() {
    _presenter.editColumnOnComplete();
  }

  void onError(e) {
    _presenter.editColumnOnError(e);
  }
}
