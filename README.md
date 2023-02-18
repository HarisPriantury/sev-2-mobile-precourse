[![CircleCI](https://circleci.com/gh/refactory-id/mobile-sev2/tree/master.svg?style=svg&circle-token=da33afad45c91fe629fbf63c6fa8bac494063c46)](https://circleci.com/gh/refactory-id/mobile-sev2/tree/master)

# SEV-2 Mobile

Awesome SEV-2 mobile app.
- 🤖 [Play Store](https://play.google.com/store/apps/details?id=com.sev_2.android)
- 🍎 [App Store](https://apps.apple.com/id/app/sev-2/id1579147012)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Library Used

- [Basic Utils](https://pub.dev/packages/basic_utils)
- [Connectivity Plus](https://pub.dev/packages/connectivity_plus)
- [Device Info](https://pub.dev/packages/device_info)
- [Dio](https://pub.dev/packages/dio)
- [Event Bus](https://pub.dev/packages/event_bus)
- [Flutter Clean Architecture](https://pub.dev/packages/flutter_clean_architecture)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Flutter Dotenv](https://pub.dev/packages/flutter_dotenv)
- [Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)
- [Injector](https://pub.dev/packages/injector)
- [intl](https://pub.dev/packages/intl)
- [Path Provider](https://pub.dev/packages/path_provider)
- [rxdart](https://pub.dev/packages/rxdart)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Encrypt](https://pub.dev/packages/encrypt)
- [Flutter Web Auth](https://pub.dev/packages/flutter_web_auth)
- [Google Fonts](https://pub.dev/packages/google_fonts)
- [Flutter SVG](https://pub.dev/packages/flutter_svg)
- [Expandable](https://pub.dev/packages/expandable)
- [gen_lang](https://github.com/glendmaatita/gen_lang_null_safety)
- [File Picker](https://pub.dev/packages/file_picker)
- [File Downloader](https://pub.dev/packages/flutter_downloader)
- [Permission Handler](https://pub.dev/packages/permission_handler)
- [Hive](https://pub.dev/packages/hive)
- [Crypto](https://pub.dev/packages/crypto)
- [Stream Transform](https://pub.dev/packages/stream_transform)
- [Flutter Jailbreak Detection](https://pub.dev/packages/flutter_jailbreak_detection)
- [Websocket Channel](https://pub.dev/packages/web_socket_channel)
- [Flutter WebRTC](https://pub.dev/packages/flutter_webrtc)
- [JWT Decode](https://pub.dev/packages/jwt_decode)
- [Cached Network Image](https://pub.dev/packages/cached_network_image)
- [Flutter Linkify](https://pub.dev/packages/flutter_linkify)
- [URL Launcher](https://pub.dev/packages/url_launcher)
- [Mime](https://pub.dev/packages/mime)
- [Font Awesome Flutter](https://pub.dev/packages/font_awesome_flutter)
- [Flutter Ringtone Player](https://pub.dev/packages/flutter_ringtone_player)
- [Styled Text](https://pub.dev/packages/styled_text)
- [Timezone](https://pub.dev/packages/timezone)
- [Flutter Link Previewer](https://pub.dev/packages/flutter_link_previewer)
- [SF Calendar](https://pub.dev/packages/syncfusion_flutter_calendar)
- [Video Player](https://pub.dev/packages/video_player)
- [Scrollable Positioned List](https://pub.dev/packages/scrollable_positioned_list)
- [Showcaseview](https://pub.dev/packages/showcaseview)
- [Shimmer](https://pub.dev/packages/shimmer)
- [uuid](https://pub.dev/packages/uuid)
- [Request Interceptor](https://pub.dev/packages/requests_inspector)
- [Adaptive Theme](https://pub.dev/packages/adaptive_theme)
- [Flutter Widget from HTML](https://pub.dev/packages/flutter_widget_from_html_core)
- [Geolocator](https://pub.dev/packages/geolocator)
- [flutter Markdown](https://pub.dev/packages/flutter_markdown)

## Install outside Google Play

There are some obstacles to have this app installed outside GPlay due to restrictions from Managed Profile.
If you want to install this app outside Google Play and willing to use email from Work Profile, these are the steps:
1. Make sure Work Profile is settle up in your mobile phone. Ref: [https://support.google.com/work/android/answer/6191949](https://support.google.com/work/android/answer/6191949)
2. Install Google Chrome or any other browser from Google Play of Work Profile
3. Install Android SDK and make sure Platform Tools is enabled. Ref: [https://guides.codepath.com/android/installing-android-sdk-tools](https://guides.codepath.com/android/installing-android-sdk-tools)
4. Connect the phone via USB. Choose File Transfer as debugging mode
5. Get phone device ID by run: `~$ ./adb devices -l`
6. Install app using ADB: `~$ ./adb -s [device id] install [location of apk]`
7. Open SEV-2 App from Work Profile Apps
