import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_query_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/get_query_db_request.dart';
import 'package:mobile_sev2/domain/query.dart';
import 'package:mobile_sev2/use_cases/search/delete_query.dart';
import 'package:mobile_sev2/use_cases/search/get_query.dart';

class QueriesPresenter extends Presenter {
  GetQueryUseCase _getQueryUseCase;
  DeleteQueryUseCase _deleteQueryUseCase;

  QueriesPresenter(this._getQueryUseCase, this._deleteQueryUseCase);

  // get queries
  late Function getQueryOnNext;
  late Function getQueryOnComplete;
  late Function getQueryOnError;

  // delete query
  late Function deleteQueryOnNext;
  late Function deleteQueryOnComplete;
  late Function deleteQueryOnError;

  void onGetQuery(GetQueryRequestInterface req) {
    if (req is GetQueryDBRequest) {
      _getQueryUseCase.execute(_GetQueryObserver(this), req);
    }
  }

  void onDeleteQuery(DeleteQueryRequestInterface req) {
    if (req is DeleteQueryDBRequest) {
      _deleteQueryUseCase.execute(_DeleteQueryObserver(this), req);
    }
  }

  @override
  void dispose() {
    _getQueryUseCase.dispose();
    _deleteQueryUseCase.dispose();
  }
}

class _GetQueryObserver implements Observer<List<Query>> {
  QueriesPresenter _presenter;

  _GetQueryObserver(this._presenter);

  void onNext(List<Query>? queries) {
    _presenter.getQueryOnNext(queries);
  }

  void onComplete() {
    _presenter.getQueryOnComplete();
  }

  void onError(e) {
    _presenter.getQueryOnError(e);
  }
}

class _DeleteQueryObserver implements Observer<bool> {
  QueriesPresenter _presenter;

  _DeleteQueryObserver(this._presenter);

  void onNext(bool? state) {
    _presenter.deleteQueryOnNext(state);
  }

  void onComplete() {
    _presenter.deleteQueryOnComplete();
  }

  void onError(e) {
    _presenter.deleteQueryOnError(e);
  }
}