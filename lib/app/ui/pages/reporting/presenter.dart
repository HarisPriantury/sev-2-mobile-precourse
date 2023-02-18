import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/flag/create_flag_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/use_cases/flag/create_flag.dart';

class ReportPresenter extends Presenter {
  CreateFlagUseCase _createFlagUseCase;
  ReportPresenter(
    this._createFlagUseCase,
  );
  @override
  void dispose() {
    _createFlagUseCase.dispose();
  }

  // create flag
  late Function createFlagOnNext;
  late Function createFlagOnComplete;
  late Function createFlagOnError;

  void onCreateFlag(CreateFlagRequestInterface req) {
    if (req is CreateFlagApiRequest) {
      _createFlagUseCase.execute(
        _CreateFlagObserver(
          this,
          PersistenceType.api,
        ),
        req,
      );
    }
  }
}

class _CreateFlagObserver implements Observer<bool> {
  ReportPresenter _presenter;
  PersistenceType _type;

  _CreateFlagObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.createFlagOnNext(result, _type);
  }

  void onComplete() {
    _presenter.createFlagOnComplete(_type);
  }

  void onError(e) {
    _presenter.createFlagOnError(e, _type);
  }
}
