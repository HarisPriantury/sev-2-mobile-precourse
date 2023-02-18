import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/search/add_query_db_request.dart';
import 'package:mobile_sev2/use_cases/search/add_query.dart';

class AdvancedSearchPresenter extends Presenter {
  AddQueryUseCase _queryUseCase;

  AdvancedSearchPresenter(this._queryUseCase);

  // add query
  late Function addQueryOnNext;
  late Function addQueryOnComplete;
  late Function addQueryOnError;

  void onAddQuery(AddQueryRequestInterface req) {
    if (req is AddQueryDBRequest) {
      _queryUseCase.execute(_AddQueryObserver(this), req);
    }
  }

  @override
  void dispose() {
    _queryUseCase.dispose();
  }
}

class _AddQueryObserver implements Observer<bool> {
  AdvancedSearchPresenter _presenter;

  _AddQueryObserver(this._presenter);

  void onNext(bool? state) {
    _presenter.addQueryOnNext(state);
  }

  void onComplete() {
    _presenter.addQueryOnComplete();
  }

  void onError(e) {
    _presenter.addQueryOnError(e);
  }
}
