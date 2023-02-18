import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/show_bottom_modal.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/project/list/presenter.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:stream_transform/stream_transform.dart';

class ProjectController extends SheetController {
  ProjectController(
    this._presenter,
    this._userData,
    this._eventBus,
  );
  EventBus _eventBus;
  ProjectPresenter _presenter;
  UserData _userData;
  List<Suggestion> userSuggestion = [];

  bool _isSearchProject = false;
  bool _isSearchTicket = false;

  ProjectFilterType _projectFilterType = ProjectFilterType.All;

  User? _user;
  List<Project> _projects = [];
  List<Ticket> _tickets = [];
  Ticket? _ticketObj;
  Ticket? _selectedTicket;

  final FocusNode _focusNodeSearchProject = FocusNode();
  final FocusNode _focusNodeSearchTicket = FocusNode();

  final TextEditingController _searchProjectController =
      TextEditingController();
  final TextEditingController _searchTicketController = TextEditingController();

  final StreamController<String> _streamController = StreamController();
  final StreamController<String> _streamTicketController = StreamController();

  var _isPaginating = false;

  var _keywordProject = "";
  var _keywordTicket = "";

  var _projectLimit = 10;
  var _projectAfter = "";

  var _ticketLimit = 10;
  var _ticketAfter = "";

  @override
  void initListeners() {
    _presenter.getUsersOnNext = (List<User> users) {
      print("user: success getUsers");
      if (users.isNotEmpty) _user = users.first;
      loading(false);
    };

    _presenter.getUsersOnComplete = () {
      print("user: completed getUsers");
      loading(false);
      if (_selectedTicket != null)
        showDetailTicketBottoomSheet(_selectedTicket!);
    };

    _presenter.getUsersOnError = (e) {
      print("user: error getUsers: $e");
      loading(false);
      refreshUI();
    };

    _presenter.getProjectsOnNext = (List<Project> projects) {
      print("projects: success getProjects");
      _projects.addAll(projects);
      if (projects.isNotEmpty)
        _projectAfter = projects.last.intId.toString();
      else
        _isPaginating = false;
      refreshUI();
      loading(false);
    };

    _presenter.getProjectsOnComplete = () {
      print("project: completed getProjects");
      loading(false);
    };

    _presenter.getProjectsOnError = (e) {
      print("project: error getProjects: $e");
      loading(false);
    };

    _presenter.getTicketsOnNext = (List<Ticket> tickets) {
      print("tickets: success getTickets");
      _tickets.addAll(tickets);
      if (tickets.isNotEmpty)
        _ticketAfter = tickets.last.intId.toString();
      else
        _isPaginating = false;
      refreshUI();
      loading(false);
    };

    _presenter.getTicketsOnComplete = () {
      print("tickets: completed getTickets");
      _isPaginating = false;
      loading(false);
      refreshUI();
    };

    _presenter.getTicketsOnError = (e) {
      print("tickets: error getTickets $e");
    };
  }

  void getUser(String phidUser, Ticket selectedTicket) {
    _selectedTicket = selectedTicket;
    _presenter.onGetUsers(GetUsersApiRequest(ids: [phidUser]));
  }

  @override
  void load() {
    _focusNodeSearchProject.addListener(onFocusChangeProject);
    _focusNodeSearchTicket.addListener(onFocusChangeTicket);
    _initStream();
    loading(true);
    _getProjects(_keywordProject);
    _getTickets(_keywordTicket);
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    loading(true);
    onSearchProject(false);
    onSearchTicket(false);
    _isPaginating = false;
    _projects.clear();
    _tickets.clear();
    _projectAfter = "";
    _ticketAfter = "";
    _keywordProject = "";
    _keywordTicket = "";
    _projectFilterType = ProjectFilterType.All;
    _getProjects(_keywordProject);
    _getTickets(_keywordTicket);
  }

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
    _streamTicketController.close();
  }

  List<Project> get project => _projects;
  List<Ticket> get ticket => _tickets;
  User? get user => _user;

  Ticket? get ticketObj => _ticketObj;

  TextEditingController get searchProjectController => _searchProjectController;
  TextEditingController get searchTicketController => _searchTicketController;

  FocusNode get focusNodeSearchProject => _focusNodeSearchProject;
  FocusNode get focusNodeSearchTicket => _focusNodeSearchTicket;

  StreamController<String> get streamController => _streamController;
  StreamController<String> get streamTicketController =>
      _streamTicketController;

  ProjectFilterType get projectFilterType => _projectFilterType;

  bool get isPaginating => _isPaginating;

  void onFocusChangeProject() {
    if (_focusNodeSearchProject.hasFocus) {
      onSearchProject(true);
    } else if (_searchProjectController.text.isEmpty) {
      onSearchProject(false);
    }
  }

  void onFocusChangeTicket() {
    if (_focusNodeSearchTicket.hasFocus) {
      onSearchTicket(true);
    } else if (_searchTicketController.text.isEmpty) {
      onSearchTicket(false);
    }
  }

  void clearSearch() {
    _searchProjectController.text = "";
    _searchTicketController.text = "";
    _keywordProject = "";
    _keywordTicket = "";
    onSearchProject(false);
    onSearchTicket(false);
    _isPaginating = false;
    _projects.clear();
    _tickets.clear();
    loading(true);
    _projects.clear();
    _tickets.clear();
    _getProjects(_keywordProject, reset: true);
    _getTickets(_keywordTicket, reset: true);
  }

  void onSearchProject(bool isSearchingProject) {
    _isSearchProject = isSearchingProject;
    if (_isSearchProject) {
      _focusNodeSearchProject.requestFocus();
    } else {
      _focusNodeSearchProject.unfocus();
      _searchProjectController.clear();
    }
    refreshUI();
  }

  void onSearchTicket(bool isSearchingTicket) {
    _isSearchTicket = isSearchingTicket;
    if (_isSearchTicket) {
      _focusNodeSearchTicket.requestFocus();
    } else {
      _focusNodeSearchTicket.unfocus();
      _searchTicketController.clear();
    }
    refreshUI();
  }

  void goToProjectDetail(Project project) {
    Navigator.pushNamed(
      context,
      Pages.projectDetail,
      arguments: DetailProjectArgs(phid: project.id),
    );
  }

  void goToTicketDetail(Ticket ticket) {
    Navigator.pushNamed(
      context,
      Pages.ticketDetail,
      arguments: DetailTicketArgs(phid: ticket.id),
    );
  }

  void filter(ProjectFilterType filterType) {
    if (projectFilterType != filterType) {
      loading(true);
      onSearchProject(false);
      _isPaginating = false;
      _projects.clear();
      _projectAfter = "";
      _keywordProject = "";
      _projectFilterType = filterType;
      _getProjects(_keywordProject);
      refreshUI();
    }
  }

  String getFilterProject() {
    switch (_projectFilterType) {
      case ProjectFilterType.Joined:
        return S.of(context).label_joined_project;
      case ProjectFilterType.Active:
        return S.of(context).label_active_project;
      default:
        return S.of(context).label_all_project;
    }
  }

  String getTicketPolicy() {
    String policy = 'All User';
    if (ticketObj?.project != null) {
      if (ticketObj?.project?.viewPolicy != null &&
          ticketObj!.project!.viewPolicy.isNotEmpty) {
        policy = ticketObj!.project!.viewPolicy;
      }
    }
    return policy;
  }

  void _initStream() {
    listScrollController.addListener(searchScrollListenerProject);
    secondListScrollController.addListener(searchScrollListenerTicket);
    // PROJECT
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _keywordProject = s.toLowerCase();
      loading(true);
      _projects.clear();
      _getProjects(_keywordProject, reset: true);
      refreshUI();
    });
    // TICKET
    _streamTicketController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _keywordTicket = s.toLowerCase();
      loading(true);
      _tickets.clear();
      _getTickets(_keywordTicket, reset: true);
      refreshUI();
    });
  }

  void searchScrollListenerProject() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      _isPaginating = true;
      _getProjects(_keywordProject);
    }
  }

  void searchScrollListenerTicket() {
    if (secondListScrollController.offset >=
            secondListScrollController.position.maxScrollExtent &&
        !secondListScrollController.position.outOfRange) {
      _isPaginating = true;
      _getTickets(_keywordTicket);
    }
  }

  void _getProjects(String keyword, {bool reset = false}) {
    if (!_isPaginating) loading(true);
    _presenter.onGetProjects(
      GetProjectsApiRequest(
          limit: _projectLimit,
          after: reset ? "" : _projectAfter,
          nameLike: keyword,
          members: _projectFilterType == ProjectFilterType.Joined
              ? [_userData.id]
              : null,
          queryKey: _projectFilterType.toString().split('.')[1].toLowerCase()),
    );
  }

  void moveToNewProject() {
    Navigator.pushNamed(context, Pages.createProject);
  }

  void goToCreateTicket(TaskType taskSubtype, {bool isBug = false}) {
    if (taskSubtype == TaskType.task) {
      Navigator.pushNamed(
        context,
        Pages.create,
        arguments: CreateArgs(
          type: Ticket,
          object: _ticketObj,
          isCreateTicketFromMain: true,
        ),
      );
    } else if (taskSubtype == TaskType.bug) {
      Navigator.pushNamed(
        context,
        Pages.create,
        arguments: CreateArgs(
          type: Ticket,
          object: _ticketObj,
          taskType: TaskType.bug,
          isCreateTicketFromMain: true,
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        Pages.create,
        arguments: CreateArgs(
          type: Ticket,
          object: _ticketObj,
          taskType: TaskType.spike,
          isCreateTicketFromMain: true,
        ),
      );
    }
  }

  void _getTickets(String keyword, {bool reset = false}) {
    _presenter.onGetTickets(GetTicketsApiRequest(
      limit: _ticketLimit,
      after: reset ? "" : _ticketAfter,
      query: _keywordTicket,
      queryKey: GetTicketsApiRequest.QUERY_ALL,
    ));
  }

  void showDetailTicketBottoomSheet(Ticket ticket) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return ShowBottomModalTicket(
          intId: ticket.intId.toString(),
          ticketName: ticket.name ?? "",
          rawStatus: ticket.rawStatus ?? "",
          storyPoint: ticket.storyPoint.toString(),
          assignedName: ticket.assignee?.name ?? "",
          authorName: _user?.name ?? "",
          projectName: ticket.project?.name ?? "",
          subType: ticket.subtype ?? "",
          onGotoDetail: () {
            Navigator.pop(context);
            goToTicketDetail(ticket);
          },
        );
      },
    );
  }
}

String getLabelFilterProject(BuildContext context, ProjectFilterType value) {
  switch (value) {
    case ProjectFilterType.Joined:
      return S.of(context).label_joined_project;
    case ProjectFilterType.Active:
      return S.of(context).label_active_project;
    default:
      return S.of(context).label_all_project;
  }
}

enum ProjectFilterType { Filter, All, Joined, Active }
