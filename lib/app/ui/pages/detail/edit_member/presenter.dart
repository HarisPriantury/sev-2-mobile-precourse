import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/use_cases/calendar/create_event.dart';

class EditMemberPresenter extends Presenter {
  CreateEventUseCase _createEventUseCase;

  EditMemberPresenter(this._createEventUseCase);

  late Function createEventOnNext;
  late Function createEventOnComplete;
  late Function createEventOnError;

  @override
  void dispose() {
    _createEventUseCase.dispose();
  }

  void onCreateEvent(CreateEventRequestInterface req) {
    if (req is CreateEventApiRequest) {
      _createEventUseCase.execute(_EventTransactionObserver(this), req);
    }
  }
}

class _EventTransactionObserver implements Observer<bool> {
  EditMemberPresenter _presenter;

  _EventTransactionObserver(this._presenter);

  void onNext(bool? result) {
    _presenter.createEventOnNext(result);
  }

  void onComplete() {
    _presenter.createEventOnComplete();
  }

  void onError(e) {
    _presenter.createEventOnError(e);
  }
}
