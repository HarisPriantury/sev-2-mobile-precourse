import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/auth/get_workspace_db_request.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:mobile_sev2/use_cases/auth/get_workspace.dart';

class WorkspaceLoginPresenter extends Presenter {
  GetWorkspaceUseCase _getWorkspaceUseCase;

  late Function getWorkspaceOnNext;
  late Function getWorkspaceOnComplete;
  late Function getWorkspaceOnError;

  WorkspaceLoginPresenter(this._getWorkspaceUseCase);

  void onGetWorkspace(GetWorkspaceRequestInterface req) {
    if (req is GetWorkspaceDBRequest) {
      _getWorkspaceUseCase.execute(_GetWorkspaceObserver(this), req);
    }
  }

  @override
  void dispose() {
    _getWorkspaceUseCase.dispose();
  }
}

class _GetWorkspaceObserver implements Observer<List<Workspace>> {
  WorkspaceLoginPresenter _presenter;

  _GetWorkspaceObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getWorkspaceOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getWorkspaceOnError(e);
  }

  @override
  void onNext(List<Workspace>? response) {
    _presenter.getWorkspaceOnNext(response);
  }
}
