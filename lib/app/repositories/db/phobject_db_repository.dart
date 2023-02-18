import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/phobject/create_phobject_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/phobject_repository_interface.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';

class PhObjectDBRepository implements PhobjectRepository {
  Box<PhObject> _box;
  Box<PhTransaction> _tBox;

  PhObjectDBRepository(this._box, this._tBox);

  @override
  Future<bool> create(CreateObjectRequestInterface request) {
    var params = request as CreatePhObjectDBRequest;
    _box.put(params.obj.id, params.obj);
    return Future.value(true);
  }

  @override
  Future<List<PhObject>> findAll(GetObjectsRequestInterface params) {
    var objs = _box.values.toList();
    return Future.value(objs);
  }

  @override
  Future<List<PhTransaction>> findTransactions(GetObjectTransactionsRequestInterface params) {
    var tObjs = _tBox.values.toList();
    return Future.value(tObjs);
  }
}
