import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/calendar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_calendar/args.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class MainCalendarController extends BaseController {
  MainCalendarPresenter _presenter;
  DateUtilInterface _dateUtil;
  UserData _userData;
  DateTime _now = DateTime.now();
  List<Calendar> _calendars = [];
  List<Calendar> _appointment = [];

  DateTime get now => _now;
  DateUtilInterface get dateUtil => _dateUtil;
  List<Calendar> get calendars => _calendars;
  List<Calendar> get appointment => _appointment;
  UserData get userData => _userData;

  MainCalendarController(
    this._presenter,
    this._dateUtil,
    this._userData,
  );

  @override
  void getArgs() {}

  @override
  void load() {
    _getEvents();
  }

  @override
  void initListeners() {
    _presenter.getEventsOnNext = (List<Calendar> calendars) {
      print("calendar: success getEvents");
      _calendars.clear();
      _calendars.addAll(calendars);
      refreshUI();
    };

    _presenter.getEventsOnComplete = () {
      print("calendar: completed getEvents");
      loading(false);
    };

    _presenter.getEventsOnError = (e) {
      loading(false);
      print("calendar: error getEvents $e");
    };
  }

  void goToDetailEvent(PhObject object) async {
    var result = await Navigator.pushNamed(
      context,
      Pages.eventDetail,
      arguments: DetailEventArgs(phid: object.id),
    );
    if (result != null) {
      loading(true);
      _getEvents();
    }
  }

  void _getEvents() {
    loading(true);
    var now = _dateUtil.now();
    _presenter.onGetCalendars(
      GetEventsApiRequest(
        invitedPHIDs: [_userData.id],
        startDate: now.subtract(Duration(days: 30)),
        endDate: now.add(Duration(days: 30)),
      ),
    );
  }

  void onTapEvent(List<dynamic>? data) {
    _appointment.clear();
    if (data != null) {
      for (dynamic event in data) {
        Calendar calendar = event as Calendar;
        appointment.add(calendar);
      }
    }
    refreshUI();
  }

  bool isToday(DateTime date) {
    DateTime now = _dateUtil.now();
    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  void goToDetailCalendar() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.profileCalendar,
      arguments: ProfileCalendarArgs(_calendars),
    );
    if (result != null) {
      loading(true);
      _getEvents();
    }
  }

  void goToDetail(PhObject object) async {
    var result = await Navigator.pushNamed(
      context,
      Pages.eventDetail,
      arguments: DetailEventArgs(phid: object.id),
    );
    if (result != null) {
      load();
    }
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
