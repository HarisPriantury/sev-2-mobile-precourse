import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/domain/meta/status_history.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stream_transform/stream_transform.dart';

class TaskActionController extends BaseController {
  late TaskActionArgs _data;
  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _streamController = StreamController();
  final FocusNode _focusNodeSearch = FocusNode();

  TaskActionPresenter _presenter;
  UserData _userData;
  DateUtilInterface _dateUtil;
  User? _user;
  Setting? _setting;

  bool _isIdle = false;
  bool _isInactive = false;
  bool _isSearch = false;
  IconData _statusIcon = FontAwesomeIcons.rotate;

  int _selectedChip = 0; // default 0 : assigned to me
  List<Ticket> _selectedTasks = List.empty(growable: true);
  List<Ticket> _resultTasks = [];
  List<Ticket> _searchedTasks = [];
  List<Ticket> _relatedTasks = []; //Subtask or Merged task
  List<String> _chipOptions = [];
  List<StatusHistory> _recentStatuses = [];

  // getter
  TaskActionArgs get data => _data;

  bool get isIdle => _isIdle;

  bool get isInactive => _isInactive;

  bool get isSearch => _isSearch;

  bool get isFirstRequest => _ticketAfter.isEmpty;

  int get selectedChip => _selectedChip;

  List<Ticket> get selectedTasks => _selectedTasks;

  List<Ticket> get resultTasks => _resultTasks;

  List<Ticket> get searchedTasks => _searchedTasks;

  List<Ticket> get relatedTasks => _relatedTasks;

  List<String> get chipOptions => _chipOptions;

  IconData get statusIcon => _statusIcon;

  User? get user => _user;

  List<StatusHistory> get recentStatuses => _recentStatuses;

  TextEditingController get searchController => _searchController;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  UserData get userData => _userData;

  StreamController<String> get streamController => _streamController;

  TaskActionController(this._presenter, this._userData, this._dateUtil);

  var _ticketLimit = 10;
  var _ticketAfter = "";
  @override
  void getArgs() {
    if (args != null) {
      _data = args as TaskActionArgs;
      _relatedTasks = _data.subTask ?? [];
    }
  }

  @override
  void load() {
    this.setScrollListener(_getTickets);
    _getTickets();
    _initStream();
  }

  void _initStream() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _clearTickets();
      _getTickets();
      loading(true);
      refreshUI();
    });
  }

  @override
  void initListeners() {
    _presenter.getTicketsOnNext = (List<Ticket> tickets, PersistenceType type) {
      _searchedTasks.addAll(tickets);
      _ticketAfter = tickets.last.intId.toString();
      if (searchController.text.isNullOrBlank()) {
        _resultTasks.addAll(tickets);
      } else {
        _resultTasks = tickets
            .where((u) =>
                u.intId
                    .toString()
                    .contains(searchController.text.substring(1)) ||
                u.name!
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
            .toList();
      }
      refreshUI();
    };

    _presenter.getTicketsOnComplete = (PersistenceType type) {
      print("status: completed getTickets $type");
      _chipOptions.clear();
      _chipOptions.addAll([
        S.of(context).status_task_assigned_to_me,
        S.of(context).status_task_created_by_me,
        S.of(context).status_task_open,
        S.of(context).status_task_all,
      ]);
      loading(false);
      if (!_userData.statusTooltipFinished) startShowCase();
    };

    _presenter.getTicketsOnError = (e, PersistenceType type) {
      print("status: error getTickets $e $type");
      loading(false);
    };
    _presenter.taskTransactionOnNext = (bool result) {
      print("taks: success taskTransaction $result");
      loading(false);
    };

    _presenter.taskTransactionOnComplete = () {
      print("taks: completed taskTransaction");
      Navigator.pop(context, data.task.id);
    };

    _presenter.taskTransactionOnError = (e) {
      print("taks: error.taskTransaction: $e");
      loading(false);
    };
  }

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowCaseWidget.of(context).startShowCase([three, four]);
    });
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

    _presenter.onGetTickets(GetTicketsApiRequest(
      query: searchController.text != "" ? searchController.text : null,
      queryKey: query,
      statuses: ['open'],
      limit: _ticketLimit,
      after: searchController.text != "" ? "" : _ticketAfter,
    ));
    loading(true);
  }

  String getUserStatus() {
    if (_setting != null && !_setting!.currentTask.isNullOrEmpty()) {
      return _setting!.currentTask!;
    }

    switch (_user?.status) {
      case "1":
        return S.of(context).status_just_mingling_label;
      case "2":
        return S.of(context).status_just_mingling_label;
      case "3":
        return S.of(context).profile_status_bathroom_label;
      case "4":
        return S.of(context).profile_status_lunch_label;
      case "5":
        return S.of(context).profile_status_me_time_label;
      case "6":
        return S.of(context).profile_status_family_label;
      case "7":
        return S.of(context).profile_status_praying_label;
      case "8":
        return S.of(context).profile_status_other_label;
      default:
        return S.of(context).status_just_mingling_label;
    }
  }

  bool validate() {
    return _selectedTasks.isNotEmpty;
  }

  void selectChip(bool selected, int value) {
    if (_selectedChip != value) {
      _selectedChip = value;
      _clearTickets();
      refreshUI();
      _getTickets();
    }
  }

  void _clearTickets() {
    _resultTasks.clear();
    _searchedTasks.clear();
    _ticketAfter = "";
  }

  String formatStatusDate(DateTime dt) {
    return _dateUtil.displayDateTimeFormat(dt);
  }

  void onSelectUser(int index, bool? selected) {
    bool isSelected = selected ?? false;

    if (isSelected) {
      _selectedTasks.add(_resultTasks[index]);
    } else {
      _selectedTasks
          .removeWhere((element) => element.id == _resultTasks[index].id);
    }

    refreshUI();
  }

  bool isObjectSelected(int index) {
    return _selectedTasks
        .map((e) => e.id)
        .toList()
        .contains(_resultTasks[index].id);
  }

  void onAddSubtask() {
    loading(true);
    _presenter.onAddSubtask(CreateLobbyRoomTicketApiRequest(
        objectIdentifier: _data.task.id,
        addedSubtaskIds: _selectedTasks.map((e) => e.id).toList()));
  }

  void onMergeTask() {
    loading(true);
    _presenter.onMergedTask(CreateLobbyRoomTicketApiRequest(
        objectIdentifier: _data.task.id,
        addedParentIds: _selectedTasks.map((e) => e.id).toList(),
        status: 'duplicate'));
  }

  void onRemoveSubtask(Ticket ticket) {
    _presenter.onRemoveSubtask(CreateLobbyRoomTicketApiRequest(
      objectIdentifier: _data.task.id,
      removedSubtaskIds: [ticket.id],
    ));
    loading(true);
  }

  //TODO: remove merged task
  void onRemoveMergedTask(Ticket ticket) {
    loading(true);
    _presenter.onRemoveMergedTask(CreateLobbyRoomTicketApiRequest(
      objectIdentifier: ticket.id,
      removedParentIds: [_data.task.id],
      status: "open",
    ));
    refreshUI();
  }

  void clearSearch() {
    _searchController.text = "";
    onSearch(false);
    _resultTasks.clear();
    _resultTasks.addAll(_searchedTasks);
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

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
  }
}
