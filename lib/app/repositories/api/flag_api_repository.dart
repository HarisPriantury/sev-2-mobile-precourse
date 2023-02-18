import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/flag_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/flag_repository.dart';
import 'package:mobile_sev2/domain/flag.dart';

class FlagApiRepository implements FlagRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  FlagMapper _mapper;

  FlagApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<bool> create(CreateFlagRequestInterface param) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.createFlag(),
        param as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> delete(DeleteFlagRequestInterface param) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.deleteFlag(),
        param as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<List<Flag>> findAll(GetFlagsRequestInterface param) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.getFlags(),
        param as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetFlagsApiRequest(resp);
  }
}
