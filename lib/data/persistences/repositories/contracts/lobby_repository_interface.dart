import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

abstract class LobbyRepository {
  Future<Room> getHQ(GetRoomHQRequestInterface params);
  Future<List<User>> getParticipants(GetLobbyParticipantsRequestInterface params);
  Future<List<Room>> getRooms(GetLobbyRoomsRequestInterface params);
  Future<bool> updateStatus(UpdateStatusRequestInterface request);
  Future<bool> join(JoinLobbyRequestInterface request);
  Future<bool> joinChannel(JoinLobbyChannelRequestInterface request);
  Future<bool> leaveWork(LeaveWorkRequestInterface request);
  Future<bool> workOnTask(WorkOnTaskRequestInterface request);
  Future<List<LobbyStatus>> getStatuses(GetLobbyStatusesRequestInterface request);
  Future<List<Calendar>> getCalendars(GetLobbyRoomCalendarRequestInterface request);
  Future<List<File>> getFiles(GetLobbyRoomFilesRequestInterface request);
  Future<List<Stickit>> getStickits(GetLobbyRoomStickitsRequestInterface request);
  Future<List<Ticket>> getTickets(GetLobbyRoomTasksRequestInterface request);
  Future<bool> createFile(CreateLobbyRoomFileRequestInterface request);
  Future<bool> createStickit(CreateLobbyRoomStickitRequestInterface request);
  Future<bool> setAsReadStickit(SetAsReadStickitRequestInterface request);
  Future<bool> createTask(CreateLobbyRoomTaskRequestInterface request);
  Future<bool> storeListUser(StoreListUserDbRequestInterface params);
  Future<List<User>> getListUser(GetListUserFromDbRequestInterface params);
  Future<bool> storeListReactions(StoreListReactionToDbRequestInterface params);
}
