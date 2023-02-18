import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/app/infrastructures/events/after_login.dart';
import 'package:mobile_sev2/app/infrastructures/events/logout.dart';
import 'package:mobile_sev2/app/infrastructures/events/notification.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/events/setting.dart';
import 'package:mobile_sev2/app/infrastructures/events/subscribe.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/encrypter.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/persistences/api_service.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/app/repositories/api/calendar_api_repository.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/calendar/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/view.dart';
import 'package:mobile_sev2/app/ui/pages/project/list/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/list/view.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_workspace_api_request.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/topic/subscribe_topic_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_suite_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/user_checkin_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/lobby/store_list_reaction_to_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/delete_push_notifications_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/get_push_notifications_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/store_push_notification_db_request.dart';
import 'package:mobile_sev2/data/payload/db/setting/get_setting_db_request.dart';
import 'package:mobile_sev2/data/payload/db/setting/update_setting_db_request.dart';
import 'package:mobile_sev2/data/payload/db/topic/SubscribeListDBRequest.dart';
import 'package:mobile_sev2/data/payload/db/topic/subscribe_topic_db_request.dart';
import 'package:mobile_sev2/data/persistences/mappers/calendar_mapper.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/meta/push_notification.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MainController extends BaseController {
  MainArgs? _data;

  MainPresenter _presenter;
  UserData _userData;
  EventBus _eventBus;
  StreamSubscription? _logoutListener;
  DateUtilInterface _dateUtil;
  WebSocketDashboardClient _socket;
  FlutterLocalNotificationsPlugin _notification;
  Workmanager _workManager;

  int _currentTab = 0;
  late User _user;

  // available pages
  late LobbyPage _lobbyPage;
  late MainCalendarPage _calendarPage;
  late RoomsPage _roomsPage;
  late ProjectPage _projectPage;
  late ProfilePage _profilePage;

  // late BasicSearchPage _basicSearchPage;

  List<Widget> pages = [];
  List<Room> _rooms = [];
  Setting? _setting;
  String _workspaceId = "";
  String _conpherencePHID = "";
  List<Topic> _subscribedTopics = [];
  List<Workspace> _workspaces = [];

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  String formattedDate = DateFormat('EEE d MMM').format(DateTime.now());

  bool positionStreamStarted = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  int get currentTab => _currentTab;

  UserData get userData => _userData;

  Setting? get setting => _setting;

  MainArgs? get data => data;

  MainController(
    this._presenter,
    this._userData,
    this._eventBus,
    this._dateUtil,
    this._socket,
    this._notification,
    this._workManager,
  ) {
    tz.initializeTimeZones();
    _userData.loadData();
  }

  @override
  void load() {
    _getCurrentPosition();
    _socket.connect();
    // get updated user profile
    _presenter.onGetSubscribeList(SubscribeListDBRequest());
    _presenter.onGetReactionsList(GetReactionsApiRequest());
    if (_data?.from == Pages.login || _data?.from == Pages.splash) {
      checkConnection().then((value) {
        if (value) {
          _getUserProfile();
        } else {
          isConnected = value;
          refreshUI();
        }
      });
    }
    tz.setLocalLocation(tz.getLocation(_userData.timezone));
    _workManager.initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
    _workManager.registerPeriodicTask(
      "1",
      "getEvents",
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );
    // prepare the pages showed in main page
    _lobbyPage = LobbyPage();
    _calendarPage = MainCalendarPage();
    _roomsPage = RoomsPage();
    _projectPage = ProjectPage();
    _profilePage = ProfilePage();

    // _basicSearchPage = BasicSearchPage();

    pages = [
      _lobbyPage,
      _calendarPage,
      _projectPage,
      _roomsPage,
      _profilePage,
    ]; //_basicSearchPage,

    // set current screen
    if (_data != null && _data!.to != null) {
      this.updateCurrentScreen(_data!.to!);
    } else {
      this.updateCurrentScreen(Pages.lobby);
    }
    _presenter.onGetSetting(GetSettingDBRequest());
  }

  @override
  void getArgs() {
    if (args != null) _data = args as MainArgs;
    print(_data?.toPrint());
  }

  void updateCurrentScreen(String page) {
    if (_currentTab != 0 &&
        ModalRoute.of(context) != null &&
        !ModalRoute.of(context)!.isFirst) {
      Navigator.pushNamedAndRemoveUntil(context, Pages.main, (r) => false,
          arguments: MainArgs(_getPageFromTab(_currentTab), to: page));
    } else {
      _switchPage(page);
    }
  }

  void _switchPage(String page) {
    switch (page) {
      case Pages.lobby:
        _currentTab = 0;
        break;
      case Pages.mainCalendar:
        _currentTab = 1;
        break;
      case Pages.project:
        _currentTab = 2;
        break;
      case Pages.rooms:
        _currentTab = 3;
        break;
      case Pages.profile:
        _currentTab = 4;
        break;
      default:
        break;
    }
    refreshUI();
  }

  String _getPageFromTab(int tab) {
    var page = Pages.lobby;
    switch (tab) {
      case 0:
        page = Pages.lobby;
        break;
      case 1:
        page = Pages.mainCalendar;
        break;
      case 2:
        page = Pages.project;
        break;
      case 3:
        page = Pages.rooms;
        break;
      case 4:
        page = Pages.profile;
        break;
      default:
        break;
    }
    return page;
  }

  void _getUserProfile() {
    _presenter.onGetProfile(GetProfileApiRequest());
  }

  void _getSuiteProfile() {
    _presenter.onGetSuiteProfile(GetSuiteProfileApiRequest(_userData.id));
  }

  void _getUserDetail() {
    _presenter.onGetUserDetail(GetUsersApiRequest(ids: [_user.id]));
  }

  bool _hasAlreadySubscribed(String topicId) {
    int idx =
        _subscribedTopics.indexWhere((element) => element.topicId == topicId);
    return idx > -1;
  }

  @override
  void initListeners() {
    initDynamicLinks();
    _notification.initialize(
        AppComponent.getInjector().get<InitializationSettings>(),
        onSelectNotification: selectNotification);

    // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //   if (message != null) {
    //     _presenter.onGetRooms(GetRoomsApiRequest(ids: [message.data['conpherencePHID']]), isRedirect: true);
    //   }
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print(
      //     "notificationMessage: ${message.data}, ${message.notification?.title}");
      _workspaceId = message.data['workspaceID'];
      _conpherencePHID = message.data['conpherencePHID'];
      _presenter.onGetPushNotification(
        GetPushNotificationsDBRequest(_conpherencePHID),
        message,
      );
    });

    // // handle when notification is clicked

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _workspaceId = message.data['workspaceID'];
      _conpherencePHID = message.data['conpherencePHID'];
      showOnLoading(context, S.of(context).label_connect_room_chat);
      _presenter.onDeletePushNotification(
        DeletePushNotificationsDBRequest(
          message.data['conpherencePHID'],
        ),
      );
      if (message.data['workspaceID'] == _userData.workspace) {
        _presenter.onGetRooms(
            GetRoomsApiRequest(ids: [message.data['conpherencePHID']]),
            isRedirect: true);
      } else {
        _presenter.onGetWorkspace(
          GetWorkspaceApiRequest(
            requestType: RequestType.belonged,
            userId: _userData.intId,
            accessToken: _userData.accessToken,
          ),
        );
      }
      // _presenter.onGetRooms(GetRoomsApiRequest(ids: [message.data['conpherencePHID']]), isRedirect: true);
    });
    _presenter.getSubscribeListOnNext =
        (List<Topic> result, PersistenceType type) {
      print("main: success getSubscribeList $type length: ${result.length}");
      _subscribedTopics.clear();
      _subscribedTopics.addAll(result);
    };

    _presenter.getSubscribeListOnComplete = (PersistenceType type) {
      print("main: completed getSubscribeList $type");
    };

    _presenter.getSubscribeListOnError = (e, PersistenceType type) {
      loading(false);
      print("main: error getSubscribeList: $e $type");
    };

    _presenter.getReactionListOnNext = (List<Reaction> result) {
      AppComponent.getInjector()
          .get<List<Reaction>>(dependencyName: "reaction_list")
          .clear();
      AppComponent.getInjector()
          .get<List<Reaction>>(dependencyName: "reaction_list")
          .addAll(result);
      Map<String, Reaction> reactions = {};
      result.forEach((r) {
        reactions[r.name ?? ""] = r;
      });
      _presenter
          .onStoreListReactionToDb(StoreUserReactionToDbRequest(reactions));
    };

    _presenter.getReactionListOnComplete = () {
      print("main: completed getReactionList");
    };

    _presenter.getReactionListOnError = (e) {
      loading(false);
      print("main: error getReactionList: $e");
    };
    _presenter.storeListReactionToDbOnNext = (bool result) {
      print("lobby: success store list reactions $result");
    };

    _presenter.storeListReactionToDbOnComplete = () {
      print("lobby: completed store list reactions ");
    };

    _presenter.storeListReactionToDbOnError = (e) {
      loading(false);
      print("lobby: error store list reactions $e ");
    };

    _presenter.subscribeOnNext = (Topic? result, PersistenceType type) {
      print("main: success subscribe $type");
    };

    _presenter.subscribeOnComplete = (PersistenceType type) {
      print("main: completed subscribe $type");
    };

    _presenter.subscribeOnError = (e, PersistenceType type) {
      loading(false);
      print("main: error subscribe: $e $type");
    };

    _presenter.unsubscribeOnNext = (void result, PersistenceType type) {
      print("main: success unsubscribe $type");
    };

    _presenter.unsubscribeOnComplete = (PersistenceType type) {
      print("main: completed unsubscribe $type");
    };

    _presenter.unsubscribeOnError = (e, PersistenceType type) {
      loading(false);
      print("main: error unsubscribe: $e $type");
    };

    _eventBus.on<SubscribeEvent>().listen((event) {
      if (!_hasAlreadySubscribed(event.topicId)) {
        _presenter.onSubscribe(SubscribeTopicApiRequest(
            Topic(_userData.workspace, event.topicId)));
      }
    });

    _eventBus.on<UnsubscribeAllEvent>().listen((event) {
      _subscribedTopics.forEach((element) {
        _presenter.onUnsubscribe(SubscribeTopicApiRequest(element));
      });
    });

    _presenter.getProfileOnNext = (User user, PersistenceType type) {
      print("main: success getProfile $type");
      _user = user;
      if (!_hasAlreadySubscribed(_user.id)) {
        _presenter.onSubscribe(
          SubscribeTopicApiRequest(
            Topic(
              _userData.workspace,
              _user.id,
            ),
          ),
        );
        _presenter.onSubscribe(
          SubscribeTopicDBRequest(
            Topic(
              _userData.workspace,
              _user.id,
            ),
          ),
        );
      } else
        print("main: ${_user.id} is already subscribed");
      // _firebaseMessaging.subscribeToTopic(_user.id);

      // set user data
      _userData.id = user.id;
      _userData.username = user.name ?? "";
      _userData.name = user.fullName ?? "";
      // _userData.email = user.email;
      _userData.avatar = user.avatar ?? "";
      _userData.currentChannel = user.currentChannel ?? "";
      // _userData.type = user.userType.parseToString();
      _userData.lastCheckin =
          DateFormat('EEE d MMM').format(user.lastCheckin ?? DateTime.now());
      if (_userData.lastCheckin != formattedDate)
        _userData.isSendCheckin = true;
      _userData.save();

      //TODO: broadcast room data and listen from main, lobby, and rooms controller
      _presenter.onGetRooms(GetRoomsApiRequest());

      // get user detail
      delay(_getUserDetail);
    };

    _presenter.getProfileOnComplete = (PersistenceType type) {
      print("main: completed getProfile $type");
      refreshUI();
    };

    _presenter.getProfileOnError = (e, PersistenceType type) {
      loading(false);
      print("main: error getProfile: $e $type");
      // Navigator.pushReplacementNamed(context, Pages.errorPage);
    };

    _presenter.getUserOnNext = (User user, PersistenceType type) {
      print("main: success getUser $type");
      _user.registeredAt = user.registeredAt;
      _user.availability = user.availability;

      // save to user data
      _userData.phoneNumber = user.phoneNumber;
      _userData.secondPhoneNumber = user.secondPhoneNumber ?? "";
      _userData.registeredAt = user.registeredAt ?? _dateUtil.now();
      _userData.save();

      if (_userData.isSuiteUser()) {
        _getSuiteProfile();
      } else {
        //
      }
    };

    _presenter.getUserOnComplete = (PersistenceType type) {
      print("main: completed getUser $type");
    };

    _presenter.getUserOnError = (e, PersistenceType type) {
      loading(false);
      print("main: error getUser: $e $type");
    };

    _presenter.getSuiteProfileOnNext = (User user, PersistenceType type) {
      print("main: success getSuiteProfile $type");
      // stop here if user null
      if (user.id.isEmpty) return;

      _user = user;

      // set user data
      _userData.suiteId = user.suiteId!;
      _userData.isRSP = user.isRSP!;
      _userData.isOnboard = user.isOnboard!;

      if (_userData.isRSP) {
        // _userData.type = UserType.rsp.parseToString();
      }
      _userData.save();
    };

    _presenter.getSuiteProfileOnComplete = (PersistenceType type) {
      print("main: completed getSuiteProfile");
    };

    _presenter.getSuiteProfileOnError = (e, PersistenceType type) {
      loading(false);
      print("main: error getSuiteProfile: $e $type");
    };

    _presenter.getRoomsOnNext =
        (List<Room> rooms, PersistenceType type, bool isRedirect) {
      print("main: success getRooms $type $isRedirect");
      if (isRedirect) {
        if (rooms.isNotEmpty) {
          _getParticipants(rooms.first);
        }
      } else {
        _rooms.addAll(rooms);

        // subscribe to topic
        _rooms.map((e) => e.id).forEach((roomId) {
          _socket.subscribe(_userData.id, roomId);
          if (!_hasAlreadySubscribed(roomId)) {
            _presenter.onSubscribe(
              SubscribeTopicApiRequest(
                Topic(
                  _userData.workspace,
                  roomId,
                ),
              ),
            );
            _presenter.onSubscribe(
              SubscribeTopicDBRequest(
                Topic(
                  _userData.workspace,
                  roomId,
                ),
              ),
            );
          } else
            print("main: $roomId is already subscribed");
          // _firebaseMessaging.subscribeToTopic(roomId);
        });
      }
    };

    _presenter.getRoomsOnComplete = (PersistenceType type, bool isRedirect) {
      print("main: completed getRooms $type $isRedirect");
    };

    _presenter.getRoomsOnError = (e, PersistenceType type, bool isRedirect) {
      loading(false);
      print("main: error getRooms: $e $type $isRedirect");
      if (isRedirect) {
        Navigator.pop(context);
        showNotif(context, S.of(context).label_room_not_found);
      }
    };

    // get participants
    _presenter.getParticipantsOnNext = (List<User>? users, Room room) {
      print("room list: success getParticipants");
      if (users != null) {
        room.participants = users;
        Navigator.pop(context);
        _navigateToChat(room);
      }
    };

    _presenter.getParticipantsOnComplete = () {
      print("room list: completed getParticipants");
    };

    _presenter.getParticipantsOnError = (e) {
      loading(false);
      print("room list: error getParticipants $e");
      Navigator.pop(context);
      showNotif(context, S.of(context).label_room_not_found);
    };

    _logoutListener?.cancel();
    _logoutListener = _eventBus.on<LogoutEvent>().listen((_) {
      // unsubscribe to topic
      _subscribedTopics.forEach((element) {
        _presenter.onUnsubscribe(SubscribeTopicApiRequest(element));
      });
    });

    _eventBus.on<UpdateScreen>().listen((event) {
      updateCurrentScreen(event.pages);
    });

    _eventBus.on<HasUnreadChat>().listen((event) {
      if (_setting != null) {
        _setting?.hasUnreadChats = true;
        _presenter.onUpdateSetting(UpdateSettingDBRequest(_setting!));
      }
    });

    _eventBus.on<ChatRead>().listen((event) {
      if (_setting != null) {
        _setting?.hasUnreadChats = false;
        _presenter.onUpdateSetting(UpdateSettingDBRequest(_setting!));
      }
    });

    _presenter.getSettingOnNext = (Setting setting, PersistenceType type) {
      print("main: success getSetting $type");
      _setting = setting;
    };

    _presenter.getSettingOnComplete = (PersistenceType type) {
      print("main: completed getSetting $type");
      refreshUI();
    };

    _presenter.getSettingOnError = (e, PersistenceType type) {
      loading(false);
      print("main: error getSetting: $e $type");
    };

    _presenter.updateSettingOnNext = (bool result, PersistenceType type) {
      print("main: success updateSetting $type");
    };

    _presenter.updateSettingOnComplete = (PersistenceType type) {
      print("main: completed updateSetting $type");
      _presenter.onGetSetting(GetSettingDBRequest());
    };

    _presenter.updateSettingOnError = (e, PersistenceType type) {
      loading(false);
      print("main: error updateSetting $e $type");
    };

    _presenter.getWorkspaceOnNext = (List<Workspace> workspaces) {
      _workspaces.clear();
      _workspaces.addAll(workspaces);
      bool workspaceFound = false;
      // print("_workspaces ; ${_workspaces.map((e) => e.workspaceId)}");
      _workspaces.forEach((workspace) {
        if (workspace.workspaceId == _workspaceId) workspaceFound = true;
        return;
      });
      if (workspaceFound) {
        _presenter.onGetToken(
          GetTokenApiRequest(
            _userData.email,
            _userData.sub,
            _workspaceId,
            _userData.authProvider,
          ),
        );
      } else {
        Navigator.pushReplacementNamed(context, Pages.main,
            arguments: MainArgs(Pages.splash));
      }
      loading(false);
    };

    _presenter.getWorkspaceOnComplete = () {
      print("get workspace completed");
    };

    _presenter.getWorkspaceOnError = (e) {
      print("get workspace error: $e");
      Navigator.pushReplacementNamed(context, Pages.main,
          arguments: MainArgs(Pages.splash));
      loading(false);
    };
    _presenter.getTokenOnNext = (BaseApiResponse response, String workspace) {
      print("get token success");
      Workspace _workspace =
          _workspaces.firstWhere((space) => space.workspaceId == workspace);
      _workspace.token = response.result;
      selectWorkspace(_workspace);
    };

    _presenter.getTokenOnComplete = () {
      print("get token completed");
    };

    _presenter.getTokenOnError = (e) {
      print("get token error: $e");
      loading(false);
    };

    _presenter.getPushNotificationOnNext =
        (List<PushNotification> notifications, RemoteMessage message) {
      print("get push notification success ${notifications.length}");
      createNotification(message, notifications);
    };

    _presenter.getPushNotificationOnComplete = () {
      print("get push notification completed");
    };

    _presenter.getPushNotificationOnError = (e) {
      loading(false);
      print("get push notification error: $e");
    };

    _presenter.storePushNotificationOnNext = (bool result) {
      print("store push notification success");
    };

    _presenter.storePushNotificationOnComplete = () {
      print("store push notification completed");
    };

    _presenter.storePushNotificationOnError = (e) {
      loading(false);
      print("store push notification error: $e");
    };

    _presenter.deletePushNotificationOnNext = (bool result) {
      print("delete push notification success");
    };

    _presenter.deletePushNotificationOnComplete = () {
      print("delete push notification completed");
    };

    _presenter.deletePushNotificationOnError = (e) {
      loading(false);
      print("delete push notification error: $e");
    };
  }

  void createNotification(
      RemoteMessage message, List<PushNotification> notifications) {
    if (message.data['authorPHID'] != _userData.id) {
      List<String> data = notifications.map((e) => e.body).toList();
      data.add(message.data['body']);
      data = data.reversed.toList();
      var android = AndroidNotificationDetails(
        AppConstants.NOTIFICATION_CHANNEL_ID,
        AppConstants.NOTIFICATION_CHANNEL_NAME,
        channelDescription: AppConstants.NOTIFICATION_CHANNEL_DESCRIPTION,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        groupKey: message.data['conpherencePHID'],
        styleInformation: InboxStyleInformation(data),
      );
      var iOS = IOSNotificationDetails(
        threadIdentifier: message.data['conpherencePHID'],
      );
      var notificationDetail = NotificationDetails(
        android: android,
        iOS: iOS,
      );
      _notification.show(
        message.data['conpherencePHID'].hashCode,
        message.data['title'],
        message.data['body'],
        notificationDetail,
        payload: jsonEncode({
          "type": AppConstants.NOTIFICATION_TYPE_PUSH_NOTIFICATION,
          "data": jsonEncode(message.data),
        }),
      );
      _presenter.onStorePushNotification(
        StorePushNotificationsDBRequest(
          PushNotification(
            conpherencePHID: message.data['conpherencePHID'],
            body: message.data['body'],
            title: message.data['title'],
            authorPHID: message.data['authorPHID'],
            workspace: message.data['workspaceID'],
          ),
        ),
      );
    } else {
      _notification.cancel(message.data['conpherencePHID'].hashCode);
      _presenter.onDeletePushNotification(
        DeletePushNotificationsDBRequest(
          message.data['conpherencePHID'],
        ),
      );
    }
    _eventBus.fire(
      NotificationEvent(
        message.data['conpherencePHID'],
        message.data['authorPHID'],
        NotificationType.chat,
      ),
    );

    _presenter.userCheckinOnNext = (User user) {
      print("main: success userCheckin");
      _dismisNotificationLocation();
    };

    _presenter.userCheckinOnComplete = () {
      print("main: completed userCheckin");
      loading(false);
      refreshUI();
    };

    _presenter.userCheckinOnError = (
      e,
    ) {
      loading(false);
      print("main: error userCheckin: $e");
    };
  }

  void _getParticipants(Room room) {
    _presenter.onGetRoomParticipants(GetParticipantsApiRequest(room.id), room);
  }

  Future selectNotification(String? payload) async {
    // print("notificationMessage: $payload, $_workspaceId, $_conpherencePHID");
    if (payload != null) {
      Map<String, dynamic> _payload = jsonDecode(payload);
      if (_payload['type'] ==
          AppConstants.NOTIFICATION_TYPE_PUSH_NOTIFICATION) {
        showOnLoading(context, S.of(context).label_connect_room_chat);
        Map<String, dynamic> _data = jsonDecode(_payload['data']);
        final sendPort = IsolateNameServer.lookupPortByName("background_task");
        if (sendPort != null) {
          sendPort.send(_data['conpherencePHID']);
        }
        _presenter.onDeletePushNotification(
          DeletePushNotificationsDBRequest(
            _data['conpherencePHID'],
          ),
        );
        if (_data['workspaceID'] == _userData.workspace) {
          _presenter.onGetRooms(
            GetRoomsApiRequest(ids: [_data['conpherencePHID']]),
            isRedirect: true,
          );
        } else {
          _presenter.onGetWorkspace(
            GetWorkspaceApiRequest(
              requestType: RequestType.belonged,
              userId: _userData.intId,
              accessToken: _userData.accessToken,
            ),
          );
        }
      } else if (_payload['type'] ==
          AppConstants.NOTIFICATION_TYPE_EVENT_REMINDER) {
        Map<String, dynamic> _data = jsonDecode(_payload['data']);
        print("jsonData: $_data");
        Navigator.pushNamed(
          context,
          Pages.detail,
          arguments: DetailArgs(
            Calendar.fromJson(_data),
          ),
        );
      } else {}
    }
  }

  void _navigateToChat(Room room) {
    if (room.participants != null) {
      if (room.participants!.length > 2) {
        Navigator.pushNamed(
          context,
          Pages.roomChat,
          arguments: LobbyRoomArgs(
            room,
            type: RoomType.chat,
          ),
        );
      } else {
        Navigator.pushNamed(
          context,
          Pages.chat,
          arguments: ChatArgs(
            room,
          ),
        );
      }
    }
  }

  @override
  void disposing() async {
    _presenter.dispose();
    // await _socket.close();
  }

  void selectWorkspace(Workspace workspace) {
    _userData.token = workspace.token!;
    _userData.workspace = workspace.workspaceId;
    _userData.type = workspace.type!;
    _userData.save();
    String _baseUrl =
        "https://${workspace.workspaceId}${dotenv.env['SUITE_BASE_URL']}";
    AppComponent.getInjector()
        .get<Dio>(dependencyName: "dio_api_request")
        .options
        .baseUrl = _baseUrl;
    final uri = Uri.parse(_baseUrl);
    AppComponent.getInjector()
        .get<Dio>(dependencyName: "dio_api_request")
        .options
        .headers["host"] = uri.host;
    String _webRTCUrl =
        "wss://${workspace.workspaceId}${dotenv.env['SUITE_WEBRTC_BASE_URL']}";
    AppComponent.getInjector()
        .get<WebSocketDashboardClient>(dependencyName: "dashboard_websocket")
        .url = _webRTCUrl;
    _presenter.onGetRooms(GetRoomsApiRequest(ids: [_conpherencePHID]),
        isRedirect: true);

    _eventBus.fire(AfterLoginEvent());
    _eventBus.fire(Refresh());
    // if (workspace.type?.toLowerCase() == 'guest') {
    //   Navigator.pushNamed(
    //     context,
    //     Pages.publicSpaceRoom,
    //     arguments: PublicSpaceRoomArgs(workspace),
    //   );
    // } else {
    //
    // }
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    bool _isWeekend = _dateUtil.now().weekday == DateTime.saturday ||
        _dateUtil.now().weekday == DateTime.sunday;

    if (!hasPermission) {
      return;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    double distanceInMeters = Geolocator.distanceBetween(
        -7.7108, 110.3868, position.latitude, position.longitude);
    if (distanceInMeters <= 50 &&
        _userData.isSendCheckin &&
        !_isWeekend &&
        isValidTimeRange(
            TimeOfDay(hour: 6, minute: 00), TimeOfDay(hour: 23, minute: 59))) {
      _presenter.onUserCheckin(UserCheckinApiRequest());
      _dismisNotificationLocation();
    }
  }

  bool isValidTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
    TimeOfDay now = TimeOfDay.now();
    return ((now.hour > startTime.hour) ||
            (now.hour == startTime.hour && now.minute >= startTime.minute)) &&
        ((now.hour < endTime.hour) ||
            (now.hour == endTime.hour && now.minute <= endTime.minute));
  }

  void _dismisNotificationLocation() {
    _userData.isSendCheckin = false;
    _userData.save();
    refreshUI();
  }

  void _updatePositionList(_PositionItemType type, String displayValue) {
    _positionItems.add(_PositionItem(type, displayValue));
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _updatePositionList(
        _PositionItemType.log,
        AppConstants.kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        _updatePositionList(
          _PositionItemType.log,
          AppConstants.kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _updatePositionList(
        _PositionItemType.log,
        AppConstants.kPermissionDeniedForeverMessage,
      );

      return false;
    }

    _updatePositionList(
      _PositionItemType.log,
      AppConstants.kPermissionGrantedMessage,
    );
    return true;
  }

  Future<void> initDynamicLinks() async {
    // https://sev2.page.link/iDzQ ==> deeplink Example
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      int id = int.parse(queryParams["id"]!);
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return DetailTicketPage(
              arguments:
                  DetailTicketArgs(id: id)); // TODO : add prefix for navigate
        },
      ));
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }
}

void callbackDispatcher() {
  Workmanager _workManager = Workmanager();

  _workManager.executeTask((task, inputData) async {
    await executeGetEvents();
    return Future.value(true);
  });
}

Future<void> executeGetEvents() async {
  Encrypter _encrypter = Encrypter();
  SharedPreferences _pref = await SharedPreferences.getInstance();
  Endpoints _endpoints = await createEndpoints(_pref, _encrypter);
  CalendarMapper _mapper = CalendarMapper(DateUtil());
  Dio dio = await createDio(_endpoints);
  ApiService _service = ApiService(
    dio,
    _encrypter.decrypt(_pref.getString(AppConstants.USER_DATA_TOKEN) ?? ""),
  );
  CalendarApiRepository _repository = CalendarApiRepository(
    _service,
    _endpoints,
    _mapper,
  );
  List<Calendar> _calendars = await _repository.findAll(
    GetEventsApiRequest(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(hours: 24)),
      invitedPHIDs: [
        _encrypter.decrypt(_pref.getString(AppConstants.USER_DATA_ID) ?? "")
      ],
    ),
  );
  FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();
  await _notification.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
    ),
  );
  tz.initializeTimeZones();
  tz.setLocalLocation(
    tz.getLocation(
      _pref.getString(AppConstants.USER_DATA_TIMEZONE) ?? DEFAULT_TIMEZONE,
    ),
  );
  _calendars.forEach(
    (event) {
      var android = AndroidNotificationDetails(
        AppConstants.NOTIFICATION_CHANNEL_ID,
        AppConstants.NOTIFICATION_CHANNEL_NAME,
        channelDescription: AppConstants.NOTIFICATION_CHANNEL_DESCRIPTION,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        groupKey: event.id,
      );
      var iOS = IOSNotificationDetails(
        threadIdentifier: event.id,
      );
      var notificationDetail = NotificationDetails(
        android: android,
        iOS: iOS,
      );
      DateTime beforeStart = event.startTime.subtract(Duration(minutes: 10));
      try {
        if (DateTime.now().isBefore(beforeStart)) {
          _notification.zonedSchedule(
            (event.id * 2).hashCode,
            event.name,
            "Acara ${event.name} akan dimulai dalam 10 menit lagi",
            tz.TZDateTime.from(
              beforeStart,
              tz.local,
            ),
            notificationDetail,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            payload: jsonEncode({
              "type": AppConstants.NOTIFICATION_TYPE_EVENT_REMINDER,
              "data": jsonEncode(event.toJson()),
            }),
          );
        }
        if (DateTime.now().isBefore(event.startTime)) {
          _notification.zonedSchedule(
            event.id.hashCode,
            event.name,
            "Acara ${event.name} sudah dimulai",
            tz.TZDateTime.from(
              event.startTime,
              tz.local,
            ),
            notificationDetail,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            payload: jsonEncode({
              "type": AppConstants.NOTIFICATION_TYPE_EVENT_REMINDER,
              "data": jsonEncode(event.toJson()),
            }),
          );
        }
      } catch (e) {
        print(e);
      }
    },
  );
}

Future<Dio> createDio(Endpoints endpoints) async {
  await dotenv.load(fileName: ".env");
  var dio = Dio();

  dio.options.connectTimeout = 60000;
  dio.options.receiveTimeout = 60000;
  dio.options.baseUrl = endpoints.baseUrl;
  dio.options.contentType = Headers.formUrlEncodedContentType;

  final uri = Uri.parse(endpoints.baseUrl);
  dio.options.headers["host"] = uri.host;

  return dio;
}

Future<Endpoints> createEndpoints(
    SharedPreferences pref, Encrypter encrypter) async {
  await dotenv.load(fileName: ".env");
  String _workspace =
      encrypter.decrypt(pref.getString(AppConstants.USER_DATA_WORKSPACE) ?? "");
  Endpoints endpoints =
      Endpoints("https://$_workspace${dotenv.env['SUITE_BASE_URL']}");
  return endpoints;
}

enum _PositionItemType {
  log,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
