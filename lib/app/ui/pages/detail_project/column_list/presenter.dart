import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/reorder_column_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/use_cases/project/get_project_column_ticket.dart';
import 'package:mobile_sev2/use_cases/project/reorder_column.dart';

class ColumnListPresenter extends Presenter {
  GetProjectColumnTicketUseCase _columnTicketUseCase;
  ReorderColumnUseCase _reorderColumnUseCase;

  ColumnListPresenter(
    this._columnTicketUseCase,
    this._reorderColumnUseCase,
  );

  late Function getColumnsTicketOnNext;
  late Function getColumnsTicketOnComplete;
  late Function getColumnsTicketOnError;

  late Function reorderColumnOnNext;
  late Function reorderColumnOnComplete;
  late Function reorderColumnOnError;

  void onGetColumnTicket(GetProjectColumnTicketRequestInterface req) {
    if (req is GetProjectColumnTicketApiRequest) {
      _columnTicketUseCase.execute(_GetColumnTicketObserver(this), req);
    }
  }

  void onReorderColumn(ReorderColumnRequestInterface req, int columnIdx) {
    if (req is ReorderColumnApiRequest) {
      _reorderColumnUseCase.execute(_ReorderColumnObserver(this, columnIdx), req);
    }
  }

  @override
  void dispose() {
    _columnTicketUseCase.dispose();
    _reorderColumnUseCase.dispose();
  }
}

class _GetColumnTicketObserver implements Observer<List<ProjectColumn>> {
  ColumnListPresenter _presenter;

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

class _ReorderColumnObserver implements Observer<BaseApiResponse> {
  ColumnListPresenter _presenter;
  int _columnIdx;

  _ReorderColumnObserver(this._presenter, this._columnIdx);

  void onNext(BaseApiResponse? response) {
    _presenter.reorderColumnOnNext(response, _columnIdx);
  }

  void onComplete() {
    _presenter.reorderColumnOnComplete();
  }

  void onError(e) {
    _presenter.reorderColumnOnError(e);
  }
}
