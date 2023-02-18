class AppConstants {
  // user prefs
  static const String USER_DATA_ID = "id";
  static const String USER_DATA_INT_ID = "int_id";
  static const String USER_DATA_USERNAME = "username";
  static const String USER_DATA_NAME = "name";
  static const String USER_DATA_EMAIL = "email";
  static const String USER_DATA_PHONE = "phone_number";
  static const String USER_DATA_SECOND_PHONE = "second_phone_number";
  static const String USER_DATA_REGISTERED_AT = "registered_at";
  static const String USER_DATA_AVATAR = "avatar";
  static const String USER_DATA_TYPE = "type";
  static const String USER_DATA_WORKSPACE = "workspace";
  static const String USER_DATA_TOKEN = "token";
  static const String USER_DATA_ACCESS_TOKEN = "access_token";
  static const String USER_DATA_AUTH_PROVIDER = "auth_provider";
  static const String USER_DATA_SUB = "sub";
  static const String USER_DATA_FCM_TOKEN = "fcm_token";
  static const String USER_DATA_SUITE_ID = "suite_id";
  static const String USER_DATA_IS_RSP = "is_rsp";
  static const String USER_DATA_IS_ONBOARD = "is_onboard";
  static const String USER_DATA_CURRENT_CHANNEL = "current_channel";
  static const String USER_THEME = "user_theme";

  //Tooltip
  static const String USER_DATA_WORKSPACE_FINISHED =
      "workspace_tooltip_finished";
  static const String USER_DATA_LOBBY_FINISHED = "lobby_tooltip_finished";
  static const String USER_DATA_STATUS_FINISHED = "status_tooltip_finished";
  static const String USER_DATA_VOICE_FINISHED = "voice_tooltip_finished";

  // setting
  static const String USER_DATA_LANGUAGE = "language";
  static const String USER_DATA_TIMEZONE = "timezone";
  static const String USER_DATA_TIME_FORMAT = "time_format";
  static const String USER_DATA_DATE_FORMAT = "date_format";
  static const String USER_DATA_START_WEEK = "start_week";
  static const String USER_DATA_NOTIFS = "notifs";
  static const String BATTERY_PERMISSION_GRANTED = "battery_permission_granted";

  // notifications
  static const String NOTIFICATION_CHANNEL_ID = "suite_mobile_announcement";
  static const String NOTIFICATION_CHANNEL_NAME = "Suite Mobile";
  static const String NOTIFICATION_CHANNEL_DESCRIPTION =
      "Suite Mobile Notification Channel";

  static const String DOWNLOAD_FOLDER = "Download";

  // default avatar
  static const String DEFAULT_AVATAR_URL =
      "https://www.gravatar.com/avatar/?d=identicon";

  // notification type
  static const String NOTIFICATION_TYPE_PUSH_NOTIFICATION = "push-notification";
  static const String NOTIFICATION_TYPE_EVENT_REMINDER = "event-reminder";

  //checkin
  static const String SEND_CHECKIN = "send_checkin";

  // user roles
  static const String USER_APPROVED = "approved";
  static const String USER_EMAIL_VERIFIED = "verified";
  static const String USER_DISABLED = "disabled";
  static const String USER_REPORTED = "reported";

  // location permission
  static const String kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String kPermissionDeniedMessage = 'Permission denied.';
  static const String kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String kPermissionGrantedMessage = 'Permission granted.';
}

enum PersistenceType { api, db }
