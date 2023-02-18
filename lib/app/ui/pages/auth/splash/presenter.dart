import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/auth/update_workspace_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/delete_push_notifications_db_request.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:mobile_sev2/use_cases/auth/get_token.dart';
import 'package:mobile_sev2/use_cases/auth/get_workspace.dart';
import 'package:mobile_sev2/use_cases/auth/update_workspace.dart';
import 'package:mobile_sev2/use_cases/push_notification/delete_push_notifications.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_rooms.dart';

class SplashPresenter extends Presenter {
  // get all rooms user joined
  GetRoomsUseCase _getRoomsUseCase;
  GetRoomsUseCase _getRoomsDbUseCase;
  GetRoomParticipantsUseCase _participantsUseCase;
  GetWorkspaceUseCase _getWorkspaceUseCase;
  UpdateWorkspaceUseCase _updateWorkspaceUseCase;
  GetTokenUseCase _getTokenUseCase;
  DeletePushNotificationUseCase _deletePushNotificationUseCase;

  // get rooms
  late Function getRoomsOnNext;
  late Function getRoomsOnComplete;
  late Function getRoomsOnError;

  // get room participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  late Function getWorkspaceOnNext;
  late Function getWorkspaceOnComplete;
  late Function getWorkspaceOnError;

  late Function loginOnNext;
  late Function loginOnComplete;
  late Function loginOnError;

  late Function updateWorkspaceOnNext;
  late Function updateWorkspaceOnComplete;
  late Function updateWorkspaceOnError;

  late Function getTokenOnNext;
  late Function getTokenOnComplete;
  late Function getTokenOnError;

  late Function deletePushNotificationOnNext;
  late Function deletePushNotificationOnComplete;
  late Function deletePushNotificationOnError;

  SplashPresenter(
    this._getRoomsUseCase,
    this._getRoomsDbUseCase,
    this._participantsUseCase,
    this._getWorkspaceUseCase,
    this._updateWorkspaceUseCase,
    this._getTokenUseCase,
    this._deletePushNotificationUseCase,
  );

  void onGetRooms(GetRoomsRequestInterface req, {isRedirect = false}) {
    if (req is GetRoomsApiRequest) {
      _getRoomsUseCase.execute(
          _GetRoomsObserver(this, PersistenceType.api, isRedirect), req);
    } else {
      _getRoomsDbUseCase.execute(
          _GetRoomsObserver(this, PersistenceType.db, isRedirect), req);
    }
  }

  void onGetRoomParticipants(GetParticipantsRequestInterface req, Room room) {
    if (req is GetParticipantsApiRequest) {
      _participantsUseCase.execute(_GetParticipantsObserver(this, room), req);
    }
  }

  void onGetWorkspace(GetWorkspaceRequestInterface req) {
    _getWorkspaceUseCase.execute(_GetWorkspaceObserver(this), req);
  }

  void updateWorkspace(UpdateWorkspaceRequestInterface req) {
    if (req is UpdateWorkspaceDBRequest) {
      _updateWorkspaceUseCase.execute(_UpdateWorkspaceObserver(this), req);
    }
  }

  void onGetToken(GetTokenRequestInterface req) {
    if (req is GetTokenApiRequest) {
      _getTokenUseCase.execute(_GetTokenObserver(this, req.workspace), req);
    }
  }

  void onDeletePushNotification(DeletePushNotificationsRequestInterface req) {
    if (req is DeletePushNotificationsDBRequest) {
      _deletePushNotificationUseCase.execute(
          _DeletePushNotificationObserver(this), req);
    }
  }

  @override
  void dispose() {
    _getRoomsUseCase.dispose();
    _getRoomsDbUseCase.dispose();
    _participantsUseCase.dispose();
    _getWorkspaceUseCase.dispose();
    _updateWorkspaceUseCase.dispose();
    _getTokenUseCase.dispose();
    _deletePushNotificationUseCase.dispose();
  }
}

class _GetRoomsObserver implements Observer<List<Room>> {
  SplashPresenter _presenter;
  PersistenceType _type;
  bool _isRedirect;

  _GetRoomsObserver(this._presenter, this._type, this._isRedirect);

  void onNext(List<Room>? rooms) {
    _presenter.getRoomsOnNext(rooms, _type, _isRedirect);
  }

  void onComplete() {
    _presenter.getRoomsOnComplete(_type, _isRedirect);
  }

  void onError(e) {
    _presenter.getRoomsOnError(e, _type, _isRedirect);
  }
}

class _GetParticipantsObserver implements Observer<List<User>> {
  SplashPresenter _presenter;
  Room _room;

  _GetParticipantsObserver(this._presenter, this._room);

  void onNext(List<User>? users) {
    _presenter.getParticipantsOnNext(users, _room);
  }

  void onComplete() {
    _presenter.getParticipantsOnComplete();
  }

  void onError(e) {
    _presenter.getParticipantsOnError(e);
  }
}

class _GetWorkspaceObserver implements Observer<List<Workspace>> {
  SplashPresenter _presenter;

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

class _UpdateWorkspaceObserver implements Observer<bool> {
  SplashPresenter _presenter;

  _UpdateWorkspaceObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.updateWorkspaceOnComplete();
  }

  @override
  void onError(e) {
    _presenter.updateWorkspaceOnError(e);
  }

  @override
  void onNext(bool? response) {
    _presenter.updateWorkspaceOnNext(response);
  }
}

class _GetTokenObserver implements Observer<BaseApiResponse> {
  SplashPresenter _presenter;
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

class _DeletePushNotificationObserver implements Observer<bool> {
  SplashPresenter _presenter;

  _DeletePushNotificationObserver(
      this._presenter,
      );

  void onNext(bool? resp) {
    _presenter.deletePushNotificationOnNext(resp);
  }

  void onComplete() {
    _presenter.deletePushNotificationOnComplete();
  }

  void onError(e) {
    _presenter.deletePushNotificationOnError(e);
  }
}
