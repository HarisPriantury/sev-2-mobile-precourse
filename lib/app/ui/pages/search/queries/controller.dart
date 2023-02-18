import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/search/queries/presenter.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_query_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/get_query_db_request.dart';
import 'package:mobile_sev2/domain/query.dart';

class QueriesController extends BaseController {
  QueriesPresenter _presenter;
  UserData _userData;

  List<Query> _queries = [];

  QueriesController(this._presenter, this._userData);

  List<Query> get queries => _queries;

  void onGetQuery() {
    _presenter.onGetQuery(GetQueryDBRequest(_userData.workspace));
  }

  void onDeleteQuery(Query query) {
    _presenter.onDeleteQuery(DeleteQueryDBRequest(query));
  }

  @override
  void getArgs() {
    //
  }

  @override
  void initListeners() {
    _presenter.getQueryOnNext = (List<Query>? queries) {
      print("queries: success getQuery");
      _queries.clear();
      if (queries != null) {
        _queries.addAll(queries);
      }
      refreshUI();
    };

    _presenter.getQueryOnComplete = () {
      print("queries: completed getQuery");
    };

    _presenter.getQueryOnError = (e) {
      print("queries: error getQuery $e");
    };

    _presenter.deleteQueryOnNext = (bool? state) {
      print("queries: success deleteQuery $state");
      refreshUI();
    };

    _presenter.deleteQueryOnComplete = () {
      print("queries: completed deleteQuery");
      _presenter.onGetQuery(GetQueryDBRequest(_userData.workspace));
    };

    _presenter.deleteQueryOnError = (e) {
      print("queries: error deleteQuery $e");
    };
  }

  void refresh() {
    refreshUI();
  }

  @override
  void load() {
    onGetQuery();
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
