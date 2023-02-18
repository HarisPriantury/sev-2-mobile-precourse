import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';

abstract class PhobjectRepository {
  Future<bool> create(CreateObjectRequestInterface request);
  Future<List<PhObject>> findAll(GetObjectsRequestInterface params);
  Future<List<PhTransaction>> findTransactions(
      GetObjectTransactionsRequestInterface params);
}
