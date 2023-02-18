import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sev2/app/infrastructures/events/setting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/status/args.dart';
import 'package:mobile_sev2/app/ui/pages/status/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/api/lobby/update_status_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/work_on_task_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/db/setting/get_setting_db_request.dart';
import 'package:mobile_sev2/data/payload/db/setting/update_setting_db_request.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';
import 'package:mobile_sev2/domain/meta/status_history.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stream_transform/stream_transform.dart';

class StatusController extends SheetController {
  final TextEditingController _adhocTaskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _streamController = StreamController();
  final FocusNode _focusNodeSearch = FocusNode();

  StatusArgs? _data;

  StatusPresenter _presenter;
  UserData _userData;
  Box<StatusHistory> _shBox;
  DateUtilInterface _dateUtil;
  User? _user;
  EventBus _eventBus;
  List<Ticket> _rTickets = [];
  List<Ticket> _tickets = [];
  Setting? _setting;

  bool _isIdle = false;
  bool _isInactive = false;
  IconData _statusIcon = FontAwesomeIcons.rotate;
  bool isLoadingTicket = false;

  bool _isOnStatusChanged = false;
  bool _isFromTask = false;
  bool _isSearch = false;

  int _selectedChip = 0; // default 0 : assigned to me
  String _selectedTask = "";
  List<String> _chipOptions = [];
  List<StatusHistory> _recentStatuses = [];

  // getter
  bool get isNewPage => _data?.newPage ?? false;

  bool get isIdle => _isIdle;

  bool get isInactive => _isInactive;

  bool get isSearch => _isSearch;

  int get selectedChip => _selectedChip;

  String get selectedTask => _selectedTask;

  List<String> get chipOptions => _chipOptions;

  IconData get statusIcon => _statusIcon;

  User? get user => _user;

  List<Ticket> get tickets => _tickets;

  List<StatusHistory> get recentStatuses => _recentStatuses;

  TextEditingController get adhocTaskController => _adhocTaskController;

  TextEditingController get searchController => _searchController;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  UserData get userData => _userData;

  StreamController<String> get streamController => _streamController;

  StatusController(
    this._presenter,
    this._userData,
    this._shBox,
    this._dateUtil,
    this._eventBus,
  );

  var _ticketLimit = 10;
  var _ticketAfter = "";

  @override
  void getArgs() {
    if (args != null) _data = args as StatusArgs;
    print(_data?.toPrint());
  }

  @override
  void load() {
    // _presenter.onGetLobbyParticipants(GetLobbyParticipantsApiRequest(ownerIds: [_userData.id]));
    _presenter.onGetProfile(GetProfileApiRequest());
    _presenter.onGetSetting(GetSettingDBRequest());
    this.setScrollListener(_getTickets);
    _initStream();
    // _getHistoryStatuses();
  }

  void reloadData() {
    loading(true);
    _ticketAfter = "";
    _tickets.clear();
    _rTickets.clear();
    _chipOptions.clear();
    _isOnStatusChanged = true;
    _presenter.onGetProfile(GetProfileApiRequest());
  }

  void _initStream() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _tickets = _rTickets
          .where((t) =>
              t.name!.toLowerCase().contains(s.toLowerCase()) ||
              t.code.toLowerCase().contains(s.toLowerCase()))
          .toList();
      refresh();
    });
  }

  @override
  void initListeners() {
    _presenter.getProfileOnNext = (User user, PersistenceType type) {
      print("status: success getProfile $type");
      _user = user;
      _setStatusIcon();

      // update setting
      if (!_isFromTask && _isOnStatusChanged) {
        _setting?.currentTask = "";
        _presenter.onUpdateSetting(UpdateSettingDBRequest(_setting!));

        // save to local db
        _shBox.add(
            StatusHistory("mengubah status", getUserStatus(), _dateUtil.now()));
      }

      _eventBus.fire(WorkTaskUpdated(workStatus: _user?.status));

      // TEMPORARY DISABLE
      // _getHistoryStatuses(); // refresh
      _isOnStatusChanged = false;
      _isFromTask = false;
    };

    _presenter.getProfileOnComplete = (PersistenceType type) {
      print("status: completed getProfile $type");
      _getTickets();

      _chipOptions.addAll([
        S.of(context).status_task_assigned_to_me,
        S.of(context).status_task_created_by_me,
        S.of(context).status_task_open,
        S.of(context).status_task_all,
      ]);
      loading(false);
      refresh();
      if (!_userData.statusTooltipFinished && !isNewPage) startShowCase();
    };

    _presenter.getProfileOnError = (e, PersistenceType type) {
      print("status: error getProfile $e $type");
      loading(false);
    };

    _presenter.getAvailabilityStatusOnNext =
        (List<LobbyStatus> statuses, PersistenceType type) {
      print("status: success getAvailabilityStatus $type");
      // todo, set status list based on this response
    };

    _presenter.getAvailabilityStatusOnComplete = (PersistenceType type) {
      print("status: completed getAvailabilityStatus $type");
    };

    _presenter.getAvailabilityStatusOnError = (e, PersistenceType type) {
      print("status: error getAvailabilityStatus $e $type");
    };

    _presenter.getTicketsOnNext = (List<Ticket> tickets, PersistenceType type) {
      print("status: success getTickets $type");
      _tickets.addAll(tickets);
      print("_ticketAfter : ${tickets.length}");
      if (tickets.isNotEmpty) _ticketAfter = tickets.last.intId.toString();

      _rTickets.addAll(tickets);
      isLoadingTicket = false;
      refresh();
    };

    _presenter.getTicketsOnComplete = (PersistenceType type) {
      print("status: completed getTickets $type");
    };

    _presenter.getTicketsOnError = (e, PersistenceType type) {
      print("status: error getTickets $e $type");
      loading(false);
    };

    _presenter.workOnTaskOnNext = (bool result, PersistenceType type) {
      print("status: success workOnTask $type");
    };

    _presenter.workOnTaskOnComplete = (PersistenceType type) {
      print("status: completed workOnTask $type");
      _isFromTask = true;
      _setting?.currentTask = _selectedTask;
      _presenter.onUpdateSetting(UpdateSettingDBRequest(_setting!));
      _statusIcon = FontAwesomeIcons.listCheck;
      _shBox.add(StatusHistory(
          "memulai", _selectedTask, _dateUtil.now())); // save to local db
      _eventBus.fire(WorkTaskUpdated(taskName: _selectedTask));
      reloadData();
      // save to local db
    };

    _presenter.workOnTaskOnError = (e, PersistenceType type) {
      print("status: error workOnTask $e $type");
    };

    _presenter.updateStatusOnNext = (bool result, PersistenceType type) {
      print("status: success updateStatus $type");
    };

    _presenter.updateStatusOnComplete = (PersistenceType type) {
      print("status: completed updateStatus $type");

      reloadData();
    };

    _presenter.updateStatusOnError = (e, PersistenceType type) {
      print("status: error updateStatus $e $type");
    };

    _presenter.getSettingOnNext = (Setting setting, PersistenceType type) {
      print("status: success getSetting $type");
      _setting = setting;
    };

    _presenter.getSettingOnComplete = (PersistenceType type) {
      print("status: completed getSetting $type");
      refreshUI();
    };

    _presenter.getSettingOnError = (e, PersistenceType type) {
      print("status: error getSetting $e $type");
    };

    _presenter.updateSettingOnNext = (bool result, PersistenceType type) {
      print("status: success updateSetting $type");
    };

    _presenter.updateSettingOnComplete = (PersistenceType type) {
      print("status: completed updateSetting $type");
    };

    _presenter.updateSettingOnError = (e, PersistenceType type) {
      print("status: error updateSetting $e $type");
    };
  }

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowCaseWidget.of(context).startShowCase([three, four]);
    });
  }

  void _setStatusIcon() {
    if (_user?.status == "In Lobby" || _user?.status == "") {
      _statusIcon = FontAwesomeIcons.arrowsRotate;
    } else if (_user?.status == "Not Available") {
      _statusIcon = FontAwesomeIcons.bed;
    } else if (_user?.status == "Bathroom") {
      _statusIcon = FontAwesomeIcons.bath;
    } else if (_user?.status == "Lunch") {
      _statusIcon = FontAwesomeIcons.utensils;
    } else if (_user?.status == "Me Time!") {
      _statusIcon = FontAwesomeIcons.gamepad;
    } else if (_user?.status == "Family thing") {
      _statusIcon = FontAwesomeIcons.lifeRing;
    } else if (_user?.status == "Praying") {
      _statusIcon = FontAwesomeIcons.bellSlash;
    } else if (_user?.status == "Other") {
      _statusIcon = FontAwesomeIcons.userSecret;
    } else {
      _statusIcon = FontAwesomeIcons.listCheck;
    }
  }

  void _getTickets() {
    var query = GetTicketsApiRequest.QUERY_ASSIGNED;
    switch (_selectedChip) {
      case 0:
        query = GetTicketsApiRequest.QUERY_ASSIGNED;
        break;
      case 1:
        query = GetTicketsApiRequest.QUERY_AUTHORED;
        break;
      case 2:
        query = GetTicketsApiRequest.QUERY_OPEN;
        break;
      case 3:
        query = GetTicketsApiRequest.QUERY_ALL;
        break;
      default:
        query = GetTicketsApiRequest.QUERY_ASSIGNED;
        break;
    }

    isLoadingTicket = true;
    refresh();
    _presenter.onGetTickets(GetTicketsApiRequest(
      queryKey: query,
      statuses: ['open'],
      limit: _ticketLimit,
      after: _ticketAfter,
    ));
  }

  String getUserStatus() {
    if (_user != null) {
      if (_user!.status != null) {
        if (_user!.status == "In Lobby") {
          _isIdle = false;
          return _user!.currentTask.isNullOrBlank()
              ? S.of(context).status_just_mingling_label
              : _user!.currentTask!;
        } else {
          _isIdle = true;
          return _user!.status!;
        }
      }
    }
    return S.of(context).status_just_mingling_label;
  }

  void setAdhocTask() {
    _selectedTask = _adhocTaskController.text;
    setWorkOnTask();
    Navigator.pop(context);
  }

  void setWorkOnTask() {
    // set work on task
    loading(true);

    // reset work status first
    _user?.status = UpdateStatusApiRequest.STATUS_IN_LOBBY;
    _presenter.onUpdateStatus(
        UpdateStatusApiRequest(UpdateStatusApiRequest.STATUS_IN_LOBBY));

    _presenter.onWorkOnTask(WorkOnTaskApiRequest(_selectedTask));
  }

  void setStatus(
    String status, {
    bool isIdle = false,
    bool isInactive = false,
    IconData statusIcon = FontAwesomeIcons.rotate,
  }) {
    loading(true);
    // skip if existing status is same
    if (_user?.status == status) return;
    _user?.status = status;

    // update status
    _presenter.onUpdateStatus(UpdateStatusApiRequest(status));

    // update work task
    if (status == UpdateStatusApiRequest.STATUS_IN_LOBBY) {
      _selectedTask = '';
      _presenter.onWorkOnTask(WorkOnTaskApiRequest(_selectedTask));
    }

    // refresh page
    refreshUI();
  }

  void selectChip(bool selected, int value) {
    if (_selectedChip != value) {
      _selectedChip = value;
      refresh();

      _clearTickets();
      _getTickets();
    }
  }

  void _clearTickets() {
    _tickets.clear();
    _ticketAfter = "";
  }

  void setSelectedTask(String value) {
    if (_selectedTask != value) {
      _selectedTask = value;
      refresh();
    }
  }

  void _getHistoryStatuses() {
    _recentStatuses = _shBox.values.take(25).toList();
    refreshUI();
  }

  String formatStatusDate(DateTime dt) {
    return _dateUtil.displayDateTimeFormat(dt);
  }

  @override
  void disposing() {
    super.disposing();
    _presenter.dispose();
    _streamController.close();
  }

  void clearSearch() {
    _searchController.text = "";
    onSearch(false);
    reloadData();
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
}
