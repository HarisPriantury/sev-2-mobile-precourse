import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_calendar/args.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_calendar/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

class ProfileCalendarController extends BaseController {
  late ProfileCalendarArgs _data;

  ProfileCalendarPresenter _presenter;
  DateUtilInterface _dateUtil;
  UserData _userData;

  List<Calendar> _calendars = [];
  List<Calendar> _appointment = [];
  DateUtilInterface get dateUtil => _dateUtil;

  List<Calendar> get calendars => _calendars;

  List<Calendar> get appointment => _appointment;

  ProfileCalendarController(
    this._presenter,
    this._dateUtil,
    this._userData,
  );

  @override
  void getArgs() {
    if (args != null) {
      _data = args as ProfileCalendarArgs;
      _calendars = _data.calendars;
    }
  }

  @override
  void load() {
    loading(false);
  }

  void getEvents() {
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

  @override
  void initListeners() {
    _presenter.getEventsOnNext = (List<Calendar> calendars) {
      print("profile: success getEvents");
      _calendars.clear();
      _calendars.addAll(calendars);
      refreshUI();
    };

    _presenter.getEventsOnComplete = () {
      print("profile: completed getEvents");
      loading(false);
    };

    _presenter.getEventsOnError = (e) {
      loading(false);
      print("profile: error getEvents $e");
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

  void goToDetail(PhObject object) async {
    var result = await Navigator.pushNamed(
      context,
      Pages.eventDetail,
      arguments: DetailEventArgs(phid: object.id),
    );
    if (result != null) {
      load();
    }
    // then(
    //   (value) =>
    // );
  }

  void goToCreatePage() async {
    var result = await Navigator.pushNamed(context, Pages.create,
        arguments: CreateArgs(type: Calendar));
    if (result != null) {
      getEvents();
    }
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
