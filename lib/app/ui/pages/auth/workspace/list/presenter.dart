import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/public_space/get_public_space_api_request.dart';
import 'package:mobile_sev2/data/payload/api/topic/subscribe_topic_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/auth/delete_workspace_db_request.dart';
import 'package:mobile_sev2/data/payload/db/topic/SubscribeListDBRequest.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:mobile_sev2/use_cases/auth/delete_workspace.dart';
import 'package:mobile_sev2/use_cases/auth/get_token.dart';
import 'package:mobile_sev2/use_cases/auth/get_workspace.dart';
import 'package:mobile_sev2/use_cases/public_space/get_public_space.dart';
import 'package:mobile_sev2/use_cases/topic/get_subscribe_list.dart';
import 'package:mobile_sev2/use_cases/topic/unsubscribe_topic.dart';

class WorkspaceListPresenter extends Presenter {
  GetWorkspaceUseCase _getWorkspaceUseCase;
  DeleteWorkspaceUseCase _deleteWorkspaceUseCase;
  GetTokenUseCase _getTokenUseCase;
  GetPublicSpaceUseCase _getPublicSpaceUseCase;

  GetSubscribeListUseCase _subscribeListUseCase;
  UnsubscribeTopicUseCase _unsubscribeUseCase;
  UnsubscribeTopicUseCase _unsubscribeDBUseCase;

  late Function getWorkspaceOnNext;
  late Function getWorkspaceOnComplete;
  late Function getWorkspaceOnError;

  late Function deleteWorkspaceOnNext;
  late Function deleteWorkspaceOnComplete;
  late Function deleteWorkspaceOnError;

  late Function getTokenOnNext;
  late Function getTokenOnComplete;
  late Function getTokenOnError;

  late Function getPublicSpaceOnNext;
  late Function getPublicSpaceOnComplete;
  late Function getPublicSpaceOnError;

  // unsubscribe
  late Function unsubscribeOnNext;
  late Function unsubscribeOnComplete;
  late Function unsubscribeOnError;

  // get subscribe list
  late Function getSubscribeListOnNext;
  late Function getSubscribeListOnComplete;
  late Function getSubscribeListOnError;

  // void onGetWorkspace(GetWorkspaceRequestInterface req) {
  //   if (req is GetWorkspaceDBRequest) {
  //     _getWorkspaceUseCase.execute(_GetWorkspaceObserver(this), req);
  //   }
  // }

  void onGetWorkspace(GetWorkspaceRequestInterface req) {
    _getWorkspaceUseCase.execute(_GetWorkspaceObserver(this), req);
  }

  void onDeleteWorkspace(DeleteWorkspaceRequestInterface req) {
    if (req is DeleteWorkspaceDBRequest) {
      _deleteWorkspaceUseCase.execute(_DeleteWorkspaceObserver(this), req);
    }
  }

  void onGetToken(GetTokenRequestInterface req) {
    if (req is GetTokenApiRequest) {
      _getTokenUseCase.execute(_GetTokenObserver(this, req.workspace), req);
    }
  }

  void onGetPublicSpace(GetPublicSpaceRequestInterface req) {
    if (req is GetPublicSpaceApiRequest)
      _getPublicSpaceUseCase.execute(
        _GetPublicSpaceObserver(this, req.workspaceId),
        req,
      );
  }

  void onGetSubscribeList(SubscribeListRequestInterface req) {
    if (req is SubscribeListDBRequest) {
      _subscribeListUseCase.execute(_SubscribeListObserver(this, PersistenceType.db), req);
    }
  }

  void onUnsubscribe(SubscribeTopicRequestInterface req) {
    if (req is SubscribeTopicApiRequest) {
      _unsubscribeUseCase.execute(_UnsubscribeTopicObserver(this, PersistenceType.api, req), req);
    } else {
      _unsubscribeDBUseCase.execute(_UnsubscribeTopicObserver(this, PersistenceType.db, req), req);
    }
  }

  WorkspaceListPresenter(
    this._getWorkspaceUseCase,
    this._deleteWorkspaceUseCase,
    this._getTokenUseCase,
    this._getPublicSpaceUseCase,
    this._subscribeListUseCase,
    this._unsubscribeUseCase,
    this._unsubscribeDBUseCase,
  );

  @override
  void dispose() {
    _getWorkspaceUseCase.dispose();
    _deleteWorkspaceUseCase.dispose();
    _getTokenUseCase.dispose();
    _getPublicSpaceUseCase.dispose();
    _subscribeListUseCase.dispose();
    _unsubscribeUseCase.dispose();
    _unsubscribeDBUseCase.dispose();
  }
}

class _GetWorkspaceObserver implements Observer<List<Workspace>> {
  WorkspaceListPresenter _presenter;

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

class _DeleteWorkspaceObserver implements Observer<bool> {
  WorkspaceListPresenter _presenter;

  _DeleteWorkspaceObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.deleteWorkspaceOnComplete();
  }

  @override
  void onError(e) {
    _presenter.deleteWorkspaceOnError(e);
  }

  @override
  void onNext(bool? response) {
    _presenter.deleteWorkspaceOnNext(response);
  }
}

class _GetTokenObserver implements Observer<BaseApiResponse> {
  WorkspaceListPresenter _presenter;
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
    _presenter.getTokenOnError(e);
  }
}

class _GetPublicSpaceObserver implements Observer<Room> {
  WorkspaceListPresenter _presenter;
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

class _SubscribeListObserver implements Observer<List<Topic>> {
  WorkspaceListPresenter _presenter;
  PersistenceType _type;

  _SubscribeListObserver(this._presenter, this._type);

  void onNext(List<Topic>? result) {
    _presenter.getSubscribeListOnNext(result, _type);
  }

  void onComplete() {
    _presenter.getSubscribeListOnComplete(_type);
  }

  void onError(e) {
    _presenter.getSubscribeListOnError(e, _type);
  }
}

class _UnsubscribeTopicObserver implements Observer<void> {
  WorkspaceListPresenter _presenter;
  PersistenceType _type;
  SubscribeTopicRequestInterface _request;

  _UnsubscribeTopicObserver(this._presenter, this._type, this._request);

  void onNext(void result) {
    _presenter.unsubscribeOnNext(result, _type, _request);
  }

  void onComplete() {
    _presenter.unsubscribeOnComplete(_type);
  }

  void onError(e) {
    _presenter.unsubscribeOnError(e, _type);
  }
}