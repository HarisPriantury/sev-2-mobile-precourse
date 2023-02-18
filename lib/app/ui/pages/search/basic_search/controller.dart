import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/app/ui/pages/search/basic_search/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/join_lobby_channel_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/db/search/add_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_all_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/delete_search_history_db_request.dart';
import 'package:mobile_sev2/data/payload/db/search/get_search_history_db_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/meta/search_history.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/query.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:stream_transform/stream_transform.dart';

class BasicSearchController extends BaseController {
  BasicSearchPresenter _presenter;
  DateUtilInterface _dateUtil;
  UserData _userData;
  EventBus _eventBus;

  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _streamController = StreamController();
  final FocusNode _focusNodeSearch = FocusNode();
  List<String> _filterList = [
    "Room",
    "Tugas",
    "Event",
    "User",
    "Project",
  ];
  String _filterValue = "";

  List<PhObject> _searchResults = [];
  List<Room> _rooms = [];
  List<SearchHistory> _searchHistory = [];
  List<String> _authoredBy = [];
  List<String> _subscribedBy = [];
  List<String> _statuses = [];

  bool _isSearch = false;
  bool _roomsSearchFinished = false;
  bool _usersSearchFinished = false;
  bool _eventsSearchFinished = false;
  bool _ticketsSearchFinished = false;
  bool _projectsSearchFinished = false;
  bool _isQuerySearch = false;
  bool _isJoining = false;
  late int _roomInitialLength;
  int _loadedRoom = 0;

  var _keyword = "";
  var _isPaginating = false;
  var _ticketLimit = 10;
  var _ticketAfter = "";
  var _userLimit = 10;
  var _userAfter = "";
  var _projectLimit = 10;
  var _projectAfter = "";
  var _eventLimit = 10;
  var _eventAfter = "";

  BasicSearchController(
    this._presenter,
    this._dateUtil,
    this._userData,
    this._eventBus,
  );

  bool get isSearch => _isSearch;

  bool get isQuerySearch => _isQuerySearch;

  bool get isPaginating => _isPaginating;

  List<PhObject> get searchResults => _searchResults;

  List<SearchHistory> get searchHistory => _searchHistory;

  DateUtil get dateUtil => _dateUtil as DateUtil;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  TextEditingController get searchController => _searchController;

  StreamController<String> get streamController => _streamController;

  List<String> get filterList => _filterList;

  String get filterValue => _filterValue;

  var _now = DateTime.now();

  @override
  void getArgs() {
    //
  }

  @override
  void initListeners() {
    _presenter.getSearchHistoryOnNext = (List<SearchHistory>? histories) {
      print("search: success getSearchHistory");
      histories?.forEach((element) {
        print("getSearchHistoryOnNext : ${element.keyword}");
      });
      _searchHistory.clear();
      if (histories != null) {
        _searchHistory.addAll(histories);
        _searchHistory.removeWhere((h) => h.keyword == " ");
      }
      refreshUI();
    };

    _presenter.getSearchHistoryOnComplete = () {
      print("search: completed getSearchHistory");
    };

    _presenter.getSearchHistoryOnError = (e) {
      print("search: error getSearchHistory $e");
    };

    _presenter.addSearchHistoryOnNext = (bool? state) {
      print("search: success addSearchHistory $state");
      _searchHistory.removeWhere((h) => h.keyword == " ");
    };

    _presenter.addSearchHistoryOnComplete = () {
      print("search: completed addSearchHistory");
    };

    _presenter.addSearchHistoryOnError = (e) {
      print("search: error addSearchHistory $e");
    };

    _presenter.getRoomsOnNext = (List<Room>? rooms, PersistenceType type) {
      print("search: success getRooms $type");
      if (rooms != null) {
        _roomInitialLength = rooms.length;
        _rooms.addAll(rooms);
        // 23 April 2022: Commented below, since there's found no essential needs to be executed
        // rooms.forEach((e) {
        //   _presenter.onGetRoomParticipants(GetParticipantsApiRequest(e.id));
        // });
      }
      // loading(false);
    };

    _presenter.getRoomsOnComplete = (PersistenceType type) {
      print("search: completed getRooms $type");
    };

    _presenter.getRoomsOnError = (e, PersistenceType type) {
      print("search: error getRooms $e $type");
      loading(false);
    };

    // get participants
    _presenter.getParticipantsOnNext = (List<User>? users, String roomId) {
      print("search: success getParticipants");
      if (users != null) {
        if (users.length > 2 &&
            users.indexWhere((element) => element.id == _userData.id) != -1) {
          var idx = _rooms.indexWhere((element) => element.id == roomId);
          _rooms[idx].participants = users;
        }
      }
      _loadedRoom++;
      if (_loadedRoom == _roomInitialLength) {
        // _rooms.sort((a, b) => b.lastMessageCreatedAt!.compareTo(a.lastMessageCreatedAt!));
        _rooms =
            _rooms.where((element) => element.participants != null).toList();
        loading(false);
      }
    };

    _presenter.getParticipantsOnComplete = () {
      print("search: completed getParticipants");
    };

    _presenter.getParticipantsOnError = (e) {
      print("search: error getParticipants $e");
      loading(false);
    };

    _presenter.getUsersOnNext = (List<User>? users) {
      print("search: success getUsers ${users?.length}");
      if (users != null) {
        _searchResults.addAll(users);
        if (users.isNotEmpty)
          _userAfter = users.last.intId.toString();
        else
          _isPaginating = false;
      }
      _usersSearchFinished = true;
      refreshUI();
    };

    _presenter.getUsersOnComplete = () {
      print("search: completed getUsers");
    };

    _presenter.getUsersOnError = (e) {
      print("search: error getUsers $e");
      _usersSearchFinished = true;
      refreshUI();
    };

    _presenter.getEventsOnNext = (List<Calendar>? events) {
      print("search: success getEvents");

      if (events != null) {
        _searchResults.addAll(events);
        if (events.isNotEmpty)
          _eventAfter = events.last.intId.toString();
        else
          _isPaginating = false;
      }
      _eventsSearchFinished = true;
      refreshUI();
    };

    _presenter.getEventsOnComplete = () {
      print("search: completed getEvents");
    };

    _presenter.getEventsOnError = (e) {
      print("search: error getEvents $e");
      _eventsSearchFinished = true;
      refreshUI();
    };

    _presenter.getTicketsOnNext =
        (List<Ticket>? tickets, PersistenceType type) {
      print("search: success getTickets $type");
      if (tickets != null) {
        _searchResults.addAll(tickets);
        if (tickets.isNotEmpty) _ticketAfter = tickets.last.intId.toString();
      }
      _ticketsSearchFinished = true;
      refreshUI();
    };

    _presenter.getTicketsOnComplete = (PersistenceType type) {
      print("search: completed getTickets $type");
    };

    _presenter.getTicketsOnError = (e, PersistenceType type) {
      print("search: error getTickets $e $type");
      _ticketsSearchFinished = true;
      refreshUI();
    };

    _presenter.getProjectsOnNext = (List<Project>? projects) {
      print("search: success getProjects");
      if (projects != null) {
        _searchResults.addAll(projects);
        if (projects.isNotEmpty)
          _projectAfter = projects.last.intId.toString();
        else
          _isPaginating = false;
      }
      _projectsSearchFinished = true;
      refreshUI();
    };

    _presenter.getProjectsOnComplete = () {
      print("search: completed getProjects");
    };

    _presenter.getProjectsOnError = (e) {
      print("search: error getProjects: $e");
      _projectsSearchFinished = true;
      refreshUI();
    };

    _presenter.joinLobbyChannelOnNext = (bool result, PersistenceType type) {
      print("search: success joinLobbyChannel $type");
      refreshUI();
    };

    _presenter.joinLobbyChannelOnComplete = (PersistenceType type, Room room) {
      print("search: completed joinLobbyChannel $type");
      joinLobbyRoom(room);
    };

    _presenter.joinLobbyChannelOnError = (e, PersistenceType type) {
      print("search: error joinLobbyChannel $e $type");
    };

    _presenter.deleteSearchHistoryOnNext = (bool? state) {
      print("search: success deleteSearchHistory $state");
      refreshUI();
    };

    _presenter.deleteSearchHistoryOnComplete = () {
      print("search: completed deleteSearchHistory");
      _presenter
          .onGetSearchHistory(GetSearchHistoryDBRequest(_userData.workspace));
    };

    _presenter.deleteSearchHistoryOnError = (e) {
      print("search: error deleteSearchHistory $e");
    };

    _presenter.deleteAllSearchHistoryOnNext = (bool? state) {
      print("search: success deleteAllSearchHistory $state");
      refreshUI();
    };

    _presenter.deleteAllSearchHistoryOnComplete = () {
      print("search: completed deleteAllSearchHistory");
      _presenter
          .onGetSearchHistory(GetSearchHistoryDBRequest(_userData.workspace));
    };

    _presenter.deleteAllSearchHistoryOnError = (e) {
      print("search: error deleteAllSearchHistory $e");
    };
  }

  void joinLobbyRoom(Room room) async {
    var result = await Navigator.pushNamed(
      context,
      Pages.lobbyRoom,
      arguments: LobbyRoomArgs(room),
    );
    String? pages = result as String?;
    if (pages != null) _eventBus.fire(UpdateScreen(pages));
    _isJoining = false;
  }

  @override
  void load() {
    _presenter.onGetRooms(GetRoomsApiRequest());
    _presenter
        .onGetSearchHistory(GetSearchHistoryDBRequest(_userData.workspace));
    _focusNodeSearch.addListener(onFocusChange);
    _initStream();
  }

  void _getData({bool reset = false}) {
    if ((_filterValue.isEmpty || _filterValue == "Room") &&
        !_isPaginating &&
        !(_authoredBy.isNotEmpty ||
            _subscribedBy.isNotEmpty ||
            _statuses.isNotEmpty)) {
      _searchResults.addAll(
        _rooms
            .where((element) =>
                element.name!.toLowerCase().contains(_keyword.toLowerCase()))
            .toList(),
      );
      _roomsSearchFinished = true;
    }
    if ((_filterValue.isEmpty || _filterValue == "User") &&
        !(_authoredBy.isNotEmpty ||
            _subscribedBy.isNotEmpty ||
            _statuses.isNotEmpty)) {
      _presenter.onGetUsers(GetUsersApiRequest(
        nameLike: _keyword,
        limit: _userLimit,
        after: reset ? "" : _userAfter,
      ));
    }
    if (_filterValue.isEmpty || _filterValue == "Tugas") {
      _presenter.onGetTickets(GetTicketsApiRequest(
        query: _keyword,
        limit: _ticketLimit,
        after: reset ? "" : _ticketAfter,
        queryKey: GetTicketsApiRequest.QUERY_ALL,
        subscribers: _subscribedBy,
        authors: _authoredBy,
        statuses: _statuses,
      ));
    }
    if ((_filterValue.isEmpty || _filterValue == "Event") &&
        _statuses.isEmpty) {
      _presenter.onGetEvents(GetEventsApiRequest(
        hostPHIDs: _authoredBy,
        invitedPHIDs: _subscribedBy,
        query: _keyword,
        limit: _eventLimit,
        after: _eventAfter,
      ));
    }
    if (_filterValue.isEmpty || _filterValue == "Project") {
      _presenter.onGetProjects(
        GetProjectsApiRequest(
          limit: _projectLimit,
          after: reset ? "" : _projectAfter,
          nameLike: _keyword,
          queryKey: GetProjectsApiRequest.QUERY_ALL,
        ),
      );
    }
    _presenter
        .onGetSearchHistory(GetSearchHistoryDBRequest(_userData.workspace));
  }

  void _initStream() {
    listScrollController.addListener(searchScrollListener);
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _keyword = s.toLowerCase();
      finishSearch(false);
      _searchResults.clear();
      _presenter.onAddSearchHistory(
        AddSearchHistoryDBRequest(
          SearchHistory(
            s,
            _filterValue,
            _userData.workspace,
          ),
        ),
      );
      _searchResults.clear();
      _getData(reset: true);
      refreshUI();
    });
  }

  void searchScrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      _isPaginating = true;
      _getData();
    }
  }

  void joinRoom(Room? room) {
    if (room != null && _isJoining == false) {
      _isJoining = true;
      _presenter.onJoinLobbyChannel(JoinLobbyChannelApiRequest(room.id), room);
    }
  }

  void searchFromHistory(SearchHistory history) {
    setFilterValue(history.filterType);
    _searchController.text = history.keyword;
    _keyword = history.keyword;
    _isSearch = true;
    _isPaginating = false;
    finishSearch(false);
    _getData(reset: true);
    refreshUI();
  }

  void searchFromQuery(Query query) {
    setFilterValue(query.documentType);
    _searchController.text = query.keyword.isEmpty ? " " : query.keyword;
    _authoredBy.clear();
    query.authoredBy.forEach((element) {
      _authoredBy.add(element.id);
    });
    query.subscribedBy.forEach((element) {
      _subscribedBy.add(element.id);
    });
    if (query.documentStatus.isNotEmpty) {
      if (query.documentStatus == "Open") {
        _statuses = ['open'];
      } else {
        _statuses = ['resolved', 'wontfix', 'invalid', 'duplicate'];
      }
    }
    _keyword = query.keyword;
    _isSearch = true;
    _isPaginating = false;
    finishSearch(false);
    _isQuerySearch = true;
    _getData(reset: true);
    refreshUI();
  }

  void setFilterValue(String thisValue) {
    _filterValue = thisValue;
    finishSearch(true);
  }

  void clearSearch() {
    _filterValue = "";
    _searchController.text = "";
    _ticketAfter = "";
    _projectAfter = "";
    _userAfter = "";
    _isPaginating = false;
    _isQuerySearch = false;
    _authoredBy.clear();
    _subscribedBy.clear();
    _searchResults.clear();
    _statuses.clear();
    onSearch(false);
    refreshUI();
    _searchHistory.removeWhere((h) => h.keyword == " ");
  }

  void onSearch(bool isSearching) {
    _isSearch = isSearching;

    if (_isSearch) {
      _focusNodeSearch.requestFocus();
    } else {
      _focusNodeSearch.unfocus();
      _searchController.clear();
    }
    refreshUI();
  }

  finishSearch(bool isLoading) {
    _roomsSearchFinished = isLoading;
    _usersSearchFinished = isLoading;
    _eventsSearchFinished = isLoading;
    _ticketsSearchFinished = isLoading;
    _projectsSearchFinished = isLoading;
    refreshUI();
  }

  bool isFinishedLoading() {
    if (_filterValue.isEmpty) {
      if ((_authoredBy.isNotEmpty || _subscribedBy.isNotEmpty))
        return _ticketsSearchFinished && _eventsSearchFinished;
      else if (_statuses.isNotEmpty)
        return _ticketsSearchFinished;
      else
        return _roomsSearchFinished &&
            _usersSearchFinished &&
            _eventsSearchFinished &&
            _ticketsSearchFinished &&
            _projectsSearchFinished;
    } else {
      if (_filterValue == "Room") {
        _isPaginating = false;
        return _roomsSearchFinished;
      } else if (_filterValue == "User")
        return _usersSearchFinished;
      else if (_filterValue == "Tugas")
        return _ticketsSearchFinished;
      else if (_filterValue == "Event") {
        _isPaginating = false;
        return _eventsSearchFinished;
      } else if (_filterValue == "Project") {
        _isPaginating = false;
        return _projectsSearchFinished;
      } else
        return false;
    }
  }

  void onDeleteHistory(SearchHistory history) {
    _presenter.onDeleteSearchHistory(DeleteSearchHistoryDBRequest(history));
  }

  void onDeleteAllHistory() {
    _presenter.onDeleteAllSearchHistory(
        DeleteAllSearchHistoryDBRequest(_userData.workspace));
  }

  Future<void> goToAdvanced() async {
    clearSearch();
    var result = await Navigator.pushNamed(
      context,
      Pages.advancedSearch,
    );

    if (result != null) {
      searchFromQuery(result as Query);
    }
  }

  void onFocusChange() {
    if (_focusNodeSearch.hasFocus) {
      // Hide sticker when keyboard appear
    }
  }

  void goToDetailProject(PhObject project) {
    if (project is Project) {
      Navigator.pushNamed(
        context,
        Pages.projectDetail,
        arguments: DetailProjectArgs(
          phid: project.id,
        ),
      );
    }
  }

  void goToTicketDetail(Ticket ticket) {
    Navigator.pushNamed(
      context,
      Pages.ticketDetail,
      arguments: DetailTicketArgs(phid: ticket.id, id: ticket.intId),
    );
  }

  void goToProfile(User user) {
    Navigator.pushNamed(context, Pages.profile,
        arguments: ProfileArgs(user: user));
  }

  @override
  void disposing() {
    _streamController.close();
    _presenter.dispose();
  }

  void goToDetailEvent(PhObject object) {
    Navigator.pushNamed(
      context,
      Pages.eventDetail,
      arguments: DetailEventArgs(phid: object.id),
    );
  }
}
