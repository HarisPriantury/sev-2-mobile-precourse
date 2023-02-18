import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/events/after_login.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/app/ui/pages/auth/splash/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/splash/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/args.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_workspace_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/delete_push_notifications_db_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashController extends BaseController {
  SplashArgs? _data;

  SplashPresenter _presenter;
  UserData _userData;
  bool _isJailBreak = false;
  List<Workspace> _workspaces = [];
  String _workspaceId = "";
  String _conpherencePHID = "";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  EventBus _eventBus;

  late BuildContext dialogContext;

  // permission needed: storage, camera, and audio
  PermissionStatus _statusStorage = PermissionStatus.denied;
  PermissionStatus _statusCamera = PermissionStatus.denied;
  PermissionStatus _statusAudio = PermissionStatus.denied;
  PermissionStatus _statusBattery = PermissionStatus.denied;

  bool get isJailBreak => _isJailBreak;

  // properties
  SplashController(
    this._presenter,
    this._userData,
    this._eventBus,
    this.flutterLocalNotificationsPlugin,
  ) : super() {
    // check and ask all permissions on load splash
    _userData.loadData();
    _checkPermission();
  }

  @override
  void load() {}

  // Need to check if device is rooted or not.
  // App only allowed to be run in non-rooted device
  void _navigate() {
    _openPage();
    // _checkJailBroken().then((val) {
    //   if (!val) {
    //     delay(() {
    //       _openPage();
    //     }, period: 3);
    //   } else {
    //     _isJailBreak = true;
    //     refreshUI();
    //   }
    // }).onError((error, stackTrace) {
    //   _openPage();
    // });
  }

  _openPage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    final NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (message != null && message.data.isNotEmpty) {
      _presenter.onDeletePushNotification(
        DeletePushNotificationsDBRequest(
          message.data['conpherencePHID'],
        ),
      );
      _workspaceId = message.data['workspaceID'];
      _conpherencePHID = message.data['conpherencePHID'];
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
    } else if (details != null && details.didNotificationLaunchApp) {
      if (details.payload != null) {
        Map<String, dynamic> _payload = jsonDecode(details.payload!);
        if (_payload['type'] ==
            AppConstants.NOTIFICATION_TYPE_PUSH_NOTIFICATION) {
          Map<String, dynamic> _data = jsonDecode(_payload['data']);
          final sendPort =
              IsolateNameServer.lookupPortByName("background_task");
          if (sendPort != null) {
            sendPort.send(_data['conpherencePHID']);
          }
          _presenter.onDeletePushNotification(
            DeletePushNotificationsDBRequest(
              _data['conpherencePHID'],
            ),
          );
          _workspaceId = _data['workspaceID'];
          _conpherencePHID = _data['conpherencePHID'];
          if (_data['workspaceID'] == _userData.workspace) {
            _presenter.onGetRooms(
                GetRoomsApiRequest(ids: [_data['conpherencePHID']]),
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
        } else if (_payload['type'] ==
            AppConstants.NOTIFICATION_TYPE_EVENT_REMINDER) {
          Map<String, dynamic> _data = jsonDecode(_payload['data']);
          Navigator.pushNamed(
            context,
            Pages.detail,
            arguments: DetailArgs(
              Calendar.fromJson(_data),
              from: Pages.splash,
            ),
          );
        } else {
          if (!_userData.isLoggedIn() || (_userData.workspace.isEmpty)) {
            Navigator.pushReplacementNamed(context, Pages.publicSpace,
                arguments: PublicSpaceArgs(false));
          } else {
            Navigator.pushReplacementNamed(context, Pages.main,
                arguments: MainArgs(Pages.splash));
          }
        }
      } else {
        if (!_userData.isLoggedIn() || (_userData.workspace.isEmpty)) {
          Navigator.pushReplacementNamed(context, Pages.publicSpace,
              arguments: PublicSpaceArgs(false));
        } else {
          Navigator.pushReplacementNamed(context, Pages.main,
              arguments: MainArgs(Pages.splash));
        }
      }
    } else {
      if (!_userData.isLoggedIn() || (_userData.workspace.isEmpty)) {
        Navigator.pushReplacementNamed(context, Pages.publicSpace,
            arguments: PublicSpaceArgs(false));
      } else {
        Navigator.pushReplacementNamed(context, Pages.main,
            arguments: MainArgs(Pages.splash));
      }
    }
  }

  _checkPermission() async {
    var storageGranted = await Permission.storage.request().isGranted;
    var cameraGranted = await Permission.camera.request().isGranted;
    var audioGranted = await Permission.microphone.request().isGranted;

    // check if app already has permission
    if (storageGranted) {
      _statusStorage = PermissionStatus.granted;
    }

    if (cameraGranted) {
      _statusCamera = PermissionStatus.granted;
    }

    if (audioGranted) {
      _statusAudio = PermissionStatus.granted;
    }
    if (!_userData.batteryPermissionGranted) {
      var batteryGranted =
          await Permission.ignoreBatteryOptimizations.request().isGranted;
      if (batteryGranted) {
        _statusBattery = PermissionStatus.granted;
        _userData.batteryPermissionGranted = true;
      }
      _userData.save();
    }

    // if all permission is granted, navigate user to main page,
    // otherwise, show permission request dialogue
    if (_statusStorage != PermissionStatus.granted ||
        _statusCamera != PermissionStatus.granted ||
        _statusAudio != PermissionStatus.granted) {
      _requestPermissions().whenComplete(() {
        _navigate();
      });
    } else {
      _navigate();
    }
  }

  @override
  void getArgs() {
    if (args != null) _data = args as SplashArgs;
    print(_data?.toPrint());
  }

  @override
  void initListeners() {
    _presenter.getRoomsOnNext =
        (List<Room> rooms, PersistenceType type, bool isRedirect) {
      print("main: success getRooms $type $isRedirect");
      if (rooms.isNotEmpty) {
        _getParticipants(rooms.first);
      }
    };

    _presenter.getRoomsOnComplete = (PersistenceType type, bool isRedirect) {
      print("main: completed getRooms $type $isRedirect");
    };

    _presenter.getRoomsOnError = (e, PersistenceType type, bool isRedirect) {
      loading(false);
      print("main: error getRooms: $e $type $isRedirect");
      Navigator.pushReplacementNamed(context, Pages.main,
          arguments: MainArgs(Pages.splash));
    };

    _presenter.getParticipantsOnNext = (List<User>? users, Room room) {
      print("room list: success getParticipants");
      if (users != null) {
        room.participants = users;
        _navigateToChat(room);
      }
    };

    _presenter.getParticipantsOnComplete = () {
      print("room list: completed getParticipants");
    };

    _presenter.getParticipantsOnError = (e) {
      loading(false);
      print("room list: error getParticipants $e");
    };

    _presenter.getWorkspaceOnNext = (List<Workspace> workspaces) {
      _workspaces.clear();
      _workspaces.addAll(workspaces);
      bool workspaceFound = false;
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
      Navigator.pop(dialogContext);
    };
    _presenter.updateWorkspaceOnNext = (bool resp) {
      print("splash: success updateWorkspace $resp");
      loading(false);
      Navigator.pushNamedAndRemoveUntil(context, Pages.main, (_) => false,
          arguments: MainArgs(Pages.login));

      _eventBus.fire(AfterLoginEvent());
    };

    _presenter.updateWorkspaceOnComplete = () {
      print("splash: completed updateWorkspace");
    };

    _presenter.updateWorkspaceOnError = (e) {
      loading(false);
      print("splash: error updateWorkspace $e");
    };

    _presenter.deletePushNotificationOnNext = (bool result) {
      print("splash: delete push notification success");
    };

    _presenter.deletePushNotificationOnComplete = () {
      print("splash: delete push notification completed");
    };

    _presenter.deletePushNotificationOnError = (e) {
      loading(false);
      print("splash: delete push notification error: $e");
    };
  }

  void _getParticipants(Room room) {
    _presenter.onGetRoomParticipants(GetParticipantsApiRequest(room.id), room);
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
            from: Pages.splash,
          ),
        );
      } else {
        Navigator.pushNamed(
          context,
          Pages.chat,
          arguments: ChatArgs(
            room,
            from: Pages.splash,
          ),
        );
      }
    }
  }

  // call request permission dialogue
  Future<void> _requestPermissions() async {
    await [
      Permission.storage,
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  // static const MethodChannel _channel = const MethodChannel('flutter_jailbreak_detection');
  //
  // Future<bool> _checkJailBroken() async {
  //   bool? jb;
  //   if (!isDebug()) {
  //     jb = await _channel.invokeMethod<bool>('jailbroken');
  //   }
  //   return jb ?? false;
  // }

  @override
  void disposing() {
    _presenter.dispose();
    // do nothing
  }

  void selectWorkspace(Workspace workspace) {
    _userData.token = workspace.token!;
    _userData.workspace = workspace.workspaceId;
    _userData.type = workspace.type ?? _userData.type;
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
}
