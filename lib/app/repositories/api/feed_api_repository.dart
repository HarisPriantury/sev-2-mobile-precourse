import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/feed_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/feed_repository_interface.dart';
import 'package:mobile_sev2/domain/feed.dart';

class FeedApiRepository implements FeedRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  FeedMapper _mapper;

  FeedApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Feed>> findAll(GetFeedsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.feeds(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetFeedsApiResponse(resp);
  }
}
