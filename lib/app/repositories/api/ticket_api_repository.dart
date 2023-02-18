import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/ticket_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/ticket_repository_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class TicketApiRepository implements TicketRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  TicketMapper _mapper;

  TicketApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Ticket>> findAll(GetTicketsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.tickets(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetTicketsApiResponse(resp);
  }

  @override
  Future<bool> create(CreateTicketRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<TicketSubscriberInfo> findInfo(GetTicketInfoRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.ticketInfo(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetTicketInfoApiResponse(resp);
  }

  @override
  Future<bool> taskTransaction(TaskTransactionRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.createTicket(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<TicketProjectInfo> findProjectInfo(
      GetTicketInfoRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.ticketInfo(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetTicketProjectInfoApiResponse(resp);
  }
}
