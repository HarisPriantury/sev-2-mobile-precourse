import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/use_cases/calendar/get_events.dart';

class MainCalendarPresenter extends Presenter {
  GetEventsUseCase _eventsUseCase;

  MainCalendarPresenter(this._eventsUseCase);

  // for get calendar events
  late Function getEventsOnNext;
  late Function getEventsOnComplete;
  late Function getEventsOnError;

  void onGetCalendars(GetEventsRequestInterface req) async {
    if (req is GetEventsApiRequest) {
      _eventsUseCase.execute(_GetEventsObserver(this), req);
    }
  }

  @override
  void dispose() {
    _eventsUseCase.dispose();
  }
}

class _GetEventsObserver implements Observer<List<Calendar>> {
  MainCalendarPresenter _presenter;

  _GetEventsObserver(this._presenter);

  void onNext(List<Calendar>? calendars) {
    _presenter.getEventsOnNext(calendars);
  }

  void onComplete() {
    _presenter.getEventsOnComplete();
  }

  void onError(e) {
    _presenter.getEventsOnError(e);
  }
}
