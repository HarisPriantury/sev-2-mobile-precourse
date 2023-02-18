import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/policy_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/policy_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/policy_repository_interface.dart';
import 'package:mobile_sev2/domain/policy.dart';
import 'package:mobile_sev2/domain/space.dart';

class PolicyApiRepository implements PolicyRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  PolicyMapper _mapper;

  PolicyApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Policy>> getPolicies(GetPoliciesRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.policies(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetPoliciesApiResponse(resp);
  }

  @override
  Future<List<Space>> getSpaces(GetSpacesRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.spaces(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetSpacesApiResponse(resp);
  }
}
