import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/calendar_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/lobby_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/lobby_repository_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

class LobbyApiRepository implements LobbyRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  LobbyMapper _mapper;
  CalendarMapper _calendarMapper;

  LobbyApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
    this._calendarMapper,
  );

  @override
  Future<Room> getHQ(GetRoomHQRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.lobbyHQ(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetRoomHQApiResponse(resp);
  }

  @override
  Future<List<User>> getParticipants(GetLobbyParticipantsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.lobbyParticipants(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetLobbyParticipantsApiResponse(resp);
  }

  @override
  Future<List<Room>> getRooms(GetLobbyRoomsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.lobbyRooms(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetLobbyRoomsApiResponse(resp);
  }

  @override
  Future<bool> updateStatus(UpdateStatusRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.lobbyUpdateStatus(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> join(JoinLobbyRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.lobbyJoin(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> joinChannel(JoinLobbyChannelRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.lobbyJoinChannel(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> leaveWork(LeaveWorkRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.lobbyLeaveWork(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> workOnTask(WorkOnTaskRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.lobbyWorkOnTask(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<List<Calendar>> getCalendars(GetLobbyRoomCalendarRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.lobbyRoomCalendar(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _calendarMapper.convertGetCalendarApiResponse(resp);
  }

  @override
  Future<List<File>> getFiles(GetLobbyRoomFilesRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.lobbyRoomFiles(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetFilesApiResponse(resp);
  }

  @override
  Future<List<Stickit>> getStickits(GetLobbyRoomStickitsRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.lobbyRoomStickit(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetStickitsApiResponse(resp);
  }

  @override
  Future<List<Ticket>> getTickets(GetLobbyRoomTasksRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.lobbyRoomTasks(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetTicketsApiResponse(resp);
  }

  @override
  Future<bool> createFile(CreateLobbyRoomFileRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> createStickit(CreateLobbyRoomStickitRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.createStickit(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> createTask(CreateLobbyRoomTaskRequestInterface request) async {
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
  Future<List<LobbyStatus>> getStatuses(GetLobbyStatusesRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.lobbyStatus(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetLobbyStatusesApiResponse(resp);
  }

  @override
  Future<bool> setAsReadStickit(SetAsReadStickitRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.seAsReadStcikit(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> storeListUser(StoreListUserDbRequestInterface params) {
    // TODO: implement storeListUser
    throw UnimplementedError();
  }

  @override
  Future<List<User>> getListUser(GetListUserFromDbRequestInterface params) {
    // TODO: implement getListUser
    throw UnimplementedError();
  }

  @override
  Future<bool> storeListReactions(StoreListReactionToDbRequestInterface params) {
    // TODO: implement storeListReactions
    throw UnimplementedError();
  }
}
