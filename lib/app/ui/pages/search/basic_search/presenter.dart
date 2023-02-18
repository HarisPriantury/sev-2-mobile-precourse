import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/join_lobby_channel_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/search_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/search/add_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_all_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/get_search_history_db_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/meta/search_history.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/calendar/get_events.dart';
import 'package:mobile_sev2/use_cases/lobby/join_lobby_channel.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_rooms.dart';
import 'package:mobile_sev2/use_cases/search/add_search_history.dart';
import 'package:mobile_sev2/use_cases/search/delete_all_search_history.dart';
import 'package:mobile_sev2/use_cases/search/delete_search_history.dart';
import 'package:mobile_sev2/use_cases/search/get_search_history.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class BasicSearchPresenter extends Presenter {
  GetUsersUseCase _getUsersUseCase;
  GetRoomsUseCase _getRoomsUseCase;
  GetRoomParticipantsUseCase _participantsUseCase;
  GetTicketsUseCase _getTicketsUseCase;
  GetEventsUseCase _getEventsUseCase;
  GetProjectsUseCase _projectsUseCase;
  JoinLobbyChannelUseCase _joinLobbyChannelUseCase;
  GetSearchHistoryUseCase _getSearchHistoryUseCase;
  AddSearchHistoryUseCase _addSearchHistoryUseCase;
  DeleteSearchHistoryUseCase _deleteSearchHistoryUseCase;
  DeleteAllSearchHistoryUseCase _deleteAllSearchHistoryUseCase;

  BasicSearchPresenter(
    this._getUsersUseCase,
    this._getRoomsUseCase,
    this._participantsUseCase,
    this._getTicketsUseCase,
    this._getEventsUseCase,
    this._projectsUseCase,
    this._joinLobbyChannelUseCase,
    this._getSearchHistoryUseCase,
    this._addSearchHistoryUseCase,
    this._deleteSearchHistoryUseCase,
    this._deleteAllSearchHistoryUseCase,
  );

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // get rooms
  late Function getRoomsOnNext;
  late Function getRoomsOnComplete;
  late Function getRoomsOnError;

  // get room participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // get calendar events
  late Function getEventsOnNext;
  late Function getEventsOnComplete;
  late Function getEventsOnError;

  // get projects
  late Function getProjectsOnNext;
  late Function getProjectsOnComplete;
  late Function getProjectsOnError;

  // join lobby channel
  late Function joinLobbyChannelOnNext;
  late Function joinLobbyChannelOnComplete;
  late Function joinLobbyChannelOnError;

  // get search history
  late Function getSearchHistoryOnNext;
  late Function getSearchHistoryOnComplete;
  late Function getSearchHistoryOnError;

  // add search history
  late Function addSearchHistoryOnNext;
  late Function addSearchHistoryOnComplete;
  late Function addSearchHistoryOnError;

  // delete search history
  late Function deleteSearchHistoryOnNext;
  late Function deleteSearchHistoryOnComplete;
  late Function deleteSearchHistoryOnError;

  // delete search history
  late Function deleteAllSearchHistoryOnNext;
  late Function deleteAllSearchHistoryOnComplete;
  late Function deleteAllSearchHistoryOnError;

  void onGetUsers(GetUsersRequestInterface req) {
    if (req is GetUsersApiRequest) {
      _getUsersUseCase.execute(_GetUsersObserver(this), req);
    }
  }

  void onGetRooms(GetRoomsRequestInterface req) {
    if (req is GetRoomsApiRequest) {
      _getRoomsUseCase.execute(
          _GetRoomsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetRoomParticipants(GetParticipantsRequestInterface req) {
    if (req is GetParticipantsApiRequest) {
      _participantsUseCase.execute(
          _GetParticipantsObserver(this, req.roomId), req);
    }
  }

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _getTicketsUseCase.execute(
          _GetTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetEvents(GetEventsRequestInterface req) {
    if (req is GetEventsApiRequest) {
      _getEventsUseCase.execute(_GetEventsObserver(this), req);
    }
  }

  void onGetProjects(GetProjectsRequestInterface req) {
    _projectsUseCase.execute(_GetProjectsObserver(this), req);
  }

  void onJoinLobbyChannel(JoinLobbyChannelRequestInterface req, Room room) {
    if (req is JoinLobbyChannelApiRequest) {
      _joinLobbyChannelUseCase.execute(
          _JoinLobbyChannelObserver(this, PersistenceType.api, room), req);
    }
  }

  void onGetSearchHistory(GetSearchHistoryRequestInterface req) {
    if (req is GetSearchHistoryDBRequest) {
      _getSearchHistoryUseCase.execute(_GetSearchHistoryObserver(this), req);
    }
  }

  void onAddSearchHistory(AddSearchHistoryRequestInterface req) {
    if (req is AddSearchHistoryDBRequest) {
      _addSearchHistoryUseCase.execute(_AddSearchHistoryObserver(this), req);
    }
  }

  void onDeleteSearchHistory(DeleteSearchHistoryRequestInterface req) {
    if (req is DeleteSearchHistoryDBRequest) {
      _deleteSearchHistoryUseCase.execute(
          _DeleteSearchHistoryObserver(this), req);
    }
  }

  void onDeleteAllSearchHistory(DeleteAllSearchHistoryRequestInterface req) {
    if (req is DeleteAllSearchHistoryDBRequest) {
      _deleteAllSearchHistoryUseCase.execute(
          _DeleteAllSearchHistoryObserver(this), req);
    }
  }

  @override
  void dispose() {
    _getUsersUseCase.dispose();
    _getRoomsUseCase.dispose();
    _getTicketsUseCase.dispose();
    _getEventsUseCase.dispose();
    _joinLobbyChannelUseCase.dispose();
    _getSearchHistoryUseCase.dispose();
    _addSearchHistoryUseCase.dispose();
    _deleteSearchHistoryUseCase.dispose();
    _deleteAllSearchHistoryUseCase.dispose();
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  BasicSearchPresenter _presenter;

  _GetUsersObserver(this._presenter);

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users);
  }

  void onComplete() {
    _presenter.getUsersOnComplete();
  }

  void onError(e) {
    _presenter.getUsersOnError(e);
  }
}

class _GetRoomsObserver implements Observer<List<Room>> {
  BasicSearchPresenter _presenter;
  PersistenceType _type;

  _GetRoomsObserver(this._presenter, this._type);

  void onNext(List<Room>? rooms) {
    _presenter.getRoomsOnNext(rooms, _type);
  }

  void onComplete() {
    _presenter.getRoomsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getRoomsOnError(e, _type);
  }
}

class _GetParticipantsObserver implements Observer<List<User>> {
  BasicSearchPresenter _presenter;
  String _roomId;

  _GetParticipantsObserver(this._presenter, this._roomId);

  void onNext(List<User>? users) {
    _presenter.getParticipantsOnNext(users, _roomId);
  }

  void onComplete() {
    _presenter.getParticipantsOnComplete();
  }

  void onError(e) {
    _presenter.getParticipantsOnError(e);
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  BasicSearchPresenter _presenter;
  PersistenceType _type;

  _GetTicketsObserver(this._presenter, this._type);

  void onNext(List<Ticket>? tickets) {
    _presenter.getTicketsOnNext(tickets, _type);
  }

  void onComplete() {
    _presenter.getTicketsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTicketsOnError(e, _type);
  }
}

class _GetEventsObserver implements Observer<List<Calendar>> {
  BasicSearchPresenter _presenter;

  _GetEventsObserver(this._presenter);

  void onNext(List<Calendar>? calendars) {
    _presenter.getEventsOnNext(calendars);
  }

  void onComplete() {
    _presenter.getEventsOnComplete();
  }

  void onError(e) {
    _presenter.getEventsOnError(e);
  }
}

class _GetProjectsObserver implements Observer<List<Project>> {
  BasicSearchPresenter _presenter;

  _GetProjectsObserver(this._presenter);

  void onNext(List<Project>? projects) {
    _presenter.getProjectsOnNext(projects);
  }

  void onComplete() {
    _presenter.getProjectsOnComplete();
  }

  void onError(e) {
    _presenter.getProjectsOnError(e);
  }
}

class _JoinLobbyChannelObserver implements Observer<bool> {
  BasicSearchPresenter _presenter;
  PersistenceType _type;
  Room _room;

  _JoinLobbyChannelObserver(this._presenter, this._type, this._room);

  void onNext(bool? room) {
    _presenter.joinLobbyChannelOnNext(room, _type);
  }

  void onComplete() {
    _presenter.joinLobbyChannelOnComplete(_type, this._room);
  }

  void onError(e) {
    _presenter.joinLobbyChannelOnError(e, _type);
  }
}

class _GetSearchHistoryObserver implements Observer<List<SearchHistory>> {
  BasicSearchPresenter _presenter;

  _GetSearchHistoryObserver(this._presenter);

  void onNext(List<SearchHistory>? histories) {
    _presenter.getSearchHistoryOnNext(histories);
  }

  void onComplete() {
    _presenter.getSearchHistoryOnComplete();
  }

  void onError(e) {
    _presenter.getSearchHistoryOnError(e);
  }
}

class _AddSearchHistoryObserver implements Observer<bool> {
  BasicSearchPresenter _presenter;

  _AddSearchHistoryObserver(this._presenter);

  void onNext(bool? state) {
    _presenter.addSearchHistoryOnNext(state);
  }

  void onComplete() {
    _presenter.addSearchHistoryOnComplete();
  }

  void onError(e) {
    _presenter.addSearchHistoryOnError(e);
  }
}

class _DeleteSearchHistoryObserver implements Observer<bool> {
  BasicSearchPresenter _presenter;

  _DeleteSearchHistoryObserver(this._presenter);

  void onNext(bool? state) {
    _presenter.deleteSearchHistoryOnNext(state);
  }

  void onComplete() {
    _presenter.deleteSearchHistoryOnComplete();
  }

  void onError(e) {
    _presenter.deleteSearchHistoryOnError(e);
  }
}

class _DeleteAllSearchHistoryObserver implements Observer<bool> {
  BasicSearchPresenter _presenter;

  _DeleteAllSearchHistoryObserver(this._presenter);

  void onNext(bool? state) {
    _presenter.deleteAllSearchHistoryOnNext(state);
  }

  void onComplete() {
    _presenter.deleteAllSearchHistoryOnComplete();
  }

  void onError(e) {
    _presenter.deleteAllSearchHistoryOnError(e);
  }
}
