import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/topic/subscribe_topic_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_suite_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/setting_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/delete_push_notifications_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/get_push_notifications_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/store_push_notification_db_request.dart';
import 'package:mobile_sev2/data/payload/db/setting/get_setting_db_request.dart';
import 'package:mobile_sev2/data/payload/db/setting/update_setting_db_request.dart';
import 'package:mobile_sev2/data/payload/db/topic/SubscribeListDBRequest.dart';
import 'package:mobile_sev2/data/payload/db/topic/subscribe_topic_db_request.dart';
import 'package:mobile_sev2/domain/meta/push_notification.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:mobile_sev2/use_cases/auth/get_token.dart';
import 'package:mobile_sev2/use_cases/auth/get_workspace.dart';
import 'package:mobile_sev2/use_cases/lobby/store_list_reactions_to_db.dart';
import 'package:mobile_sev2/use_cases/push_notification/delete_push_notifications.dart';
import 'package:mobile_sev2/use_cases/push_notification/get_push_notifications.dart';
import 'package:mobile_sev2/use_cases/push_notification/store_push_notification.dart';
import 'package:mobile_sev2/use_cases/reaction/get_reactions.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_rooms.dart';
import 'package:mobile_sev2/use_cases/setting/get_setting.dart';
import 'package:mobile_sev2/use_cases/setting/update_setting.dart';
import 'package:mobile_sev2/use_cases/topic/get_subscribe_list.dart';
import 'package:mobile_sev2/use_cases/topic/subscribe_topic.dart';
import 'package:mobile_sev2/use_cases/topic/unsubscribe_topic.dart';
import 'package:mobile_sev2/use_cases/user/get_profile_info.dart';
import 'package:mobile_sev2/use_cases/user/get_suite_profile.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';
import 'package:mobile_sev2/use_cases/user/user_checkin.dart';

class MainPresenter extends Presenter {
  // get profile
  GetProfileUseCase _profileUsecase;
  GetProfileUseCase _profileDbUsecase;

  // get user detail
  GetUsersUseCase _userCase;
  GetUsersUseCase _userDbCase;

  // for RSP
  GetSuiteProfileUseCase _suiteProfileUseCase;
  GetSuiteProfileUseCase _suiteProfileDbUseCase;

  // get all rooms user joined
  GetRoomsUseCase _getRoomsUseCase;
  GetRoomsUseCase _getRoomsDbUseCase;
  GetRoomParticipantsUseCase _participantsUseCase;

  // setting
  GetSettingUseCase _settingUseCase;
  UpdateSettingUseCase _updateSettingUseCase;

  // topic
  SubscribeTopicUseCase _subscribeUseCase;
  SubscribeTopicUseCase _subscribeDBUseCase;

  UnsubscribeTopicUseCase _unsubscribeUseCase;
  UnsubscribeTopicUseCase _unsubscribeDBUseCase;

  GetSubscribeListUseCase _subscribeListUseCase;

  // get reaction list
  GetReactionsUseCase _reactionsUseCase;

  //store list reactions to DB
  StoreListReactionToDbUseCase _storeListReactionToDbUseCase;

  GetWorkspaceUseCase _getWorkspaceUseCase;

  GetTokenUseCase _getTokenUseCase;

  // push notification
  GetPushNotificationUseCase _getPushNotificationUseCase;
  StorePushNotificationUseCase _storePushNotificationUseCase;
  DeletePushNotificationUseCase _deletePushNotificationUseCase;

  // user checkin
  UserCheckinUseCase _userCheckinUseCase;

  // for get profile
  late Function getProfileOnNext;
  late Function getProfileOnComplete;
  late Function getProfileOnError;

  // suite profile
  late Function getSuiteProfileOnNext;
  late Function getSuiteProfileOnComplete;
  late Function getSuiteProfileOnError;

  // get user data
  late Function getUserOnNext;
  late Function getUserOnComplete;
  late Function getUserOnError;

  // get rooms
  late Function getRoomsOnNext;
  late Function getRoomsOnComplete;
  late Function getRoomsOnError;

  // get room participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  // setting
  late Function getSettingOnNext;
  late Function getSettingOnComplete;
  late Function getSettingOnError;

  // update setting
  late Function updateSettingOnNext;
  late Function updateSettingOnComplete;
  late Function updateSettingOnError;

  // subscribe
  late Function subscribeOnNext;
  late Function subscribeOnComplete;
  late Function subscribeOnError;

  // unsubscribe
  late Function unsubscribeOnNext;
  late Function unsubscribeOnComplete;
  late Function unsubscribeOnError;

  // get subscribe list
  late Function getSubscribeListOnNext;
  late Function getSubscribeListOnComplete;
  late Function getSubscribeListOnError;

  // get reactions list
  late Function getReactionListOnNext;
  late Function getReactionListOnComplete;
  late Function getReactionListOnError;

  // store list reaction to DB
  late Function storeListReactionToDbOnNext;
  late Function storeListReactionToDbOnComplete;
  late Function storeListReactionToDbOnError;

  late Function getWorkspaceOnNext;
  late Function getWorkspaceOnComplete;
  late Function getWorkspaceOnError;

  late Function getTokenOnNext;
  late Function getTokenOnComplete;
  late Function getTokenOnError;

  // push notification
  late Function getPushNotificationOnNext;
  late Function getPushNotificationOnComplete;
  late Function getPushNotificationOnError;

  late Function storePushNotificationOnNext;
  late Function storePushNotificationOnComplete;
  late Function storePushNotificationOnError;

  late Function deletePushNotificationOnNext;
  late Function deletePushNotificationOnComplete;
  late Function deletePushNotificationOnError;

  // for user checkin
  late Function userCheckinOnNext;
  late Function userCheckinOnComplete;
  late Function userCheckinOnError;

  MainPresenter(
    this._profileUsecase,
    this._profileDbUsecase,
    this._userCase,
    this._userDbCase,
    this._suiteProfileUseCase,
    this._suiteProfileDbUseCase,
    this._getRoomsUseCase,
    this._getRoomsDbUseCase,
    this._participantsUseCase,
    this._settingUseCase,
    this._updateSettingUseCase,
    this._subscribeUseCase,
    this._subscribeDBUseCase,
    this._unsubscribeUseCase,
    this._unsubscribeDBUseCase,
    this._subscribeListUseCase,
    this._reactionsUseCase,
    this._storeListReactionToDbUseCase,
    this._getWorkspaceUseCase,
    this._getTokenUseCase,
    this._getPushNotificationUseCase,
    this._storePushNotificationUseCase,
    this._deletePushNotificationUseCase,
    this._userCheckinUseCase,
  );

  void onGetProfile(GetProfileRequestInterface req) {
    if (req is GetProfileApiRequest) {
      _profileUsecase.execute(
          _GetProfileObserver(this, PersistenceType.api), req);
    } else {
      _profileDbUsecase.execute(
          _GetProfileObserver(this, PersistenceType.db), req);
    }
  }

  void onGetUserDetail(GetUsersRequestInterface req) {
    if (req is GetUsersApiRequest) {
      _userCase.execute(_GetUsersObserver(this, PersistenceType.api), req);
    } else {
      _userDbCase.execute(_GetUsersObserver(this, PersistenceType.db), req);
    }
  }

  void onGetSuiteProfile(GetSuiteProfileRequestInterface req) {
    if (req is GetSuiteProfileApiRequest) {
      _suiteProfileUseCase.execute(
          _GetSuiteProfileObserver(this, PersistenceType.api), req);
    }
  }

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

  void onGetSetting(GetSettingRequestInterface req) {
    if (req is GetSettingDBRequest) {
      _settingUseCase.execute(
          _GetSettingObserver(this, PersistenceType.db), req);
    }
  }

  void onUpdateSetting(UpdateSettingRequestInterface req) {
    if (req is UpdateSettingDBRequest) {
      _updateSettingUseCase.execute(
          _UpdateSettingObserver(this, PersistenceType.db), req);
    }
  }

  void onSubscribe(SubscribeTopicRequestInterface req) {
    if (req is SubscribeTopicApiRequest) {
      _subscribeUseCase.execute(
          _SubscribeTopicObserver(this, PersistenceType.api, req.topic), req);
    } else {
      _subscribeDBUseCase.execute(
        _SubscribeTopicObserver(
          this,
          PersistenceType.db,
          (req as SubscribeTopicDBRequest).topic,
        ),
        req,
      );
    }
  }

  void onUnsubscribe(SubscribeTopicRequestInterface req) {
    if (req is SubscribeTopicApiRequest) {
      _unsubscribeUseCase.execute(
          _UnsubscribeTopicObserver(this, PersistenceType.api), req);
    } else {
      _unsubscribeDBUseCase.execute(
          _UnsubscribeTopicObserver(this, PersistenceType.db), req);
    }
  }

  void onGetSubscribeList(SubscribeListRequestInterface req) {
    if (req is SubscribeListDBRequest) {
      _subscribeListUseCase.execute(
          _SubscribeListObserver(this, PersistenceType.db), req);
    }
  }

  void onGetReactionsList(GetReactionsRequestInterface req) {
    _reactionsUseCase.execute(_GetReactionsObserver(this), req);
  }

  void onStoreListReactionToDb(StoreListReactionToDbRequestInterface req) {
    _storeListReactionToDbUseCase.execute(_StoreListReactionsToDb(this), req);
  }

  void onGetWorkspace(GetWorkspaceRequestInterface req) {
    _getWorkspaceUseCase.execute(_GetWorkspaceObserver(this), req);
  }

  void onGetToken(GetTokenRequestInterface req) {
    if (req is GetTokenApiRequest) {
      _getTokenUseCase.execute(_GetTokenObserver(this, req.workspace), req);
    }
  }

  void onGetPushNotification(
      GetPushNotificationsRequestInterface req, RemoteMessage message) {
    if (req is GetPushNotificationsDBRequest) {
      _getPushNotificationUseCase.execute(
          _GetPushNotificationObserver(this, message), req);
    }
  }

  void onStorePushNotification(StorePushNotificationRequestInterface req) {
    if (req is StorePushNotificationsDBRequest) {
      _storePushNotificationUseCase.execute(
          _StorePushNotificationObserver(this), req);
    }
  }

  void onDeletePushNotification(DeletePushNotificationsRequestInterface req) {
    if (req is DeletePushNotificationsDBRequest) {
      _deletePushNotificationUseCase.execute(
          _DeletePushNotificationObserver(this), req);
    }
  }

  void onUserCheckin(UserCheckinRequestInterface req) {
    _userCheckinUseCase.execute(_UserCheckinObserver(this), req);
  }

  void dispose() {
    _profileUsecase.dispose();
    _profileDbUsecase.dispose();
    _userCase.dispose();
    _userDbCase.dispose();
    _suiteProfileUseCase.dispose();
    _suiteProfileDbUseCase.dispose();
    _getRoomsUseCase.dispose();
    _getRoomsDbUseCase.dispose();
    _settingUseCase.dispose();
    _reactionsUseCase.dispose();
    _participantsUseCase.dispose();
    _subscribeListUseCase.dispose();
    _subscribeUseCase.dispose();
    _subscribeDBUseCase.dispose();
    _unsubscribeUseCase.dispose();
    _unsubscribeDBUseCase.dispose();
    _getWorkspaceUseCase.dispose();
    _getPushNotificationUseCase.dispose();
    _storePushNotificationUseCase.dispose();
    _deletePushNotificationUseCase.dispose();
    _userCheckinUseCase.dispose();
  }
}

class _GetProfileObserver implements Observer<User> {
  MainPresenter _presenter;
  PersistenceType _type;

  _GetProfileObserver(this._presenter, this._type);

  void onNext(User? user) {
    _presenter.getProfileOnNext(user, _type);
  }

  void onComplete() {
    _presenter.getProfileOnComplete(_type);
  }

  void onError(e) {
    _presenter.getProfileOnError(e, _type);
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  MainPresenter _presenter;
  PersistenceType _type;

  _GetUsersObserver(this._presenter, this._type);

  void onNext(List<User>? users) {
    _presenter.getUserOnNext(users?[0], _type);
  }

  void onComplete() {
    _presenter.getUserOnComplete(_type);
  }

  void onError(e) {
    _presenter.getUserOnError(e, _type);
  }
}

class _GetSuiteProfileObserver implements Observer<User> {
  MainPresenter _presenter;
  PersistenceType _type;

  _GetSuiteProfileObserver(this._presenter, this._type);

  void onNext(User? user) {
    _presenter.getSuiteProfileOnNext(user, _type);
  }

  void onComplete() {
    _presenter.getSuiteProfileOnComplete(_type);
  }

  void onError(e) {
    _presenter.getSuiteProfileOnError(e, _type);
  }
}

class _GetRoomsObserver implements Observer<List<Room>> {
  MainPresenter _presenter;
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
  MainPresenter _presenter;
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

class _GetSettingObserver implements Observer<Setting> {
  MainPresenter _presenter;
  PersistenceType _type;

  _GetSettingObserver(this._presenter, this._type);

  void onNext(Setting? setting) {
    _presenter.getSettingOnNext(setting, _type);
  }

  void onComplete() {
    _presenter.getSettingOnComplete(_type);
  }

  void onError(e) {
    _presenter.getSettingOnError(e, _type);
  }
}

class _UpdateSettingObserver implements Observer<bool> {
  MainPresenter _presenter;
  PersistenceType _type;

  _UpdateSettingObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.updateSettingOnNext(result, _type);
  }

  void onComplete() {
    _presenter.updateSettingOnComplete(_type);
  }

  void onError(e) {
    _presenter.updateSettingOnError(e, _type);
  }
}

class _SubscribeTopicObserver implements Observer<Topic> {
  MainPresenter _presenter;
  PersistenceType _type;
  Topic _topic;

  _SubscribeTopicObserver(this._presenter, this._type, this._topic);

  void onNext(Topic? result) {
    _presenter.subscribeOnNext(_topic, _type);
  }

  void onComplete() {
    _presenter.subscribeOnComplete(_type);
  }

  void onError(e) {
    _presenter.subscribeOnError(e, _type);
  }
}

class _UnsubscribeTopicObserver implements Observer<void> {
  MainPresenter _presenter;
  PersistenceType _type;

  _UnsubscribeTopicObserver(this._presenter, this._type);

  void onNext(void result) {
    _presenter.unsubscribeOnNext(result, _type);
  }

  void onComplete() {
    _presenter.unsubscribeOnComplete(_type);
  }

  void onError(e) {
    _presenter.unsubscribeOnError(e, _type);
  }
}

class _SubscribeListObserver implements Observer<List<Topic>> {
  MainPresenter _presenter;
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

class _GetReactionsObserver implements Observer<List<Reaction>> {
  MainPresenter _presenter;

  _GetReactionsObserver(this._presenter);

  void onNext(List<Reaction>? result) {
    _presenter.getReactionListOnNext(result);
  }

  void onComplete() {
    _presenter.getReactionListOnComplete();
  }

  void onError(e) {
    _presenter.getReactionListOnError(e);
  }
}

class _StoreListReactionsToDb implements Observer<bool> {
  MainPresenter _presenter;

  _StoreListReactionsToDb(this._presenter);

  @override
  void onNext(bool? result) {
    _presenter.storeListReactionToDbOnNext(result);
  }

  @override
  void onComplete() {
    _presenter.storeListReactionToDbOnComplete();
  }

  @override
  void onError(e) {
    _presenter.storeListReactionToDbOnError(e);
  }
}

class _GetWorkspaceObserver implements Observer<List<Workspace>> {
  MainPresenter _presenter;

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

class _GetTokenObserver implements Observer<BaseApiResponse> {
  MainPresenter _presenter;
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

class _GetPushNotificationObserver implements Observer<List<PushNotification>> {
  MainPresenter _presenter;
  RemoteMessage _message;

  _GetPushNotificationObserver(
    this._presenter,
    this._message,
  );

  void onNext(List<PushNotification>? resp) {
    _presenter.getPushNotificationOnNext(resp, _message);
  }

  void onComplete() {
    _presenter.getPushNotificationOnComplete();
  }

  void onError(e) {
    _presenter.getPushNotificationOnError(e);
  }
}

class _StorePushNotificationObserver implements Observer<bool> {
  MainPresenter _presenter;

  _StorePushNotificationObserver(
    this._presenter,
  );

  void onNext(bool? resp) {
    _presenter.storePushNotificationOnNext(resp);
  }

  void onComplete() {
    _presenter.storePushNotificationOnComplete();
  }

  void onError(e) {
    _presenter.storePushNotificationOnError(e);
  }
}

class _DeletePushNotificationObserver implements Observer<bool> {
  MainPresenter _presenter;

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

class _UserCheckinObserver implements Observer<User> {
  MainPresenter _presenter;

  _UserCheckinObserver(this._presenter);

  void onNext(User? user) {
    _presenter.userCheckinOnNext(user);
  }

  void onComplete() {
    _presenter.userCheckinOnComplete();
  }

  void onError(e) {
    _presenter.userCheckinOnError(e);
  }
}
