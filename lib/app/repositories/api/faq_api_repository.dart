import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/faq_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/faq_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/faq_repository_interface.dart';
import 'package:mobile_sev2/domain/faq.dart';

class FaqApiRepository implements FaqRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  FaqMapper _mapper;

  FaqApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Faq>> findAll(GetFaqsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.faqs(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetFaqsApiResponse(resp);
  }
}
