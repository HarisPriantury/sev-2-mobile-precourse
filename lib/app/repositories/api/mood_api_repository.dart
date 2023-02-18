import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/mood_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/mood_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/mood_repository_interface.dart';
import 'package:mobile_sev2/domain/mood.dart';

class MoodApiRepository implements MoodRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  MoodMapper _mapper;

  MoodApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Mood>> findAll(GetMoodsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.getMoods(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetMoodApiResponse(resp);
  }

  @override
  Future<bool> sendMood(SendMoodRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.sendMood(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }
}
