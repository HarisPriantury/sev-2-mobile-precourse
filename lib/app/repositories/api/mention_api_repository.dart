import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/mention_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/mention_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/mention_repository.dart';
import 'package:mobile_sev2/domain/mention.dart';

class MentionApiRepository extends MentionRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  MentionMapper _mapper;

  MentionApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Mention>> findAll(GetMentionsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.mentions(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetMentionsApiResponse(resp);
  }
}
