import 'dart:async';
import 'dart:convert';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/events/notification.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/events/setting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/app/ui/pages/create/daily_task_form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/add_action/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/always_disable_focus_node.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/args.dart';
import 'package:mobile_sev2/app/ui/pages/member/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/status/args.dart';
import 'package:mobile_sev2/app/ui/pages/status/view.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/flag/create_flag_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/delete_flag_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/get_flags_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_room_hq_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/join_lobby_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/join_lobby_channel_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/restore_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/update_status_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/db/chat/get_messages_db_request.dart';
import 'package:mobile_sev2/data/payload/db/chat/send_message_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_lobby_rooms_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/store_list_user_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/create_room_db_request.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/country.dart';
import 'package:mobile_sev2/domain/flag.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stream_transform/stream_transform.dart';

class LobbyController extends BaseController {
  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _streamController = StreamController();
  final PageController _pageController = PageController(initialPage: 0);
  late final PageController _pageController2 = PageController(
    initialPage: currentPage,
    keepPage: true,
  );

  final FocusNode _focusNodeSearch = AlwaysDisabledFocusNode();
  final Widget _statusPage = StatusPage();
  WebSocketDashboardClient _socket;

  LobbyPresenter _presenter;
  UserData _userData;
  EventBus _eventBus;
  DateUtilInterface _dateUtil;
  late User _user; // the user himself

  List<Room> _rooms = [];
  List<Room> _fRooms = [];
  List<Flag> _flags = [];

  List<User> _lobbyParticipants = [];

  // List Tickets
  List<Ticket> _userTickets = [];
  List<Ticket> _userTicketsAll = [];
  List<Ticket> _userTicketsUnbreak = [];
  List<Ticket> _userTicketsHigh = [];
  List<Ticket> _userTicketsNormal = [];
  List<Ticket> get userTickets => _userTickets;
  List<Ticket> get userTicketsAll => _userTicketsAll;
  List<Ticket> get userTicketsUnbreak => _userTicketsUnbreak;
  List<Ticket> get userTicketsHigh => _userTicketsHigh;
  List<Ticket> get userTicketsNormal => _userTicketsNormal;

  int ticketLimit = 3;

  // for participants
  int limit = 100;
  int _availableUsers = 0;
  int _unavailableUsers = 0;
  int _currentPage = 0;
  int _loadedMessages = 0;
  bool _isLobbyParticipantsLoading = false;
  bool _isOutstandingTicketLoading = false;

  Room? roomHQ;
  Room? previousRoom;
  bool _isSearch = false;
  bool _haveInvitation = false;
  bool _searchFoundInHQ = false;
  RoomsFilterType _roomsFilterType = RoomsFilterType.Active;

  List<String> openProjectName = [];
  List<String> openTicketCount = [];

  bool isJoining = false;

  // for ip Daily task
  bool _isBookChecked = false;
  bool _isFeedbackChecked = false;
  bool _isSharingChecked = false;

  List<ActionItemDailyIpTask> get actionItemDailyIpTasks {
    return [
      ActionItemDailyIpTask(
        S.of(context).label_daily_summary,
        () => goToIpDailyTaskForm(
          DailyTaskType.book,
        ),
        isBookChecked,
      ),
      ActionItemDailyIpTask(
        S.of(context).label_daily_feedback_pairing,
        () => goToIpDailyTaskForm(DailyTaskType.feedback),
        isFeedbackChecked,
      ),
      ActionItemDailyIpTask(
        S.of(context).label_daily_sharing_pairing,
        () => goToIpDailyTaskForm(DailyTaskType.sharing),
        isSharingChecked,
      ),
    ];
  }

  List<Country> _countries = [];
  List<Country> get countries => _countries;

  bool get isBookChecked => _isBookChecked;
  bool get isFeedbackChecked => _isFeedbackChecked;
  bool get isSharingChecked => _isSharingChecked;

  // final DateTime now = DateTime.now();
  String formattedDate = DateFormat('EEE d MMM').format(DateTime.now());

  bool get isLobbyParticipantsLoading => _isLobbyParticipantsLoading;

  bool get isOutstandingTicketLoading => _isOutstandingTicketLoading;

  bool get isSearch => _isSearch;

  UserData get userData => _userData;

  DateUtilInterface get dateUtil => _dateUtil;

  User get user => _user;

  List<Room> get rooms => _rooms;

  int get availableUsers => _availableUsers;

  int get unavailableUsers => _unavailableUsers;

  Widget get statusPage => _statusPage;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  TextEditingController get searchController => _searchController;

  StreamController<String> get streamController => _streamController;

  PageController get pageController => _pageController;

  PageController get pageController2 => _pageController2;

  bool get haveInvitation => _haveInvitation;

  bool get searchFoundInHQ => _searchFoundInHQ;

  RoomsFilterType get roomsFilterType => _roomsFilterType;

  String get roomResults => _rooms.map((e) => e.name).join(", ");

  int get currentPage => _currentPage;

  LobbyController(
    this._presenter,
    this._userData,
    this._socket,
    this._eventBus,
    this._dateUtil,
  ) {
    _user = _userData.toUser();
  }

  @override
  void load() {
    getCountries();
    _getProfile();
    _presenter.onGetLobbyRooms(GetLobbyRoomsDBRequest(_userData.workspace));
    _presenter.onGetRoomHQ(GetRoomHQApiRequest());
    // _presenter.onGetRooms(GetRoomsApiRequest());
    _presenter.onGetLobbyRooms(GetLobbyRoomsApiRequest());
    _getBookmarkedRoom();
    getLobbyParticipants();
    _presenter.onJoinLobby(JoinLobbyApiRequest());
    _focusNodeSearch.addListener(onFocusChange);
    _initStream();
    _getTickets();
  }

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowCaseWidget.of(context).startShowCase(_getShowcaseKey());
    });
  }

  List<GlobalKey> _getShowcaseKey() {
    List<GlobalKey> _showcaseKey = [];
    if (!_userData.workspaceTooltipFinished) _showcaseKey.add(seven);
    if (!_userData.lobbyTooltipFinished) _showcaseKey.addAll([one, two]);
    return _showcaseKey;
  }

  void _initStream() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _rooms = _fRooms
          .where((ft) =>
              ft.participants!
                  .where((p) =>
                      p.fullName!.toLowerCase().contains(s.toLowerCase()))
                  .isNotEmpty ||
              ft.name!.toLowerCase().contains(s.toLowerCase()))
          .toList();

      _searchFoundInHQ = false;
      if (roomHQ != null &&
              roomHQ!.name!.toLowerCase().contains(s.toLowerCase()) ||
          roomHQ!.participants!
              .where(
                  (pq) => pq.fullName!.toLowerCase().contains(s.toLowerCase()))
              .isNotEmpty) {
        _searchFoundInHQ = true;
      }
      refreshUI();
    });
  }

  void onFocusChange() {
    if (_focusNodeSearch.hasFocus) {
      // Hide sticker when keyboard appear
    } else if (_searchController.text.isEmpty) {
      onSearch(false);
    }
  }

  void clearSearch() {
    _searchController.text = "";
    onSearch(false);
    filter(_roomsFilterType);
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

  void goToSearch() {
    Navigator.pushNamed(context, Pages.basicSearch);
  }

  void _getTickets() {
    _isOutstandingTicketLoading = true;
    _presenter.onGetTickets(
      GetTicketsApiRequest(
        assigned: [_user.id],
        limit: ticketLimit,
        queryKey: GetTicketsApiRequest.QUERY_OPEN,
      ),
    );
  }

  void filterTicketOutstanding(String priority) {
    switch (priority) {
      case Ticket.STATUS_UNBREAK:
        _userTickets = _userTicketsUnbreak;
        break;
      case Ticket.STATUS_HIGH:
        _userTickets = _userTicketsHigh;
        break;
      case Ticket.STATUS_NORMAL:
        _userTickets = _userTicketsNormal;
        break;
      default:
        _userTickets = _userTicketsAll;
    }
    refreshUI();
  }

  void goToTicketDetail(Ticket ticket) {
    Navigator.pushNamed(
      context,
      Pages.ticketDetail,
      arguments: DetailTicketArgs(phid: ticket.id),
    );
  }

  void goToIpDailyTaskForm(DailyTaskType dailyTaskType) async {
    await Navigator.pushNamed(context, Pages.dailyTaskForm,
            arguments: DailyTaskFormArgs(
                dailyTaskType: dailyTaskType,
                isBookChecked: _isBookChecked,
                isFeedbackChecked: _isFeedbackChecked,
                isSharingChecked: _isSharingChecked))
        .then((value) {
      if (value != null) {
        var values = value as List;
        _isBookChecked = values.first as bool;
        _isFeedbackChecked = values[1] as bool;
        _isSharingChecked = values.last as bool;
        refreshUI();
      }
    });
  }

  void filter(RoomsFilterType filterType) {
    _roomsFilterType = filterType;
    if (filterType == RoomsFilterType.All) {
      _rooms = _fRooms;
    } else if (filterType == RoomsFilterType.Favorite) {
      _rooms = _fRooms.where((element) => isBookmarked(element)).toList();
    } else if (filterType == RoomsFilterType.Active) {
      _rooms = _fRooms.where((element) {
        if (element.participants == null) {
          return false;
        } else if (element.participants!.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      }).toList();
    } else if (filterType == RoomsFilterType.Joined) {
      _rooms = _fRooms.where((element) {
        return element.isJoinable ?? false;
      }).toList();
    } else if (filterType == RoomsFilterType.Archive) {
      _rooms = _fRooms.where((element) => element.isDeleted == true).toList();
    }
    refreshUI();
  }

  void joinRoom(Room? room) {
    showOnLoading(context, S.of(context).label_connect_room_chat);
    if (room != null && !isJoining) {
      isJoining = true;
      _presenter.onJoinLobbyChannel(JoinLobbyChannelApiRequest(room.id), room);
    }
  }

  void goToNotification() {
    Navigator.pushNamed(context, Pages.notifications);
  }

  void goToMainCalendar() {
    Navigator.pushNamed(context, Pages.mainCalendar);
  }

  void goToMember() {
    Navigator.pushNamed(context, Pages.member,
        arguments: MemberArgs(_userData.workspace));
  }

  void goToStatus() {
    Navigator.pushNamed(
      context,
      Pages.status,
      arguments: StatusArgs(newPage: true),
    ).then((value) => _getProfile());
  }

  void _getProfile() {
    _presenter.onGetProfile(GetProfileApiRequest());
  }

  //goToForm
  void goToForm(FormType type, {Room? room}) {
    Navigator.pushNamed(
      context,
      Pages.createRoomForm,
      arguments: CreateRoomArgs(
        type: type,
        room: room,
      ),
    );
  }

  void goToWorkspaceList() {
    if (!isLoading) Navigator.pushNamed(context, Pages.workspaceList);
  }

  // go To Project
  void moveToProject() {
    Navigator.pushNamed(context, Pages.project);
  }

  String getCurrentTask() {
    if (_user.status == "In Lobby") {
      if (!_user.currentTask.isNullOrBlank()) {
        return _user.currentTask!.length > 13
            ? '${_user.currentTask!.substring(0, 11)}...'
            : _user.currentTask!;
      }

      return '';
    }

    return _user.status ?? '';
  }

  bool canJoinRoom(Room room) {
    return room.isJoinable ?? false;
  }

  int startDate() {
    DateTime dateNow = _dateUtil.now();
    int ms = _dateUtil
        .from(dateNow.year, dateNow.month, dateNow.day)
        .millisecondsSinceEpoch;
    return (ms / 1000).round();
  }

  bool isTimeToShow() {
    DateTime dateNow = _dateUtil.now();
    bool _isAfter = _dateUtil.now().isAfter(
          _dateUtil.from(
            dateNow.year,
            dateNow.month,
            dateNow.day,
            15,
            30,
          ),
        );

    bool _isWeekend = _dateUtil.now().weekday == DateTime.saturday ||
        _dateUtil.now().weekday == DateTime.sunday;

    bool timeToShow = _isAfter && !_isWeekend;

    return timeToShow;
  }

  @override
  void getArgs() {}

  @override
  void initListeners() {
    _socket.streamController?.stream.listen((message) {
      print("dashboardwebsocket onMessage: $message");
      var msg = jsonDecode(message);
      switch (msg['type']) {
        case STATE_TYPE:
          // reload();
          _presenter.onGetRoomHQ(GetRoomHQApiRequest());
          break;
        default:
          break;
      }
    });

    _eventBus.on<NotificationEvent>().listen((event) {
      if (event.type == NotificationType.chat) {
        if (_rooms.indexWhere((element) => element.id == event.objectId) > -1) {
          _loadedMessages--;
          _presenter.onGetMessages(
              GetMessagesApiRequest(roomId: event.objectId, limit: 6));
        }
      }
    });
    _eventBus.on<RefreshList>().listen((_) {
      load();
    });

    _eventBus.on<WorkTaskUpdated>().listen((event) {
      if (event.taskName != null) {
        _user.currentTask = event.taskName;
      }
      if (event.workStatus != null) {
        _user.status = event.workStatus;
      }
      refreshUI();
    });

    _presenter.createRoomOnNext = (BaseApiResponse resp, PersistenceType type) {
      print("lobby: success createRoom $type");
    };

    _presenter.createRoomOnComplete = (PersistenceType type) {
      print("lobby: completed createRoom $type");
    };

    _presenter.createRoomOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: error createRoom $e $type");
    };

    _presenter.getRoomHQOnNext = (Room room, PersistenceType type) {
      print("lobby: success getRoomHQ $type");
      roomHQ = room;
      _presenter.onGetMessages(GetMessagesDBRequest(room.id), from: "hq");
      _presenter.onGetMessages(GetMessagesApiRequest(roomId: room.id, limit: 6),
          from: "hq");
    };

    _presenter.getRoomHQOnComplete = (PersistenceType type) {
      print("lobby: completed getRoomHQ $type");
    };

    _presenter.getRoomHQOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: error getRoomHQ $e $type");
      // loading(false); //get error when HQ room is empty, so nothing to show
      // reloading(false);
    };

    _presenter.getLobbyRoomsOnNext = (List<Room> rooms, PersistenceType type) {
      print("lobby: success getLobbyRooms $type ${rooms.length}");
      if (type == PersistenceType.db) {
        _rooms = rooms
            .where((element) => element.participants?.length != 2)
            .toList();
      } else {
        _fRooms.clear();
        _fRooms.addAll(rooms.where((element) {
          if (element.isGroup)
            return true;
          else
            return false;
        }));
        previousRoom = _getPreviousRoom();
      }
    };

    _presenter.getLobbyRoomsOnComplete = (PersistenceType type) {
      print("lobby: completed getLobbyRooms $type");
      // _rooms = _fRooms;
      if (type == PersistenceType.db) {
        if (_rooms.isNotEmpty) loading(false);
      } else {
        if (_fRooms.isNotEmpty) {
          filter(_roomsFilterType);
          _fRooms.forEach((element) {
            _presenter.onGetMessages(GetMessagesDBRequest(element.id));
            _presenter.onGetMessages(
                GetMessagesApiRequest(roomId: element.id, limit: 6));
          });
        } else {
          loading(false);
          reloading(false);
          if (!_userData.lobbyTooltipFinished ||
              !_userData.workspaceTooltipFinished) startShowCase();
        }

        _presenter.onGetLobbyParticipants(
            GetLobbyParticipantsApiRequest(ownerIds: [_userData.id]));
      }
    };

    _presenter.getLobbyRoomsOnError = (e, PersistenceType type) {
      print("lobby: error getLobbyRooms $e $type");
      loading(false);
      reloading(false);
    };

    _presenter.getLobbyParticipantsOnNext =
        (List<User> users, PersistenceType type) {
      print("lobby: success getLobbyParticipants $type");

      _populateUsers(users);
    };

    _presenter.storeListUserToDbOnNext = (bool result, PersistenceType type) {
      print("lobby: success store list user $type, $result");
    };

    _presenter.storeListUserToDbOnComplete = (PersistenceType type) {
      print("lobby: completed store list user $type");
    };

    _presenter.storeListUserToDbOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: error store list user $e $type");
    };

    _presenter.getLobbyParticipantsOnComplete = (PersistenceType type) {
      print("lobby: completed getLobbyParticipants $type");

      refreshUI();
    };

    _presenter.getLobbyParticipantsOnError = (e, PersistenceType type) {
      _isLobbyParticipantsLoading = false;
      loading(false);
      print("lobby: error getLobbyParticipants $e $type");
    };

    _presenter.joinLobbyOnNext = (bool result, PersistenceType type) {
      print("lobby: success joinLobby $type");
    };

    _presenter.joinLobbyOnComplete = (PersistenceType type) {
      print("lobby: completed joinLobby $type");
    };

    _presenter.joinLobbyOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: error joinLobby $e $type");
    };

    _presenter.joinLobbyChannelOnNext = (bool result, PersistenceType type) {
      print("lobby: success joinLobbyChannel $type");
      refreshUI();
    };

    _presenter.joinLobbyChannelOnComplete = (PersistenceType type, Room room) {
      print("lobby: completed joinLobbyChannel $type");
      _joinLobbyRoom(room);
    };

    _presenter.joinLobbyChannelOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: error joinLobbyChannel $e $type");
    };

    // get messages
    _presenter.getMessagesOnNext =
        (List<Chat> messages, PersistenceType type, String from) {
      print("lobby: success getMessages $type");
      if (type == PersistenceType.db) {
        if (messages.isNotEmpty) {
          var idx = _fRooms.indexWhere((e) => e.id == messages.first.roomId);
          if (idx > -1) {
            _fRooms[idx].chats = messages;
          } else if (from == "hq") {
            roomHQ?.chats = messages;
          }
          refreshUI();
        }
      } else {
        var idx = _fRooms.indexWhere((e) => e.id == messages.first.roomId);
        if (idx > -1) {
          if (_fRooms[idx].chats != null) {
            var chatIdx = messages
                .indexWhere((chat) => chat.id == _fRooms[idx].chats?.first.id);
            _fRooms[idx].unreadChats = chatIdx < 0 ? 6 : chatIdx;
          } else {
            _presenter.onSendDBMessage(SendMessageDBRequest(messages.first));
          }
          _loadedMessages++;
          _presenter.onCreateRoom(CreateRoomDBRequest(_fRooms[idx]));
        } else if (from == "hq") {
          if (roomHQ?.chats != null) {
            var chatIdx = messages
                .indexWhere((chat) => chat.id == roomHQ?.chats?.first.id);
            roomHQ?.unreadChats = chatIdx < 0 ? 6 : chatIdx;
          } else {
            _presenter.onSendDBMessage(SendMessageDBRequest(messages.first));
          }
        }
        refreshUI();
      }
    };

    _presenter.getMessagesOnComplete = (PersistenceType type, String from) {
      print("lobby: completed getMessages $type");
      if (_loadedMessages == _fRooms.length && from != "hq") {
        loading(false);
        reloading(false);
        if (!_userData.lobbyTooltipFinished ||
            !_userData.workspaceTooltipFinished) startShowCase();
      }
    };

    _presenter.getMessagesOnError = (e, PersistenceType type, String from) {
      print("lobby: error getMessages $e $type");
      loading(false);
    };

    // send message
    _presenter.sendMessageOnNext = (bool result, PersistenceType type) {
      print("lobby: success sendMessage $type");
    };

    _presenter.sendMessageOnComplete = (PersistenceType type) {
      print("lobby: completed sendMessage $type");
    };

    _presenter.sendMessageOnError = (e, PersistenceType type) {
      print("lobby: error sendMessage $e $type");
      loading(false);
    };

// restore room
    _presenter.restoreRoomOnNext = (bool result, PersistenceType type) {
      print("restore: success restoreRoom $result");
      load();
      _roomsFilterType = RoomsFilterType.Active;
    };

    _presenter.restoreRoomOnComplete = (PersistenceType type) {
      load();
      print("restore: completed restoreRoom $type");
    };

    _presenter.restoreRoomOnError = (e, PersistenceType type) {
      loading(false);
      print("restore: error restoreRoom $e $type");
    };

    // get flags
    _presenter.getFlagsOnNext = (List<Flag> result, PersistenceType type) {
      print("lobby: success getFlags $type");
      _flags.clear();
      _flags.addAll(result);
      if (_roomsFilterType == RoomsFilterType.Favorite) {
        filter(RoomsFilterType.Favorite);
      }
      refreshUI();
    };

    _presenter.getFlagsOnComplete = (PersistenceType type) {
      print("lobby: completed getFlags $type");
    };

    _presenter.getFlagsOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: error getFlags $e $type");
    };

    // create flag
    _presenter.createFlagOnNext = (bool result, PersistenceType type) {
      print("lobby: success createFlag $type");
    };

    _presenter.createFlagOnComplete = (PersistenceType type) {
      print("lobby: completed createFlag $type");
      _getBookmarkedRoom();
    };

    _presenter.createFlagOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: error createFlag $e $type");
    };

    // delete flag
    _presenter.deleteFlagOnNext = (bool result, PersistenceType type) {
      print("lobby: success deleteFlag $type");
    };

    _presenter.deleteFlagOnComplete = (PersistenceType type) {
      print("lobby: completed deleteFlag $type");
      _getBookmarkedRoom();
    };

    _presenter.deleteFlagOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: error deleteFlag $e $type");
    };

    _presenter.getTicketsOnNext = (List<Ticket> tickets, PersistenceType type) {
      print("lobby: success getTickets $type ${tickets.length}");
      _userTickets.addAll(tickets);
      _userTicketsAll.addAll(tickets);
      tickets.forEach((t) {
        switch (t.priority) {
          case Ticket.STATUS_UNBREAK:
            _userTicketsUnbreak.add(t);
            break;
          case Ticket.STATUS_HIGH:
            _userTicketsHigh.add(t);
            break;
          case Ticket.STATUS_NORMAL:
            _userTicketsNormal.add(t);
            break;
          default:
        }
      });
      refreshUI();
    };

    _presenter.getTicketsOnComplete = (PersistenceType type) {
      print("lobby: completed getTickets $type");
      _isOutstandingTicketLoading = false;
      refreshUI();
    };

    _presenter.getTicketsOnError = (e, PersistenceType type) {
      loading(false);
      print("lobby: ERROR getTickets $e $type");
    };

    // get profile
    _presenter.getProfileOnNext = (User user, PersistenceType type) {
      _user.currentTask = user.currentTask;
      _user.status = user.status;

      print("profile: success getProfile $type");
    };

    _presenter.getProfileOnComplete = (PersistenceType type) {
      print("profile: completed getProfile $type");
    };

    _presenter.getProfileOnError = (e, PersistenceType type) {
      loading(false);
      print("profile: error getProfile $e $type");
    };

    _presenter.getCountriesOnNext = (List<Country>? countries) {
      if (countries != null) _countries.addAll(countries);
      print("lobby: success getCountries");
    };

    _presenter.getCountriesOnComplete = () {
      print("lobby: complete getCountries");
    };

    _presenter.getCountriesOnError = (e) {
      print("lobby: error getCountries $e");
    };
  }

  void _joinLobbyRoom(Room room) async {
    Navigator.pop(context);
    var result = await Navigator.pushNamed(
      context,
      Pages.lobbyRoom,
      arguments: LobbyRoomArgs(room),
    );
    previousRoom = room;
    _presenter.onJoinLobby(JoinLobbyApiRequest());
    _loadedMessages--;
    // getLobbyParticipants();
    _presenter.onGetMessages(GetMessagesDBRequest(room.id));
    _presenter.onGetMessages(GetMessagesApiRequest(roomId: room.id, limit: 6));
    String? pages = result as String?;
    if (pages != null) _eventBus.fire(UpdateScreen(pages));
    isJoining = false;
    refreshUI();
  }

  @override
  Future<void> reload({String? type}) async {
    reloading(true);
    _getProfile();
    getLobbyParticipants();
    _getBookmarkedRoom();
    _presenter.onGetRoomHQ(GetRoomHQApiRequest());
    _presenter.onGetLobbyRooms(GetLobbyRoomsApiRequest());
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
    _pageController.dispose();
    _pageController2.dispose();
  }

  void getLobbyParticipants({String? after}) {
    if (!_isLobbyParticipantsLoading || after != null) {
      if (after == null) {
        _availableUsers = 0;
        _unavailableUsers = 0;
      }
      _isLobbyParticipantsLoading = true;
      _presenter.onGetLobbyParticipants(
        GetLobbyParticipantsApiRequest(
          after: after,
          queryKey: GetLobbyParticipantsApiRequest.QUERY_ALL,
        ),
      );
    }
  }

  void restoreRoom(String roomId) {
    print("roomId : $roomId");
    _presenter.onRestoreRoom(RestoreRoomApiRequesst(roomId));
  }

  bool isBookmarked(Room room) {
    num idx = _flags.indexWhere((element) => element.objectPHID == room.id);
    return idx >= 0;
  }

  void _getBookmarkedRoom() {
    _presenter.onGetFlags(
      GetFlagsApiRequest(
        types: ['CONP'],
      ),
    );
  }

  void addBookmark(Room room) {
    _presenter.onCreateFlag(CreateFlagApiRequest(objectPHID: room.id));
  }

  void reportRoom(Room room) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments: ReportArgs(phId: room.id, reportedType: "ROOM"),
          );
        });
  }

  void removeBookmark(Room room) {
    _presenter.onDeleteFlag(DeleteFlagApiRequest(objectPHID: room.id));
  }

  void _populateUsers(List<User> users) {
    users.forEach((u) {
      if ((u.status == UpdateStatusApiRequest.STATUS_IN_LOBBY ||
              u.status == UpdateStatusApiRequest.STATUS_IN_CHANNEL) &&
          u.isWorking == true) {
        _availableUsers++;
      } else {
        _unavailableUsers++;
      }
    });
    _lobbyParticipants.addAll(users);
    if (users.length == limit) {
      getLobbyParticipants(after: users.last.intId.toString());
    } else {
      AppComponent.getInjector()
          .get<List<User>>(dependencyName: 'user_list')
          .clear();
      AppComponent.getInjector()
          .get<List<User>>(dependencyName: 'user_list')
          .addAll(_lobbyParticipants);
      Map<String, User> newListUsers = {};
      _lobbyParticipants.forEach((e) {
        newListUsers[e.name ?? ""] = e;
      });
      _presenter.onStoreListUserDb(StoreUserListDbRequest(newListUsers));
      _eventBus.fire(RefreshUserList());
      _lobbyParticipants.clear();
      _isLobbyParticipantsLoading = false;
      refreshUI();
    }
  }

  Room? _getPreviousRoom() {
    int idx = _fRooms.indexWhere((room) => room.id == _userData.currentChannel);
    if (idx > -1) {
      return _fRooms[idx];
    }
  }

  void gotoPorjectTab() {
    _eventBus.fire(UpdateScreen(Pages.project));
  }

  void onCheckDailyIp(bool val, DailyTaskType dailyTaskType) {
    switch (dailyTaskType) {
      case DailyTaskType.book:
        _isBookChecked = val;
        break;
      case DailyTaskType.feedback:
        _isFeedbackChecked = val;
        break;
      case DailyTaskType.sharing:
        _isSharingChecked = val;
        break;
      default:
    }
    refreshUI();
  }

  void changePage(int page) {
    _currentPage = page;
    _pageController2.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    refreshUI();
  }

  void getCountries() {
    _presenter.onGetCountries({});
  }
}

enum RoomsFilterType { All, Joined, Active, Archive, Favorite }

class ActionItemDailyIpTask {
  final String title;
  final Function() onPressed;
  final bool value;

  ActionItemDailyIpTask(this.title, this.onPressed, this.value);
}
