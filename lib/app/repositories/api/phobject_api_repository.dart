import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/phobject_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/phobject_repository_interface.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';

class PhobjectApiRepository implements PhobjectRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  PhobjectMapper _mapper;

  PhobjectApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<PhObject>> findAll(GetObjectsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.objects(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetPhobjectsApiResponse(resp);
  }

  @override
  Future<bool> create(CreateObjectRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<List<PhTransaction>> findTransactions(GetObjectTransactionsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.objectTransactions(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetPhTransactionsApiResponse(resp);
  }
}
