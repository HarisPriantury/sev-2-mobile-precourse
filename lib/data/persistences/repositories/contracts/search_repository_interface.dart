import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/domain/meta/search_history.dart';
import 'package:mobile_sev2/domain/query.dart';

abstract class SearchRepositoryInterface {
  Future<List<SearchHistory>> findAll(GetSearchHistoryRequestInterface request);

  Future<bool> create(AddSearchHistoryRequestInterface request);

  Future<bool> delete(DeleteSearchHistoryRequestInterface request);

  Future<bool> deleteAll(DeleteAllSearchHistoryRequestInterface request);

  Future<List<Query>> findAllQueries(GetQueryRequestInterface request);

  Future<bool> createQuery(AddQueryRequestInterface request);

  Future<bool> deleteQuery(DeleteQueryRequestInterface request);
}