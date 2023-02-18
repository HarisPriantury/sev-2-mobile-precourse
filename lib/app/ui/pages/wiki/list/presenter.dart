import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/wiki_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/wiki.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';
import 'package:mobile_sev2/use_cases/wiki/get_wikis.dart';

class WikiListPresenter extends Presenter {
  WikiListPresenter(
    this._getWikisUseCase,
  );

  late Function getWikiOnComplete;
  late Function getWikiOnError;
  // get wiki
  late Function getWikiOnNext;

  GetWikisUseCase _getWikisUseCase;

  @override
  void dispose() {
    _getWikisUseCase.dispose();
  }

  void onGetWiki(GetWikisRequestInterface req) {
    _getWikisUseCase.execute(_GetWikisObserver(this, PersistenceType.api), req);
  }
}

class _GetWikisObserver implements Observer<List<Wiki>> {
  _GetWikisObserver(this._presenter, this._ptype);

  WikiListPresenter _presenter;
  PersistenceType _ptype;

  void onNext(List<Wiki>? wikis) {
    _presenter.getWikiOnNext(wikis, _ptype);
  }

  void onComplete() {
    _presenter.getWikiOnComplete(_ptype);
  }

  void onError(e) {
    _presenter.getWikiOnError(e, _ptype);
  }
}
