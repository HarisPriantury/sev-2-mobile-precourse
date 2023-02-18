import 'package:mobile_sev2/data/payload/contracts/wiki_request_interface.dart';
import 'package:mobile_sev2/domain/wiki.dart';

abstract class WikiRepository {
  Future<List<Wiki>> findAll(GetWikisRequestInterface params);
}
