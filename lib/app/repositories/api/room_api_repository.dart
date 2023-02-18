import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/room_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/room_repository_interface.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

class RoomApiRepository implements RoomRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  RoomMapper _mapper;

  RoomApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<bool> addParticipants(AddParticipantsRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.createOrUpdateRoom(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<BaseApiResponse> create(CreateRoomRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.createOrUpdateRoom(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertCreateRoomApiResponse(resp);
  }

  @override
  Future<bool> delete(DeleteRoomRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.deleteRoom(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<List<Room>> findAll(GetRoomsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.rooms(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetRoomsApiResponse(resp);
  }

  @override
  Future<List<User>> getParticipants(GetParticipantsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.getParticipants(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetParticipantsApiResponse(resp);
  }

  @override
  Future<bool> removeParticipants(RemoveParticipantsRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.createOrUpdateRoom(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> update(UpdateRoomRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.createOrUpdateRoom(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> restoreRoom(RestoreRoomRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.restoreRoom(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }
}
