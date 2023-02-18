import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/calendar_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/calendar_repository_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';

class CalendarApiRepository implements CalendarRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  CalendarMapper _mapper;

  CalendarApiRepository(this._service, this._endpoints, this._mapper);

  @override
  Future<bool> join(JoinEventRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.joinEvent(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<List<Calendar>> findAll(GetEventsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.getEvents(),
        params as ApiRequestInterface,
      );
     
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetEventsApiResponse(resp);
  }

  @override
  Future<bool> create(CreateEventRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.createCalendar(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }
}
