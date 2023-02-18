import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/auth/join_workspace_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:mobile_sev2/use_cases/auth/get_token.dart';
import 'package:mobile_sev2/use_cases/auth/get_workspace.dart';
import 'package:mobile_sev2/use_cases/auth/join_workspace.dart';
import 'package:mobile_sev2/use_cases/public_space/get_public_space.dart';

class PublicSpacePresenter extends Presenter {
  GetWorkspaceUseCase _getWorkspaceUseCase;
  GetPublicSpaceUseCase _getPublicSpaceUseCase;
  GetTokenUseCase _getTokenUseCase;
  JoinWorkspaceUseCase _joinWorkspaceUseCase;

  PublicSpacePresenter(
    this._getWorkspaceUseCase,
    this._getPublicSpaceUseCase,
    this._getTokenUseCase,
    this._joinWorkspaceUseCase,
  );

  late Function getWorkspaceOnNext;
  late Function getWorkspaceOnComplete;
  late Function getWorkspaceOnError;

  late Function getPublicSpaceOnNext;
  late Function getPublicSpaceOnComplete;
  late Function getPublicSpaceOnError;

  late Function getTokenOnNext;
  late Function getTokenOnComplete;
  late Function getTokenOnError;

  late Function joinWorkspaceOnNext;
  late Function joinWorkspaceOnComplete;
  late Function joinWorkspaceOnError;

  void onGetWorkspace(GetWorkspaceRequestInterface req) {
    _getWorkspaceUseCase.execute(_GetWorkspaceObserver(this), req);
  }

  void onGetPublicSpace(GetPublicSpaceRequestInterface req, int id) {
    _getPublicSpaceUseCase.execute(_GetPublicSpaceObserver(this, id), req);
  }

  void onGetToken(GetTokenRequestInterface req) {
    if (req is GetTokenApiRequest) {
      _getTokenUseCase.execute(_GetTokenObserver(this, req.workspace), req);
    }
  }

  void onJoinWorkspace(JoinWorkspaceRequestInterface req) {
    if (req is JoinWorkspaceApiRequest) {
      _joinWorkspaceUseCase.execute(_JoinWorkspaceObserver(this, req.workspaceName), req);
    }
  }

  @override
  void dispose() {
    _getWorkspaceUseCase.dispose();
    _getPublicSpaceUseCase.dispose();
    _getTokenUseCase.dispose();
  }
}

class _GetWorkspaceObserver implements Observer<List<Workspace>> {
  PublicSpacePresenter _presenter;

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

class _GetPublicSpaceObserver implements Observer<Room> {
  PublicSpacePresenter _presenter;
  int _id;

  _GetPublicSpaceObserver(this._presenter, this._id);

  @override
  void onComplete() {
    _presenter.getPublicSpaceOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getPublicSpaceOnError(e);
  }

  @override
  void onNext(Room? response) {
    _presenter.getPublicSpaceOnNext(response, _id);
  }
}

class _GetTokenObserver implements Observer<BaseApiResponse> {
  PublicSpacePresenter _presenter;
  String workspace;

  _GetTokenObserver(
    this._presenter,
    this.workspace,
  );

  void onNext(BaseApiResponse? resp) {
    _presenter.getTokenOnNext(resp, workspace);
  }

  void onComplete() {
    _presenter.getTokenOnComplete();
  }

  void onError(e) {
    _presenter.getTokenOnError(e, workspace);
  }
}

class _JoinWorkspaceObserver implements Observer<int> {
  PublicSpacePresenter _presenter;
  String workspaceName;

  _JoinWorkspaceObserver(this._presenter, this.workspaceName);

  @override
  void onComplete() {
    _presenter.joinWorkspaceOnComplete();
  }

  @override
  void onError(e) {
    _presenter.joinWorkspaceOnError(e);
  }

  @override
  void onNext(int? response) {
    _presenter.joinWorkspaceOnNext(response, workspaceName);
  }
}
