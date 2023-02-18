import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/data/infrastructures/encrypter_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  late String id = "";
  late int intId = 0;
  late String username = "";
  late String name = "";
  late String email = "";
  late DateTime registeredAt = DateTime.now();
  late String avatar = AppConstants.DEFAULT_AVATAR_URL;
  late String workspace = "";
  late String token = "";
  late String accessToken = "";
  late String authProvider = "";
  late String sub = "";
  late String type = "";
  late String phoneNumber = "";
  late String secondPhoneNumber = "";
  late String fcmToken = "";
  late String suiteId = "";
  late String currentChannel = "";
  late bool isRSP = false;
  late bool isOnboard = false;
  late bool workspaceTooltipFinished = false;
  late bool lobbyTooltipFinished = false;
  late bool statusTooltipFinished = false;
  late bool voiceTooltipFinished = false;
  late bool isSendCheckin = false;
  late String language = "id";
  late String timezone = DEFAULT_TIMEZONE;
  late String timeFormat = DEFAULT_TIMEFORMAT;
  late String dateFormat = DEFAULT_DATEFORMAT;
  late String startWeek = "7";
  late String lastCheckin;
  late List<String> notifs = [];
  late String selectedTheme = AdaptiveThemeMode.system.modeName;
  late bool batteryPermissionGranted = false;

  EncrypterInterface _encrypter;

  UserData(this._encrypter) {
    this.loadData();
  }

  void loadData() {
    this._getSharedPreferences().then((sp) {
      this.selectedTheme =
          _decryptValue(sp.getString(AppConstants.USER_THEME)) ?? "";
      this.id = _decryptValue(sp.getString(AppConstants.USER_DATA_ID)) ?? "";
      this.intId = sp.getInt(AppConstants.USER_DATA_INT_ID) ?? 0;
      this.username =
          _decryptValue(sp.getString(AppConstants.USER_DATA_USERNAME)) ?? "";
      this.name =
          _decryptValue(sp.getString(AppConstants.USER_DATA_NAME)) ?? "";
      this.email =
          _decryptValue(sp.getString(AppConstants.USER_DATA_EMAIL)) ?? "";
      this.phoneNumber =
          _decryptValue(sp.getString(AppConstants.USER_DATA_PHONE)) ?? "";
      this.secondPhoneNumber =
          _decryptValue(sp.getString(AppConstants.USER_DATA_SECOND_PHONE)) ??
              "";
      this.registeredAt = DateTime.fromMillisecondsSinceEpoch(
          sp.getInt(AppConstants.USER_DATA_REGISTERED_AT) ?? 0);
      this.avatar =
          _decryptValue(sp.getString(AppConstants.USER_DATA_AVATAR)) ??
              AppConstants.DEFAULT_AVATAR_URL;
      if (this.avatar.isEmpty) {
        this.avatar = AppConstants.DEFAULT_AVATAR_URL;
      }
      this.workspace =
          _decryptValue(sp.getString(AppConstants.USER_DATA_WORKSPACE)) ?? "";
      this.token =
          _decryptValue(sp.getString(AppConstants.USER_DATA_TOKEN)) ?? "";
      this.accessToken =
          _decryptValue(sp.getString(AppConstants.USER_DATA_ACCESS_TOKEN)) ??
              "";
      this.authProvider =
          sp.getString(AppConstants.USER_DATA_AUTH_PROVIDER) ?? "";
      this.sub = _decryptValue(sp.getString(AppConstants.USER_DATA_SUB)) ?? "";
      this.fcmToken =
          _decryptValue(sp.getString(AppConstants.USER_DATA_FCM_TOKEN)) ?? "";
      this.type =
          _decryptValue(sp.getString(AppConstants.USER_DATA_TYPE)) ?? "";
      this.suiteId =
          _decryptValue(sp.getString(AppConstants.USER_DATA_SUITE_ID)) ?? "";
      this.currentChannel =
          sp.getString(AppConstants.USER_DATA_CURRENT_CHANNEL) ?? "";
      this.isRSP = sp.getBool(AppConstants.USER_DATA_IS_RSP) ?? false;
      this.isOnboard = sp.getBool(AppConstants.USER_DATA_IS_ONBOARD) ?? false;
      this.workspaceTooltipFinished =
          sp.getBool(AppConstants.USER_DATA_WORKSPACE_FINISHED) ?? false;
      this.lobbyTooltipFinished =
          sp.getBool(AppConstants.USER_DATA_LOBBY_FINISHED) ?? false;
      this.statusTooltipFinished =
          sp.getBool(AppConstants.USER_DATA_STATUS_FINISHED) ?? false;
      this.voiceTooltipFinished =
          sp.getBool(AppConstants.USER_DATA_VOICE_FINISHED) ?? false;
      this.language = sp.getString(AppConstants.USER_DATA_LANGUAGE) ?? "id";
      if (this.language != 'id' && this.language != 'en') {
        this.language = 'id';
      }

      this.timezone =
          sp.getString(AppConstants.USER_DATA_TIMEZONE) ?? DEFAULT_TIMEZONE;

      var tf = sp.getString(AppConstants.USER_DATA_TIME_FORMAT) ?? "";
      if (tf.isEmpty) tf = DEFAULT_TIMEFORMAT;

      var df = sp.getString(AppConstants.USER_DATA_DATE_FORMAT) ?? "";
      if (df.isEmpty) df = DEFAULT_DATEFORMAT;

      var sw = sp.getString(AppConstants.USER_DATA_START_WEEK) ?? "";
      if (sw.isEmpty) sw = DEFAULT_STARTOFWEEK;

      this.timeFormat = tf;
      this.dateFormat = df;
      this.startWeek = sw;
      this.notifs = sp.getStringList(AppConstants.USER_DATA_NOTIFS) ?? [];
      this.lastCheckin = sp.getString("NOW") ?? "";
      this.isSendCheckin = sp.getBool(AppConstants.SEND_CHECKIN) ?? false;
      this.batteryPermissionGranted =
          sp.getBool(AppConstants.BATTERY_PERMISSION_GRANTED) ?? false;
    });
  }

  Future<void> save() {
    return this._getSharedPreferences().then((sp) {
      sp.setString(AppConstants.USER_THEME, _encryptValue(this.selectedTheme));
      sp.setString(AppConstants.USER_DATA_ID, _encryptValue(this.id));
      sp.setInt(AppConstants.USER_DATA_INT_ID, this.intId);
      sp.setString(
          AppConstants.USER_DATA_USERNAME, _encryptValue(this.username));
      sp.setString(AppConstants.USER_DATA_NAME, _encryptValue(this.name));
      sp.setString(AppConstants.USER_DATA_EMAIL, _encryptValue(this.email));
      sp.setString(
          AppConstants.USER_DATA_PHONE, _encryptValue(this.phoneNumber));
      sp.setString(AppConstants.USER_DATA_SECOND_PHONE,
          _encryptValue(this.secondPhoneNumber));
      sp.setInt(AppConstants.USER_DATA_REGISTERED_AT,
          this.registeredAt.millisecondsSinceEpoch);
      sp.setString(AppConstants.USER_DATA_AVATAR, _encryptValue(this.avatar));
      sp.setString(
          AppConstants.USER_DATA_WORKSPACE, _encryptValue(this.workspace));
      sp.setString(AppConstants.USER_DATA_TOKEN, _encryptValue(this.token));
      sp.setString(
          AppConstants.USER_DATA_ACCESS_TOKEN, _encryptValue(this.accessToken));
      sp.setString(AppConstants.USER_DATA_AUTH_PROVIDER, this.authProvider);
      sp.setString(AppConstants.USER_DATA_SUB, _encryptValue(this.sub));
      sp.setString(
          AppConstants.USER_DATA_FCM_TOKEN, _encryptValue(this.fcmToken));
      sp.setString(AppConstants.USER_DATA_TYPE, _encryptValue(this.type));
      sp.setString(
          AppConstants.USER_DATA_SUITE_ID, _encryptValue(this.suiteId));
      sp.setString(AppConstants.USER_DATA_CURRENT_CHANNEL, this.currentChannel);
      sp.setBool(AppConstants.USER_DATA_IS_RSP, this.isRSP);
      sp.setBool(AppConstants.USER_DATA_IS_ONBOARD, this.isOnboard);
      sp.setBool(AppConstants.USER_DATA_WORKSPACE_FINISHED,
          this.workspaceTooltipFinished);
      sp.setBool(
          AppConstants.USER_DATA_LOBBY_FINISHED, this.lobbyTooltipFinished);
      sp.setBool(
          AppConstants.USER_DATA_STATUS_FINISHED, this.statusTooltipFinished);
      sp.setBool(
          AppConstants.USER_DATA_VOICE_FINISHED, this.voiceTooltipFinished);
      sp.setString(AppConstants.USER_DATA_LANGUAGE, this.language);
      sp.setString(AppConstants.USER_DATA_TIMEZONE, this.timezone);
      sp.setString(AppConstants.USER_DATA_TIME_FORMAT, this.timeFormat);
      sp.setString(AppConstants.USER_DATA_DATE_FORMAT, this.dateFormat);
      sp.setString(AppConstants.USER_DATA_START_WEEK, this.startWeek);
      sp.setStringList(AppConstants.USER_DATA_NOTIFS, this.notifs);
      sp.setString("NOW", this.lastCheckin);
      sp.setBool(AppConstants.SEND_CHECKIN, this.isSendCheckin);
      sp.setBool(AppConstants.BATTERY_PERMISSION_GRANTED,
          this.batteryPermissionGranted);
    });
  }

  Future<void> clear() async {
    SharedPreferences sp = await this._getSharedPreferences();
    this.clearProperties();
    sp.clear();
  }

  void clearProperties() {
    this.id = "";
    this.intId = 0;
    this.username = "";
    this.name = "";
    this.email = "";
    this.phoneNumber = "";
    this.secondPhoneNumber = "";
    this.registeredAt = DateTime.now();
    this.avatar = "";
    this.workspace = "";
    this.token = "";
    this.accessToken = "";
    this.authProvider = "";
    this.sub = "";
    this.fcmToken = "";
    this.type = "";
    this.suiteId = "";
    this.currentChannel = "";
    this.isRSP = false;
    this.isOnboard = false;
    this.workspaceTooltipFinished = false;
    this.lobbyTooltipFinished = false;
    this.statusTooltipFinished = false;
    this.voiceTooltipFinished = false;
    this.isSendCheckin = false;
    this.language = "";
    this.timezone = DEFAULT_TIMEZONE;
    this.timeFormat = DEFAULT_TIMEFORMAT;
    this.dateFormat = DEFAULT_DATEFORMAT;
    this.startWeek = "7";
    this.notifs = [];
    this.batteryPermissionGranted = false;
  }

  void fromUser(User user) {
    this.id = user.id;
    this.name = user.fullName!;
    this.username = user.name!;
    // this.email = user.email;
    this.phoneNumber = user.phoneNumber;
    this.secondPhoneNumber = user.secondPhoneNumber ?? "";
    this.avatar = user.avatar!;
    this.currentChannel = user.currentChannel ?? "";
  }

  User toUser() {
    return User(
      this.id,
      name: this.username,
      fullName: this.name,
      avatar: this.avatar,
      currentChannel: this.currentChannel,
    );
  }

  String getLanguage() {
    if (this.language.isEmpty) {
      this.language = "id";
    }

    return this.language;
  }

  bool isRefactoryMember() {
    return this.email.endsWith("@refactory.id");
  }

  bool isSuiteUser() {
    return !this.email.endsWith("@refactory.id") &&
        this.workspace == "Refactory";
  }

  bool isConnectUser() {
    return this.isSuiteUser() && !this.isRSP;
  }

  bool isLoggedIn() {
    return this.accessToken.isNotEmpty;
  }

  String _encryptValue(Object value) {
    return _encrypter.encrypt("$value");
  }

  String? _decryptValue(dynamic value, {type: String}) {
    String? result = _encrypter.decrypt("$value");
    if (type == "integer" && result == "") {
      result = "0";
    }

    if (result == "null") {
      result = null;
    }

    return result;
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    return SharedPreferences.getInstance();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'int_id': intId,
        'username': username,
        'name': name,
        'email': email,
        'avatar': avatar,
        'workspace': workspace,
        'token': token,
        'access_token': accessToken,
        'auth_provider': authProvider,
        'sub': sub,
        'type': type,
        'phoneNumber': phoneNumber,
        'secondPhoneNumber': secondPhoneNumber,
        'fcmToken': fcmToken,
        'suiteId': suiteId,
        'is_rsp': isRSP,
        'is_onboard': isOnboard,
        'workspace_tooltip_finished': workspaceTooltipFinished,
        'lobby_tooltip_finished': lobbyTooltipFinished,
        'status_tooltip_finished': statusTooltipFinished,
        'voice_tooltip_finished': voiceTooltipFinished,
        'send_checkin': isSendCheckin,
        'language': this.language,
        'timezone': this.timezone,
        'time_format': this.timeFormat,
        'date_format': this.dateFormat,
        'startweek': this.startWeek,
        'notifs': this.notifs,
        'battery_permission_granted': this.batteryPermissionGranted,
      };
}
