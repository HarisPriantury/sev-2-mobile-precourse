import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/search/add_query_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/add_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_all_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_query_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/get_query_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/get_search_history_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/search_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/search_history.dart';
import 'package:mobile_sev2/domain/query.dart';

class SearchDBRepository implements SearchRepositoryInterface {
  Box<SearchHistory> _historyBox;
  Box<Query> _queryBox;

  SearchDBRepository(
    this._historyBox,
    this._queryBox,
  );

  @override
  Future<bool> create(AddSearchHistoryRequestInterface request) {
    var param = request as AddSearchHistoryDBRequest;
    _historyBox.add(param.history);
    return Future.value(true);
  }

  @override
  Future<List<SearchHistory>> findAll(GetSearchHistoryRequestInterface params) {
    List<SearchHistory> histories = List.empty(growable: true);
    var param = params as GetSearchHistoryDBRequest;
    for (SearchHistory history in _historyBox.values) {
      if (history.workspace == param.workspace) histories.add(history);
    }
    return Future.value(histories);
  }

  @override
  Future<bool> delete(DeleteSearchHistoryRequestInterface request) {
    var param = request as DeleteSearchHistoryDBRequest;
    param.history.delete();
    return Future.value(true);
  }

  @override
  Future<bool> deleteAll(DeleteAllSearchHistoryRequestInterface request) {
    var param = request as DeleteAllSearchHistoryDBRequest;
    _historyBox.deleteAll(_historyBox.keys.where((element) => _historyBox.get(element)?.workspace == param.workspace));
    return Future.value(true);
  }

  @override
  Future<bool> createQuery(AddQueryRequestInterface request) {
    var param = request as AddQueryDBRequest;
    _queryBox.add(param.query);
    return Future.value(true);
  }

  @override
  Future<bool> deleteQuery(DeleteQueryRequestInterface request) {
    var param = request as DeleteQueryDBRequest;
    param.query.delete();
    return Future.value(true);
  }

  @override
  Future<List<Query>> findAllQueries(GetQueryRequestInterface request) {
    List<Query> queries = List.empty(growable: true);
    var param = request as GetQueryDBRequest;
    for (Query query in _queryBox.values) {
      if (query.workspace == param.workspace) queries.add(query);
    }
    return Future.value(queries);
  }
}
