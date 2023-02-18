import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/daily_mood/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/mood/get_moods_api_request.dart';
import 'package:mobile_sev2/data/payload/api/mood/send_mood_api_request.dart';
import 'package:mobile_sev2/domain/mood.dart';

class DailyMoodController extends BaseController {
  final TextEditingController _textFormController = TextEditingController();
  DialogMode _dialogMode = DialogMode.SelectMood;
  String _selectedMood = "";
  List<Mood> _mood = [];

  DailyMoodPresenter _presenter;
  UserData _userData;
  DateUtilInterface _dateUtil;

  TextEditingController get textFormController => _textFormController;

  bool get isFormNotEmpty => _textFormController.text.isNotEmpty;

  DialogMode get dialogMode => _dialogMode;

  String get selectedMood => _selectedMood;

  UserData get userData => _userData;

  String get firstName => _userData.name.split(" ").first;

  DateUtilInterface get dateUtil => _dateUtil;

  DailyMoodController(
    this._userData,
    this._presenter,
    this._dateUtil,
  );

  void changeMode(DialogMode mode) {
    if (mode == DialogMode.BlockerConfirm) {
      Timer(Duration(milliseconds: 500), () {
        _dialogMode = mode;
        refreshUI();
      });
    } else {
      _dialogMode = mode;
      refreshUI();
    }
  }

  void selectMood(String mood) {
    _selectedMood = mood;
    refreshUI();
  }

  void sendMood() {
    _presenter.onGetMoods(GetMoodsApiRequest(startDate(), [_userData.id]));
  }

  int startDate() {
    var dateNow = _dateUtil.now();
    var ms = _dateUtil
        .from(dateNow.year, dateNow.month, dateNow.day)
        .millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  @override
  void load() {}

  @override
  void initListeners() {
    //get mood
    _presenter.getMoodsOnNext = (List<Mood> mood, PersistenceType type) {
      print("mood: success getMood $type");

      _mood = mood;
    };

    _presenter.getMoodsOnComplete = (PersistenceType type) {
      print("mood: complete getMood $type");

      if (_mood.isEmpty) {
        _presenter.onSendMood(SendMoodApiRequest(
          mood: _selectedMood,
          message: _textFormController.text,
        ));
      }

      loading(false);
    };

    _presenter.getMoodsOnError = (e, PersistenceType type) {
      loading(false);
      print("mood: error getMood $e $type");
    };

    //send mood
    _presenter.sendMoodOnNext = (bool response, PersistenceType type) {
      print("mood: success sendMood $type");
    };

    _presenter.sendMoodOnComplete = (PersistenceType type) {
      print("mood: complete sendMood $type");

      loading(false);
    };

    _presenter.sendMoodOnError = (e, PersistenceType type) {
      loading(false);
      print("mood: error sendMood $e $type");
    };
  }

  @override
  void getArgs() {}

  @override
  void disposing() {}
}

enum DialogMode {
  SelectMood,
  BlockerConfirm,
  BlockerNote,
  Done,
  ThanksGreet,
  GoodDay,
}
