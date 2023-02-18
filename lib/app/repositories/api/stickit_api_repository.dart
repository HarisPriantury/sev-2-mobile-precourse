import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/stickit_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/stickit_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/stickit_repository_interface.dart';
import 'package:mobile_sev2/domain/stickit.dart';

class StickitApiRepositry implements StickitRepository {
  Endpoints _endpoints;
  StickitMapper _mapper;
  ApiServiceInterface _service;

  StickitApiRepositry(
    this._endpoints,
    this._mapper,
    this._service,
  );
  @override
  Future<List<Stickit>> findAll(GetStickitRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.getStickits(),
        params as ApiRequestInterface,
      );
    } catch (e) {
      rethrow;
    }
    return _mapper.convertGetStickitsApiResponse(resp);
  }
}
