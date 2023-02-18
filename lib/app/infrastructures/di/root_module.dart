import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injector/injector.dart';
import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/app/infrastructures/events/ios_notification.dart';
import 'package:mobile_sev2/app/infrastructures/graphQl/graphql_api_client.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base64encoder.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/downloader.dart';
import 'package:mobile_sev2/app/infrastructures/misc/encrypter.dart';
import 'package:mobile_sev2/app/infrastructures/misc/file_picker.dart';
import 'package:mobile_sev2/app/infrastructures/misc/ringtone_player.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/persistences/api_service.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/signaling.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:workmanager/workmanager.dart';

class RootModule {
  static Future<void> init(Injector injector) async {
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();
    injector.registerDependency<Encrypter>(() => Encrypter());
    injector
        .registerSingleton<UserData>(() => UserData(injector.get<Encrypter>()));

    injector.registerSingleton(
      () {
        var dio = Dio();
        dio.options.connectTimeout = 60000;
        dio.options.receiveTimeout = 60000;
        return dio;
      },
      dependencyName: "dio_check_connection",
    );

    injector.registerSingleton(() => Workmanager());

    // TODO: cleanup later
    String _workspace = injector.get<UserData>().workspace;
    if (_workspace.isEmpty) {
      injector.get<UserData>().workspace = "refactory";
      injector.get<UserData>().save();
    }

    injector.registerSingleton<Endpoints>(() {
      String _workspace = injector.get<UserData>().workspace;
      return Endpoints("https://$_workspace${dotenv.env['SUITE_BASE_URL']}");
    });

    injector.registerSingleton<Dio>(
      () {
        var dio = Dio();
        var endpoints = injector.get<Endpoints>();

        dio.options.connectTimeout = 60000;
        dio.options.receiveTimeout = 60000;
        dio.options.baseUrl = endpoints.baseUrl;
        dio.options.contentType = Headers.formUrlEncodedContentType;

        final uri = Uri.parse(endpoints.baseUrl);
        dio.options.headers["host"] = uri.host;

        // add interceptors

        // Network Logger UI https://pub.dev/packages/requests_inspector
        if (!kReleaseMode) {
          // Dio Logger
          // dio.interceptors.add(RequestsInspectorInterceptor());
          dio.interceptors.add(dioLoggerInterceptor);
        }
        return dio;
      },
      dependencyName: "dio_api_request",
    );

    injector.registerSingleton<EventBus>(() {
      return EventBus();
    });

    injector.registerDependency<ApiService>(() {
      return ApiService(
        injector.get<Dio>(dependencyName: "dio_api_request"),
        injector.get<UserData>().token,
      );
    });

    injector.registerDependency<GraphQLApiClient>(() {
      return GraphQLApiClient();
    });

    // date utl
    injector.registerDependency<DateUtil>(() {
      return DateUtil(
        timezone: injector.get<UserData>().timezone,
        dateFormat: injector.get<UserData>().dateFormat,
        timeFormat: injector.get<UserData>().timeFormat,
      );
    });

    // messaging
    injector
        .registerSingleton<FirebaseMessaging>(() => FirebaseMessaging.instance);

    // event analytics
    injector.registerSingleton(() => FirebaseAnalytics.instance);

    // notification manager
    injector.registerDependency<AndroidInitializationSettings>(() {
      return AndroidInitializationSettings('app_icon');
    });

    injector.registerDependency<IOSInitializationSettings>(() {
      var _eventBus = injector.get<EventBus>();
      return IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          _eventBus.fire(IOSNotification(id, title!, payload!));
        },
      );
    });

    injector.registerDependency<InitializationSettings>(() {
      return InitializationSettings(
        android: injector.get<AndroidInitializationSettings>(),
        iOS: injector.get<IOSInitializationSettings>(),
      );
    });

    injector.registerDependency<FlutterLocalNotificationsPlugin>(() {
      return FlutterLocalNotificationsPlugin();
    });

    injector.registerDependency<AndroidNotificationDetails>(() {
      return AndroidNotificationDetails(
        AppConstants.NOTIFICATION_CHANNEL_ID,
        AppConstants.NOTIFICATION_CHANNEL_NAME,
        channelDescription: AppConstants.NOTIFICATION_CHANNEL_DESCRIPTION,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
    });

    injector.registerDependency<IOSNotificationDetails>(() {
      return IOSNotificationDetails();
    });

    injector.registerDependency<NotificationDetails>(() {
      return NotificationDetails(
        android: injector.get<AndroidNotificationDetails>(),
        iOS: injector.get<IOSNotificationDetails>(),
      );
    });

    // provide navigator key
    injector.registerSingleton<GlobalKey<NavigatorState>>(() {
      return GlobalKey<NavigatorState>();
    });

    // file uploader
    injector.registerSingleton<FilesPicker>(() => FilesPicker());

    // encoder
    injector.registerSingleton<Base64Encoder>(() => Base64Encoder());

    // Downloader
    injector.registerSingleton<Downloader>(
        () => Downloader(injector.get<EventBus>()));

    // Websocket

    // for dashboard
    injector.registerSingleton<WebSocketDashboardClient>(() {
      return WebSocketDashboardClient(
          "wss://$_workspace${dotenv.env['SUITE_WEBRTC_BASE_URL']}");
      // return WebSocketClient(env['WEBRTC_BASE_URL']!);
    }, dependencyName: "dashboard_websocket");

    // injector.registerSingleton<Signaling>(() {
    //   var userData = injector.get<UserData>();
    //   return Signaling(
    //     env['WEBRTC_ICE_TURN_URL']!,
    //     userData.id,
    //     env['WEBRTC_PASSWORD']!,
    //     injector.get<WebSocketRoomClient>(dependencyName: "dashboard_websocket"),
    //     userData,
    //   );
    // }, dependencyName: "dashboard_signaling");

    // for room
    injector.registerSingleton<WebSocketRoomClient>(() {
      return WebSocketRoomClient(dotenv.env['WEBRTC_ICE_BASE_URL']!);
    }, dependencyName: "room_websocket");

    injector.registerSingleton<Signaling>(() {
      var userData = injector.get<UserData>();
      return Signaling(
        dotenv.env['WEBRTC_ICE_TURN_URL']!,
        userData.id,
        dotenv.env['WEBRTC_PASSWORD']!,
        injector.get<WebSocketRoomClient>(dependencyName: "room_websocket"),
        userData,
      );
    }, dependencyName: "room_signaling");

    // ringtone
    injector.registerSingleton<RingtonePlayer>(() => RingtonePlayer());

    injector.registerSingleton<BehaviorSubject<Locale>>(() {
      return BehaviorSubject<Locale>();
    });

    injector.registerSingleton<Uuid>(() {
      return Uuid();
    });

    injector.registerSingleton<List<User>>(
      () => [],
      dependencyName: 'user_list',
    );

    injector.registerSingleton<List<Reaction>>(
      () => [
        // Reaction(
        //   "PHID-TOKN-like-1",
        //   name: "Like",
        //   emoticon: FontAwesomeIcons.solidThumbsUp,
        //   color: ColorsItem.urlColor,
        // ),
        // Reaction(
        //   "PHID-TOKN-like-2",
        //   name: "Dislike",
        //   emoticon: FontAwesomeIcons.solidThumbsDown,
        //   color: ColorsItem.redDA1414,
        // ),
        // Reaction(
        //   "PHID-TOKN-heart-1",
        //   name: "Love",
        //   emoticon: FontAwesomeIcons.solidHeart,
        //   color: ColorsItem.yellowFFA600,
        // ),
        // Reaction(
        //   "PHID-TOKN-heart-2",
        //   name: "Heartbreak",
        //   emoticon: FontAwesomeIcons.heartBroken,
        //   color: ColorsItem.redDA1414,
        // ),
        // Reaction(
        //   "PHID-TOKN-medal-1",
        //   name: "Orange Medal",
        //   emoticon: FontAwesomeIcons.medal,
        //   color: ColorsItem.orangeCC6000,
        // ),
        // Reaction(
        //   "PHID-TOKN-medal-2",
        //   name: "Grey Medal",
        //   emoticon: FontAwesomeIcons.medal,
        //   color: ColorsItem.grey8C8C8C,
        // ),
        // Reaction(
        //   "PHID-TOKN-medal-3",
        //   name: "Yellow Medal",
        //   emoticon: FontAwesomeIcons.medal,
        //   color: ColorsItem.yellowFFA600,
        // ),
        // Reaction(
        //   "PHID-TOKN-coin-4",
        //   name: "Mountain of Wealth",
        //   emoticon: FontAwesomeIcons.coins,
        //   color: ColorsItem.yellowFFA600,
        // ),
        // Reaction(
        //   "PHID-TOKN-misc-1",
        //   name: "Pterodactyl",
        //   emoticon: FontAwesomeIcons.dove,
        //   color: ColorsItem.urlColor,
        // ),
        // Reaction(
        //   "PHID-TOKN-misc-2",
        //   name: "Evil Spooky Haunted Tree",
        //   emoticon: FontAwesomeIcons.tree,
        //   color: ColorsItem.green219653,
        // ),
        // Reaction(
        //   "PHID-TOKN-emoji-2",
        //   name: "Party Time",
        //   emoticon: FontAwesomeIcons.gift,
        //   color: ColorsItem.green219653,
        // ),
        // Reaction(
        //   "PHID-TOKN-emoji-3",
        //   name: "Y So Serious",
        //   emoticon: FontAwesomeIcons.solidMehBlank,
        //   color: ColorsItem.grey8C8C8C,
        // ),
        // Reaction(
        //   "PHID-TOKN-emoji-5",
        //   name: "Cup of Joe",
        //   emoticon: FontAwesomeIcons.mugHot,
        //   color: ColorsItem.orangeCC6000,
        // ),
        // Reaction(
        //   "PHID-TOKN-emoji-7",
        //   name: "Burninate",
        //   emoticon: FontAwesomeIcons.fire,
        //   color: ColorsItem.redDA1414,
        // ),
        // Reaction(
        //   "PHID-TOKN-emoji-8",
        //   name: "Pirate Logo",
        //   emoticon: FontAwesomeIcons.skullCrossbones,
        //   color: ColorsItem.redDA1414,
        // ),
        // Reaction(
        //   "PHID-TOKN-extra-1",
        //   name: "Cool",
        //   emoticon: FontAwesomeIcons.solidLaughWink,
        //   color: ColorsItem.yellowFFA600,
        // ),
        // Reaction(
        //   "PHID-TOKN-extra-2",
        //   name: "Handshake",
        //   emoticon: FontAwesomeIcons.solidHandshake,
        //   color: ColorsItem.urlColor,
        // ),
        // Reaction(
        //   "PHID-TOKN-extra-3",
        //   name: "LoL",
        //   emoticon: FontAwesomeIcons.solidGrinSquintTears,
        //   color: ColorsItem.yellowFFA600,
        // ),
        // Reaction(
        //   "PHID-TOKN-extra-4",
        //   name: "Noted",
        //   emoticon: FontAwesomeIcons.thumbtack,
        //   color: ColorsItem.urlColor,
        // ),
        // Reaction(
        //   "PHID-TOKN-extra-5",
        //   name: "OK",
        //   emoticon: FontAwesomeIcons.check,
        //   color: ColorsItem.orangeFB9600,
        // ),
        // Reaction(
        //   "PHID-TOKN-extra-10",
        //   name: "Cheers!",
        //   emoticon: FontAwesomeIcons.glassCheers,
        //   color: ColorsItem.urlColor,
        // ),
      ],
      dependencyName: "reaction_list",
    );
  }
}
