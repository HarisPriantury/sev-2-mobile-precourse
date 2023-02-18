import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_subscriber/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_ticket_info_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

import 'detail_change_assignee/args.dart';

class DetailActionController extends BaseController {
  final DetailActionPresenter _presenter;
  final EventBus _eventBus;
  late DetailActionArgs _data;
  final Map<String, String> ticketStatuses = {
    "Open": "Open",
    "Resolved": "Resolved",
    "Wontfix": "Wontfix",
    "Invalid": "Invalid"
  };
  String? _ticketStatus;

  final Map<String, String> ticketPriorities = {
    Ticket.STATUS_UNBREAK: Ticket.STATUS_UNBREAK,
    Ticket.STATUS_TRIAGE: Ticket.STATUS_TRIAGE,
    Ticket.STATUS_HIGH: Ticket.STATUS_HIGH,
    Ticket.STATUS_NORMAL: Ticket.STATUS_NORMAL,
    Ticket.STATUS_LOW: Ticket.STATUS_LOW,
    Ticket.STATUS_WISHLIST: Ticket.STATUS_WISHLIST
  };
  String? _ticketPriority;

  final TextEditingController _storyPointsController = TextEditingController();

  String _ticketColumn = '';
  late Ticket _ticket;
  String? _storyPoints;
  List<User> _subscribers = [];
  List<String> _removedSubscriberIds = [];
  List<String> _addedSubscriberIds = [];
  User? _assignee;
  bool isAssigneeChanged = false;
  List<Project> _projects = [];
  List<String> _removedProjectIds = [];
  List<String> _addedProjectIds = [];
  CreateLobbyRoomTicketApiRequest _createTaskRequest =
      CreateLobbyRoomTicketApiRequest();

  DetailActionController(this._presenter, this._eventBus);

  DetailActionArgs get data => _data;
  String? get ticketStatus => _ticketStatus;
  String? get ticketPriority => _ticketPriority;
  TextEditingController get storyPointsController => _storyPointsController;
  String get ticketColumn => _ticketColumn;
  Ticket get ticket => _ticket;
  String? get storyPoints => _storyPoints;
  List<User> get subscribers => _subscribers;
  User? get assignee => _assignee;
  List<Project> get projects => _projects;

  @override
  void getArgs() {
    if (args != null) {
      _data = args as DetailActionArgs;
      _ticket = _data.ticket;
      print(_data.toPrint());
    }
  }

  @override
  void load() {
    switch (_data.type) {
      case DetailActionType.assign:
        if (_ticket.assignee != null) {
          _presenter.onGetUsers(
            GetUsersApiRequest(
              ids: [_ticket.assignee!.id],
            ),
            "owner",
          );
        }
        break;
      case DetailActionType.changeStatus:
        _ticketStatus = _ticket.rawStatus;
        loading(false);
        break;
      case DetailActionType.changePriority:
        _ticketPriority = _ticket.priority;
        loading(false);
        break;
      case DetailActionType.updateStoryPoint:
        _storyPointsController.text = _ticket.storyPoint.toString();
        loading(false);
        break;
      case DetailActionType.changeSubscriber:
        _presenter.onGetTicketSubscribers(
          GetTicketInfoApiRequest(
            _ticket.intId.toString(),
          ),
        );
        break;
      case DetailActionType.changeProjectLabel:
        _presenter.onGetTicketProjects(
          GetTicketInfoApiRequest(
            _ticket.intId.toString(),
          ),
        );
        break;
      default:
    }
  }

  void saveAssign() {
    loading(true);
    _createTaskRequest.objectIdentifier = _ticket.id;

    String? assignId;

    if (_assignee != null) {
      assignId = _assignee!.id;
    }
    _createTaskRequest.assigneeId = assignId;

    _presenter.onCreateTask(_createTaskRequest);
  }

  void saveStatus() {
    if (_ticketStatus != null && _ticketStatus!.isNotEmpty) {
      loading(true);
      _createTaskRequest.objectIdentifier = _ticket.id;
      _createTaskRequest.status = _ticketStatus?.toLowerCase();

      _presenter.onCreateTask(_createTaskRequest);
    }
  }

  void savePriority() {
    if (_ticketPriority != null && _ticketPriority!.isNotEmpty) {
      loading(true);
      _createTaskRequest.objectIdentifier = _ticket.id;
      _createTaskRequest.priority = Ticket.getPriorityKey(_ticketPriority!);

      _presenter.onCreateTask(_createTaskRequest);
    }
  }

  void saveStoryPoint() {
    if (_storyPoints != null) {
      loading(true);
      _createTaskRequest.objectIdentifier = _ticket.id;
      _createTaskRequest.point = double.parse(_storyPoints!);

      _presenter.onCreateTask(_createTaskRequest);
    }
  }

  void saveChangeSubscriber() {
    if (validateSaveSubscriber()) {
      loading(true);
      _createTaskRequest.objectIdentifier = _ticket.id;
      _createTaskRequest.removedSubscriberIds = _removedSubscriberIds;
      _createTaskRequest.addedSubscriberIds = _addedSubscriberIds;

      _presenter.onCreateTask(_createTaskRequest);
    }
  }

  void saveChangeProjectLabel() {
    if (validateSaveProject()) {
      loading(true);
      _createTaskRequest.objectIdentifier = _ticket.id;
      _createTaskRequest.setProjectIds = [_projects.last.id];

      _presenter.onCreateTask(_createTaskRequest);
    }
  }

  void onTicketStatusChanged(String? newValue) {
    if (newValue != null) {
      _ticketStatus = newValue;
      refreshUI();
    }
  }

  void onTicketPriorityChanged(String? newValue) {
    if (newValue != null) {
      _ticketPriority = newValue;
      refreshUI();
    }
  }

  void onTicketColumnChanged(String? newValue) {
    if (newValue != null) {
      _ticketColumn = newValue;
      refreshUI();
    }
  }

  void onRemoveSubscriber(User removedUser) {
    _removedSubscriberIds.add(removedUser.id);
    _subscribers.removeWhere((user) => removedUser.id == user.id);

    if (_addedSubscriberIds.contains(removedUser.id)) {
      _addedSubscriberIds.remove(removedUser.id);
    }
    refreshUI();
  }

  void onRemoveAssignee(User removedUser) {
    _assignee = null;
    isAssigneeChanged = true;
    refreshUI();
  }

  void onRemoveProject(Project removedProject) {
    _removedProjectIds.add(removedProject.id);
    _projects.removeWhere((project) => removedProject.id == project.id);

    if (_addedProjectIds.contains(removedProject.id)) {
      _addedProjectIds.remove(removedProject.id);
    }
    refreshUI();
  }

  bool validateSaveSubscriber() {
    return _removedSubscriberIds.isNotEmpty || _addedSubscriberIds.isNotEmpty;
  }

  bool validateSaveProject() {
    return _removedProjectIds.isNotEmpty || _addedProjectIds.isNotEmpty;
  }

  void goToAddSubscriber() async {
    final result = await Navigator.of(context).pushNamed(
      Pages.detailChangeSubscriber,
      arguments: DetailChangeSubscriberArgs(
        id: _ticket.id,
        currentSubscriber: _subscribers,
        type: DetailChangeSubscriberType.add,
      ),
    );

    if (result != null) {
      if (result is List<User>) {
        _addedSubscriberIds.addAll(result.map((e) => e.id).toList());
        _subscribers.addAll(result);
        showNotif(context, S.of(context).add_action_add_subscriber_success);
        refreshUI();
      }
    }
  }

  void goToSearchSubscriber() async {
    final result = await Navigator.of(context).pushNamed(
      Pages.detailChangeSubscriber,
      arguments: DetailChangeSubscriberArgs(
        id: _ticket.id,
        currentSubscriber: _subscribers,
        type: DetailChangeSubscriberType.search,
      ),
    );

    if (result != null) {
      if (result is List<User>) {
        _removedSubscriberIds.addAll(result.map((e) => e.id).toList());

        for (User user in result) {
          _subscribers.removeWhere((e) => e.id == user.id);
        }
        showNotif(context, S.of(context).add_action_remove_subscriber_success);
        refreshUI();
      }
    }
  }

  void goToAddAssigner() async {
    final result = await Navigator.of(context).pushNamed(
      Pages.detailChangeAssignee,
      arguments: DetailChangeAssigneeArgs(
        currentAssignee: _assignee,
      ),
    );

    if (result != null) {
      if (result is User) {
        _assignee = result;
        isAssigneeChanged = true;

        showNotif(context, S.of(context).add_action_add_assignee_success);
        refreshUI();
      }
    }
  }

  void goToAddLabel() async {
    final result = await Navigator.of(context).pushNamed(
      Pages.detailChangeProject,
      arguments: DetailChangeProjectArgs(
        currentProjects: _projects,
        type: DetailChangeProjectType.add,
      ),
    );

    if (result != null) {
      if (result is List<Project>) {
        _addedProjectIds.addAll(result.map((e) => e.id).toList());
        _projects = result;

        showNotif(context, S.of(context).add_action_add_label_success);
        refreshUI();
      }
    }
  }

  void gotoSearchLabel() async {
    final result = await Navigator.of(context).pushNamed(
      Pages.detailChangeProject,
      arguments: DetailChangeProjectArgs(
        currentProjects: _projects,
        type: DetailChangeProjectType.search,
      ),
    );

    if (result != null) {
      if (result is List<Project>) {
        _removedProjectIds.addAll(result.map((e) => e.id).toList());

        for (Project project in result) {
          _projects.removeWhere((e) => e.id == project.id);
        }
        showNotif(context, S.of(context).add_action_remove_label_success);
        refreshUI();
      }
    }
  }

  void goToDetailProject(Project project) {
    Navigator.pushNamed(
      context,
      Pages.projectDetail,
      arguments: DetailProjectArgs(phid: project.id),
    );
  }

  void _closeAndRefreshPage() {
    Navigator.of(context).pop(_ticket);

    _eventBus.fire(Refresh());
  }

  @override
  void initListeners() {
    _storyPointsController.addListener(() {
      _storyPoints = _storyPointsController.text;
      refreshUI();
    });

    _presenter.createTaskOnNext = (bool result) {
      print("detailAction: success createTask $result");
    };

    _presenter.createTaskOnComplete = () {
      print("detailAction: completed createTask");
      _closeAndRefreshPage();
      loading(false);
    };

    _presenter.createTaskOnError = (e) {
      print("detailAction: error createTask: $e");
      loading(false);
    };

    _presenter.getTicketSubscribersOnNext =
        (TicketSubscriberInfo subscribersInfo, PersistenceType type) {
      print("detailAction: success getTicketSubscribers $type");

      _ticket.subscriberInfo = subscribersInfo;
      if (subscribersInfo.totalSubscriber > 0) {
        _presenter.onGetUsers(
          GetUsersApiRequest(ids: _ticket.subscriberInfo?.subscriberIds),
          "subscribers",
        );
      }
    };

    _presenter.getTicketSubscribersOnComplete = (PersistenceType type) {
      print("detailAction: completed getTicketSubscribers $type");
    };

    _presenter.getTicketSubscribersOnError = (e, PersistenceType type) {
      print("detailAction: error getTicketSubscribers: $e $type");
      loading(false);
    };

    _presenter.getUsersOnNext =
        (List<User> users, PersistenceType type, String role) {
      print("detailAction: success getUsers $type $role, ${users.length}");
      if (role == "subscribers") {
        _subscribers.clear();
        _subscribers.addAll(users);
      } else if (role == "owner") {
        _assignee = users.first;
      }
      refreshUI();
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("detailAction: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      print("detailAction: error getUsers: $e $type");
      loading(false);
    };

    _presenter.getTicketProjectsOnNext =
        (TicketProjectInfo projectInfo, PersistenceType type) {
      print(
        "detailAction: success getTicketProjets $type, ${projectInfo.projectIds}",
      );
      _presenter.onGetProjects(
        GetProjectsApiRequest(ids: projectInfo.projectIds),
      );
      refreshUI();
    };

    _presenter.getTicketProjectsOnComplete = (PersistenceType type) {
      print("detailAction: completed getTicketProjects $type");
    };

    _presenter.getTicketProjectsOnError = (e, PersistenceType type) {
      print("detailAction: error getTicketProjects: $e $type");
      loading(false);
    };

    _presenter.getProjectsOnNext =
        (List<Project> projectResponse, PersistenceType type) {
      print(
        "detailAction: success getProjets $type, ${projectResponse.length}",
      );

      _projects.clear();
      _projects = projectResponse;
      refreshUI();
    };

    _presenter.getProjectsOnComplete = (PersistenceType type) {
      print("detailAction: completed getProjects $type");
      loading(false);
    };

    _presenter.getProjectsOnError = (e, PersistenceType type) {
      print("detailAction: error getProjects: $e $type");
      loading(false);
    };
  }

  @override
  void disposing() {
    _presenter.dispose();
    _storyPointsController.dispose();
  }
}
