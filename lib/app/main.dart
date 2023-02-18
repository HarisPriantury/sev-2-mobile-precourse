import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gen_lang/print_tool.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/events/after_login.dart';
import 'package:mobile_sev2/app/infrastructures/events/connection.dart';
import 'package:mobile_sev2/app/infrastructures/events/logout.dart';
import 'package:mobile_sev2/app/infrastructures/events/setting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/misc/utils.dart';
import 'package:mobile_sev2/app/infrastructures/router.dart' as AppRouter;
import 'package:mobile_sev2/app/repositories/db/push_notification_db_repository.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/auth/splash/view.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/delete_push_notifications_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/get_push_notifications_db_request.dart';
import 'package:mobile_sev2/data/payload/db/push_notification/store_push_notification_db_request.dart';
import 'package:mobile_sev2/domain/meta/push_notification.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart';

import 'infrastructures/misc/encrypter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  HttpOverrides.global = new MyHttpOverrides();
  AppComponent.init().then((_) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    runZonedGuarded(() {
      runApp(MyApp(savedThemeMode: savedThemeMode));
      // runApp(RequestsInspector(
      //   enabled: true,
      //   showInspectorOn: ShowInspectorOn.Both,
      //   child: MyApp(),
      // ));
    }, (error, stackTrace) {
      if (kReleaseMode)
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      else
        printError(stackTrace.toString());
    });
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BehaviorSubject<Locale> appLocale =
      AppComponent.getInjector().get<BehaviorSubject<Locale>>();

  final EventBus _eventBus = AppComponent.getInjector().get<EventBus>();
  final FirebaseMessaging _firebaseMessaging =
      AppComponent.getInjector().get<FirebaseMessaging>();

  final _navigatorKey =
      AppComponent.getInjector().get<GlobalKey<NavigatorState>>();

  final AppRouter.Router _router = AppRouter.Router();
  final UserData _userData = AppComponent.getInjector().get<UserData>();

  @override
  void dispose() {
    super.dispose();
    appLocale.close();
  }

  Stream<Locale> setLocale() {
    appLocale.sink.add(Locale(_userData.language));
    return appLocale.stream.distinct();
  }

  Widget _suiteApp(BuildContext context) {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarBrightness:
              Brightness.dark // Dark == white status bar -- for IOS.
          ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
          .copyWith(statusBarBrightness: Brightness.light));
    }
    var isTablet = Utils.isTablet();
    _userData.selectedTheme =
        widget.savedThemeMode?.modeName ?? AdaptiveThemeMode.light.modeName;
    _userData.save();
    return ScreenUtilInit(
      designSize: isTablet ? Size(1194, 834) : Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return StreamBuilder(
          stream: setLocale(),
          initialData: Locale(_userData.language),
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: AdaptiveTheme(
                initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
                light: ThemeData(
                  brightness: Brightness.light,
                  primarySwatch: Colors.blue,
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: ColorsItem.black,
                      ), //GoogleFonts.montserratTextTheme(),
                  scaffoldBackgroundColor: ColorsItem.whiteColor,
                  appBarTheme: AppBarTheme(
                    backgroundColor: ColorsItem.whiteE0E0E0,
                  ),
                  backgroundColor: ColorsItem.whiteE0E0E0,
                ),
                dark: ThemeData(
                  brightness: Brightness.dark,
                  primarySwatch: Colors.blue,
                  textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: ColorsItem.whiteColor,
                      ), //GoogleFonts.montserratTextTheme(),
                  scaffoldBackgroundColor: ColorsItem.black1F2329,
                  appBarTheme: AppBarTheme(
                    backgroundColor: ColorsItem.black191C21,
                  ),
                  bottomAppBarColor: ColorsItem.black191C21,
                  canvasColor: ColorsItem.black1F2329,
                ),
                builder: (theme, darkTheme) {
                  return MaterialApp(
                    // flutter pub run gen_lang:generate --source-dir=lib/app/ui/assets/resources/string --output-dir=lib/app/ui/assets/resources/generated --template-locale=id
                    // flutter packages pub run build_runner build --delete-conflicting-outputs
                    navigatorKey: _navigatorKey,
                    localizationsDelegates: [
                      S.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    debugShowCheckedModeBanner: false,
                    locale: snapshot.data as Locale,
                    title: 'SEV-2',
                    // theme: ThemeData(
                    //   primarySwatch: Colors.blue,
                    // textTheme: GoogleFonts.montserratTextTheme(),
                    // ),
                    theme: theme,
                    darkTheme: darkTheme,
                    home: SplashPage(),
                    onGenerateRoute: _router.getRoute,
                    navigatorObservers: [_router.routeObserver],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _initSuite(BuildContext context) async {
    if (Utils.isTablet()) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    // init firebase
    await Firebase.initializeApp();

    // fabric
    _initFabric();

    // FCM
    await _initFCM();

    _initConnectionListener();

    _initEventListeners(context);

    await _initDownloader(context);

    var byteData = await rootBundle.load('lib/app/ui/assets/2021a.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  Future<void> _initDownloader(BuildContext context) async {
    final dir = Theme.of(context).platform == TargetPlatform.android
        ? await (getExternalStorageDirectory())
        : await getApplicationDocumentsDirectory();

    var savedDir = Directory(
        dir!.path + Platform.pathSeparator + AppConstants.DOWNLOAD_FOLDER);

    if (!savedDir.existsSync()) {
      await savedDir.create(recursive: true);
    }

    await FlutterDownloader.initialize();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _initEventListeners(BuildContext context) {
    // after login, we need to reload user data and initiate FCM
    _eventBus.on<AfterLoginEvent>().listen((event) {
      _userData.loadData();
      Future.delayed(new Duration(seconds: 5), _initFCM);
    });

    _eventBus.on<LogoutEvent>().listen((event) async {
      // await _userData.clear();
      // await DataUtil.clearDb();
    });

    _eventBus.on<LanguageChanged>().listen((event) async {
      setLocale();
    });
  }

  _initFabric() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    Function? originalError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      originalError!(errorDetails);
    };
  }

  void _initConnectionListener() async {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      _checkConnection();
    });

    _eventBus.on<RetryConnectionEvent>().listen((event) {
      _checkConnection();
    });
  }

  void _checkConnection() async {
    bool isOnline = true;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _eventBus.fire(ConnectionEvent(isOnline));
  }

  Future<void> _initFCM() async {
    // only if user has fcm token that can init FCM
    if (_userData.token.isNullOrEmpty()) return;

    // ask permission for notification, iOS only
    if (Platform.isIOS) {
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initSuite(context),
      builder: (context, snapshot) {
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return _suiteApp(context);
        }

        return _suiteApp(context);
      },
    );
  }
}

// handle background message
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification == null) {
    // refresh dependencies
    await AppComponent.refresh();
    SharedPreferences _pref = await SharedPreferences.getInstance();
    Encrypter _encrypter = Encrypter();
    Box<PushNotification> _box = await Hive.openBox(PushNotification.getName());
    PushNotificationDBRepository repository =
        PushNotificationDBRepository(_box);
    List<PushNotification> notifications = await repository.findAll(
      GetPushNotificationsDBRequest(
        message.data['conpherencePHID'],
      ),
    );
    createNotification(
      message,
      notifications,
      _encrypter.decrypt(_pref.getString(AppConstants.USER_DATA_ID) ?? ""),
      repository,
    );
    ReceivePort _port = ReceivePort();
    IsolateNameServer.registerPortWithName(_port.sendPort, "background_task");
    _port.listen(
      (dynamic data) async {
        print("isolate background_task called");
        if (data is String) {
          String conpherencePHID = data;
          repository.delete(
            DeletePushNotificationsDBRequest(
              conpherencePHID,
            ),
          );
        }
      },
    );
  }
}

void createNotification(
  RemoteMessage message,
  List<PushNotification> notifications,
  String userId,
  PushNotificationDBRepository repository,
) {
  if (message.data['authorPHID'] != userId) {
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
    FlutterLocalNotificationsPlugin().show(
      message.data['conpherencePHID'].hashCode,
      message.data['title'],
      message.data['body'],
      notificationDetail,
      payload: jsonEncode({
        "type": AppConstants.NOTIFICATION_TYPE_PUSH_NOTIFICATION,
        "data": jsonEncode(message.data),
      }),
    );
    repository.store(
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
  }

  /// This code below is currently not working
  /// TODO:
  /// 1. save PHID for each workspaces
  /// 2. get list of PHIDs for each workspaces
  /// 3. check whether authorPHID is presence in the list
  /// 4. if yes, clear the notification
  else {
    FlutterLocalNotificationsPlugin().cancel(
      message.data['conpherencePHID'].hashCode,
    );
    repository.delete(
      DeletePushNotificationsDBRequest(
        message.data['conpherencePHID'],
      ),
    );
  }
}

void downloadCallback(String id, DownloadTaskStatus status, int progress) {
  final SendPort send =
      IsolateNameServer.lookupPortByName('downloader_send_port')!;
  send.send([id, status, progress]);
}
