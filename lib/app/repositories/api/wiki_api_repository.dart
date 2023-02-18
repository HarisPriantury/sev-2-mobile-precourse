import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/wiki_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/wiki_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/wiki_repository_interface.dart';
import 'package:mobile_sev2/domain/wiki.dart';

class WikiApiRepository implements WikiRepository {
  WikiApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  Endpoints _endpoints;
  WikiMapper _mapper;
  ApiServiceInterface _service;

  @override
  Future<List<Wiki>> findAll(GetWikisRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.getWikis(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetWikisApiResponse(resp);
  }
}
