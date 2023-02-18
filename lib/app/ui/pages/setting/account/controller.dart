import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sev2/app/infrastructures/events/logout.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/events/setting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/package_info.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/user/user_delete_account_api_request.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingController extends SheetController {
  SettingPresenter _presenter;
  DateUtilInterface _dateUtil;
  UserData _userData;
  EventBus _eventBus;

  // local db
  Box<Phone> _phoneBox;
  Box<Email> _emailBox;

  StreamSubscription? _refreshEvent;
  bool _isBatteryPermissionGranted = false;
  PermissionStatus? _batteryPermission;

  SettingController(this._presenter, this._userData, this._eventBus,
      this._phoneBox, this._emailBox, this._dateUtil);

  UserData get userData => _userData;

  // date time
  String? _timezone;
  String? _timeFormat;
  String? _dateFormat;
  String? _firstDayOfWeek;
  String? get timezone => _timezone;
  String? get timeFormat => _timeFormat;
  String? get dateFormat => _dateFormat;
  String? get firstDayOfWeek => _firstDayOfWeek;
  bool get isBatteryPermissionGranted => _isBatteryPermissionGranted;

  final Map<String, String> timezoneList = {
    "Asia/Jakarta": "UTC +07:00, Asia, Jakarta (Default)",
    "Asia/Kuala_Lumpur": "UTC+08:00, Asia, Kuala Lumpur",
    "Asia/Jayapura": "UTC+09:00, Asia, Jayapura",
  };

  final Map<String, String> timeFormatList = {
    "hh:mm a": "12 Hour, 2:34 PM (Default)",
    "HH:mm": "24 Hour, 14:34"
  };

  final Map<String, String> dateFormatList = {
    "yyyy-MM-d": "ISO 8601: 2000-02-28 (Default)",
    "d/MM/yyyy": "US 2/28/2000",
    "dd-MM-yyyy": "Europe: 28-02-2000"
  };

  final Map<String, String> dayList = {
    "7": "Minggu (Default)",
    "1": "Senin",
    "2": "Selasa",
    "3": "Rabu",
    "4": "Kamis",
    "5": "Jumat",
    "6": "Sabtu",
  };

  void onTimeZoneChanged(String? val) {
    _timezone = val;
    _userData.timezone = val!;
    refreshUI();
  }

  void onTimeFormatChanged(String? val) {
    _timeFormat = val;
    _userData.timeFormat = val!;
    refreshUI();
  }

  void onDateFormatChanged(String? val) {
    _dateFormat = val;
    _userData.dateFormat = val!;
    refreshUI();
  }

  void onFirstDayOfWeekChanged(String? val) {
    _firstDayOfWeek = val;
    _userData.startWeek = val!;
    refreshUI();
  }

  void saveDateTime() {
    _userData.save();
    _eventBus.fire(Refresh());
    Navigator.pop(context);
  }

  // end date time

  // email
  bool _isEmailManageMode = false;
  bool _isEmailDeleteMode = false;
  bool _isEmailValidated = true;
  List<Email> _emailList = [];
  TextEditingController _newEmailController = new TextEditingController();

  bool get isEmailManageMode => _isEmailManageMode;
  bool get isEmailDeleteMode => _isEmailDeleteMode;
  List<Email> get emailList => _emailList;
  bool get isEmailValidated => _isEmailValidated;

  TextEditingController get newEmailController => _newEmailController;

  void onEmailManageMode(bool value) {
    _isEmailManageMode = value;
    refreshUI();
  }

  void onEmailDeleteMode(bool value) {
    _isEmailDeleteMode = value;
    refreshUI();
  }

  void onDeleteEmail(Email email) {
    _emailBox.delete(email.email);
    refreshPage();
  }

  void onValidateEmail(String email) {
    _isEmailValidated = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    refresh();
  }

  bool isEmailReady() {
    return _newEmailController.text.isNotEmpty && _isEmailValidated;
  }

  Email getPrimaryEmail() {
    var idx = _emailList.indexWhere((e) => e.isPrimary);

    if (idx < 0) {
      return _emailList.isNotEmpty ? _emailList.first : Email("", false);
    }

    return _emailList[idx];
  }

  List<Email> getNonPrimaryEmails() {
    List<Email> emails = [];
    emails.addAll(_emailList);
    var pe = this.getPrimaryEmail();
    emails.removeWhere((e) => e.email == pe.email);
    return emails;
  }

  void saveEmail() {
    if (newEmailController.text.isNotEmpty) {
      _emailBox.put(newEmailController.text,
          Email(newEmailController.text, _emailBox.isEmpty));
      refreshPage();
      this.showNotif(context, S.of(context).label_saving);
    }
  }

  void savePrimaryEmail(Email email) {
    Map<String, Email> newEmails = {};
    var emails = _emailBox.values.toList();
    emails.forEach((e) {
      if (e.email == email.email) {
        e.isPrimary = true;
      } else {
        e.isPrimary = false;
      }

      newEmails[e.email] = e;
    });

    _emailBox.clear();
    _isEmailManageMode = false;
    _isEmailDeleteMode = false;
    delay(() => _emailBox.putAll(newEmails), period: 1);
    refreshPage();
    this.showNotif(context, S.of(context).label_saving);
  }

  // end email

  // language

  final Map<String, String> languageList = {
    "id": "Bahasa Indonesia",
    "en": "English"
  };

  void saveLanguage() {
    _userData.save();
    refreshUI();
    _eventBus.fire(Refresh());
    _eventBus.fire(LanguageChanged());
    Navigator.pop(context);
  }

  void onLanguageChanged(String? val) {
    _userData.language = val!;
    refreshUI();
  }

  // end language

  // notification

  bool getNotifSetting(String type) {
    var idx = _userData.notifs.indexWhere((e) => e == type);
    return idx >= 0;
  }

  void onSetNotification(String type, bool value) {
    _saveNotifSetting(type, value);
  }

  void _saveNotifSetting(String type, bool value) {
    List<String> notifs = _userData.notifs;
    if (value) {
      var idx = notifs.indexWhere((e) => e == type);
      if (idx < 0) {
        notifs.add(type);
      }
    } else {
      notifs.removeWhere((e) => e == type);
    }

    _userData.notifs = notifs;
    _userData.save();

    refreshUI();
  }

  // end notification

  // phone

  bool _isPhoneManageMode = false;
  bool _isPhoneDeleteMode = false;
  bool _isPhoneValidated = true;
  TextEditingController _newNumberController = TextEditingController();
  List<Phone> _phoneList = [];

  bool get isPhoneManageMode => _isPhoneManageMode;
  bool get isPhoneDeleteMode => _isPhoneDeleteMode;
  List<Phone> get phoneList => _phoneList;
  bool get isPhoneValidated => _isPhoneValidated;

  TextEditingController get newNumberController => _newNumberController;

  void onPhoneManageMode(bool value) {
    _isPhoneManageMode = value;
    refreshUI();
  }

  void onPhoneDeleteMode(bool value) {
    _isPhoneDeleteMode = value;
    refreshUI();
  }

  void onDeletePhone(Phone phone) {
    _phoneBox.delete(phone.phone);
    refreshPage();
  }

  void onValidatePhone(String phone) {
    _isPhoneValidated = phone.startsWith("08") || phone.startsWith("+628");
    refresh();
  }

  bool isPhoneReady() {
    return _newNumberController.text.isNotEmpty && _isPhoneValidated;
  }

  Phone getPrimaryPhone() {
    var idx = _phoneList.indexWhere((e) => e.isPrimary);
    if (idx < 0) {
      return _phoneList.isNotEmpty ? _phoneList.first : Phone("", false);
    }
    return _phoneList[idx];
  }

  List<Phone> getNonPrimaryPhones() {
    List<Phone> phones = [];
    phones.addAll(_phoneList);
    var pe = this.getPrimaryPhone();
    phones.removeWhere((e) => e.phone == pe.phone);
    return phones;
  }

  void savePhone() {
    if (newNumberController.text.isNotEmpty) {
      _phoneBox.put(newNumberController.text,
          Phone(newNumberController.text, _phoneBox.isEmpty));
      refreshPage();
      this.showNotif(context, S.of(context).label_saving);
    }
  }

  void savePrimaryPhone(Phone phone) {
    Map<String, Phone> newPhones = {};
    var phones = _phoneBox.values.toList();
    phones.forEach((p) {
      if (p.phone == phone.phone) {
        p.isPrimary = true;
      } else {
        p.isPrimary = false;
      }

      newPhones[p.phone] = p;
    });

    _phoneBox.clear();
    _isPhoneManageMode = false;
    _isPhoneDeleteMode = false;
    delay(() => _phoneBox.putAll(newPhones), period: 1);
    refreshPage();
    this.showNotif(context, S.of(context).label_saving);
  }

  // end phone

  // package info

  Future<String> getVersionInfo() async {
    final _appVersion = await PackageInfoDevice.getVersion();
    return _appVersion;
  }

  // end package info

  // current year

  String getCurrentYear() {
    return _dateUtil.now().year.toString();
  }

  // end current year

  void goToAccountPage() {
    Navigator.pushNamed(context, Pages.account);
  }

  void goToDateTimePage() {
    Navigator.pushNamed(context, Pages.datetime);
  }

  void goToLanguagePage() {
    Navigator.pushNamed(context, Pages.language);
  }

  void goToPhonePage() {
    Navigator.pushNamed(context, Pages.phone);
  }

  void goToEmailPage() {
    Navigator.pushNamed(context, Pages.email);
  }

  void goToNotificationSettingPage() {
    Navigator.pushNamed(context, Pages.notificationSetting);
  }

  void goToFaqPage() {
    Navigator.pushNamed(context, Pages.faq);
  }

  void goToAppearancePage() {
    Navigator.pushNamed(context, Pages.appearance);
  }

  void goToContactPage() {
    Navigator.pushNamed(context, Pages.contact);
  }

  void goToSupportPage() {
    Navigator.pushNamed(context, Pages.support);
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {}

  @override
  void initListeners() {
    _refreshEvent?.cancel();
    _refreshEvent = _eventBus.on<Refresh>().listen((event) {
      load();
      delay(() => refreshUI(), period: 1);
    });
    _presenter.deleteAccountUserOnNext = (bool resp) {
      print("setting account: success deleteAccount $resp");
    };
    _presenter.deleteAccountUserOnComplete = () {
      print("setting account: completed deleteAccount");
      loading(false);
      _logout();
    };
    _presenter.deleteAccountUserOnError = (e) {
      print("setting account: error deleteAccount $e");
      loading(false);
    };
  }

  @override
  void load() {
    _emailList = _emailBox.values.toList();
    _phoneList = _phoneBox.values.toList();
  }

  void refreshPage() {
    delay(() => _eventBus.fire(Refresh()), period: 1);
  }

  void checkBatteryPermission() async {
    _batteryPermission = await Permission.ignoreBatteryOptimizations.request();

    if (_batteryPermission!.isGranted) {
      _isBatteryPermissionGranted = true;
      _userData.batteryPermissionGranted = true;
    } else {
      _isBatteryPermissionGranted = false;
      _userData.batteryPermissionGranted = false;
    }
    refreshUI();
  }

  void deleteAccount() {
    loading(true);
    _presenter.onDeleteAccount(UserDeleteAccountApiRequest());
    Navigator.pop(context);
  }

  void _logout() async {
    showOnLoading(context, "Log out...");
    await DataUtil.clearDb();
    await _userData.clear();
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
      context,
      Pages.publicSpace,
      (_) => false,
    );
  }
}
