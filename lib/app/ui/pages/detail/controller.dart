import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/author_reaction_sheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/args.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/args.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/calendar/join_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_stickit_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_columns_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/set_project_status_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/stickit/get_stickit_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_ticket_info_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailController extends SheetController {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _spController = TextEditingController();

  DetailPresenter _presenter;
  DetailArgs? _data;
  DateUtilInterface _dateUtil;
  UserData _userData;
  List<User> _userList;
  EventBus _eventBus;

  // create transaction request
  CreateEventApiRequest _createCalendarRequest = CreateEventApiRequest();
  CreateLobbyRoomStickitApiRequest _createStickitRequest =
      CreateLobbyRoomStickitApiRequest();
  CreateLobbyRoomTicketApiRequest _createTaskRequest =
      CreateLobbyRoomTicketApiRequest();

  //this is [Set] because every action can only called once
  Set<int> _actionSet = {};
  Stickit? _stickitObj;
  Ticket? _ticketObj;
  Project? _projectObj;
  Calendar? _calendarObj;
  List<PhTransaction> _transactions = [];

  List<Project> _subProjects = [];
  List<Project> _milestones = [];

  List<Ticket> _subtask = [];
  List<Ticket> get subtask => _subtask;
  List<Ticket> _parentTask = [];
  List<Ticket> get parenTask => _parentTask;

  List<PhObject> _invitees = []; // calendar
  List<PhObject> _projects = []; // calendar & task
  List<PhObject> _subscribers = []; // calendar and task
  List<PhObject> _assignees = []; // task
  List<ProjectColumn> _workboards = []; // task
  List<PhObject> _formerSubscribers = [];

  List<ObjectReactions> _objectReactions = [];

  // hold ticket priority and status
  String? _ticketPriority;
  String? _ticketStatus;
  String? _workboard;

  // project status
  bool _isForRsp = false;
  bool _isForDev = false;
  bool _isArchived = false;
  bool isChanged = true;
  bool _onAddActionClicked = false;
  bool _isEditProject = false;
  String? _projectStatus;
  String _statusInvitation = "invited";

  bool _isReloadReaction = false;

  int _parentTaskLength = 0;

  int _subTaskLength = 0;

  bool _isHasParentTask = false;

  bool _isHasSubtasks = false;

  DateUtilInterface get dateUtil => _dateUtil;

  DetailController(
    this._presenter,
    this._userData,
    this._dateUtil,
    this._userList,
    this._eventBus,
  );

  DetailArgs? get data => _data;

  Set<int> get actionSet => _actionSet;

  bool get onAddActionClicked => _onAddActionClicked;

  Stickit? get stickitObj => _stickitObj;

  Ticket? get ticketObj => _ticketObj;

  Calendar? get calendarObj => _calendarObj;

  Project? get projectObj => _projectObj;

  UserData get userData => _userData;

  List<Project> get subProjects => _subProjects;

  List<Project> get milestones => _milestones;

  List<PhTransaction>? get transactions => _transactions;

  TextEditingController get commentController => _commentController;

  String? get ticketPriority => _ticketPriority;

  String? get ticketStatus => _ticketStatus;

  CreateEventApiRequest get createCalendarRequest => _createCalendarRequest;

  CreateLobbyRoomStickitApiRequest get createStickitRequest =>
      _createStickitRequest;

  CreateLobbyRoomTicketApiRequest get createTaskRequest => _createTaskRequest;

  bool get isForRsp => _isForRsp;

  bool get isForDev => _isForDev;

  bool get isArchived => _isArchived;

  int get parentTaskLength => _parentTaskLength;

  int get subTaskLength => _subTaskLength;

  bool get isHasParentTask => _isHasParentTask;

  bool get isHasSubtasks => _isHasSubtasks;

  String? get projectStatus => _projectStatus;

  List<String> getActions() {
    switch (getArgsType()) {
      case Stickit:
        return List.empty();
      case Calendar:
        return ["Change Invitees", "Change Project Tags", "Change Subscribers"];
      case Ticket:
        return [
          "Assign / Claim",
          "Change Status",
          "Change Priority",
          "Update Story Point",
          "Move on Workboard",
          "Change Project Label",
          "Change Subscriber"
        ];
      default:
        return List.empty();
    }
  }

  void sendReaction(reactionId, objectId) {
    _presenter.onSendReaction(GiveReactionApiRequest(reactionId, objectId));
  }

  void _refreshDetailTickets() {
    _presenter.onGetTickets(GetTicketsApiRequest(
        queryKey: GetTicketsApiRequest.QUERY_ALL, phids: [_ticketObj!.id]));
    loading(true);
  }

  void _refreshDetailProject() {
    _presenter.onGetProjects(GetProjectsApiRequest(ids: [_projectObj!.id]));
    loading(true);
  }

  void _refreshDetailStickit() {
    _presenter.onGetStickit(GetStickitsApiRequest(phids: [_stickitObj!.id]));
    loading(true);
  }

  void _refreshDetailEvent() {
    _presenter.onGetEvent(
      GetEventsApiRequest(phids: [_calendarObj!.id]),
    );
    loading(true);
  }

  Future<void> goToEditPage({bool isSubTask = false}) async {
    if (_stickitObj != null) {
      var result = await Navigator.pushNamed(
        context,
        Pages.create,
        arguments: CreateArgs(type: Stickit, object: stickitObj),
      );

      if (result != null) {
        reload();
      }
    } else if (_calendarObj != null) {
      var result = await Navigator.pushNamed(
        context,
        Pages.create,
        arguments: CreateArgs(type: Calendar, object: _calendarObj),
      );

      if (result != null) {
        reload();
      }
    } else if (_ticketObj != null) {
      if (isSubTask) {
        Navigator.pushNamed(
          context,
          Pages.create,
          arguments: CreateArgs(
              type: Ticket, object: _ticketObj, isSubTask: isSubTask),
        );
      } else {
        var result = await Navigator.pushNamed(
          context,
          Pages.create,
          arguments: CreateArgs(type: Ticket, object: _ticketObj),
        );

        if (result != null) {
          _ticketObj = result as Ticket;
        }
      }
    }

    refreshUI();
  }

  Future<void> goToTaskActionPage(TaskActionType type) async {
    if (_ticketObj != null) {
      var result = await Navigator.pushNamed(
        context,
        Pages.taskAction,
        arguments: TaskActionArgs(
          type: type,
          task: _ticketObj!,
          subTask: _subtask.isNotEmpty ? _subtask : _parentTask,
        ),
      );
      if (result != null) {
        reload();
      }
    }
  }

  void goToDetail(PhObject object) async {
    isChanged = true;
    var result = await Navigator.pushNamed(
      context,
      Pages.detail,
      arguments: DetailArgs(object),
    );
    if (isChanged || result != null) {
      loading(true);
      reload();
    }
    refreshUI();
  }

  void goToWorkboard({Project? project}) async {
    isChanged = true;
    if (_projectObj != null) {
      var result = await Navigator.pushNamed(
        context,
        Pages.workboard,
        arguments: WorkboardArgs(
          project: project ?? _projectObj!,
        ),
      );
      if (result != null) {
        reload();
      }
    }
  }

  @override
  void load() {
    getArgsType();

    if (ticketObj != null) {
      getRelatedTask(ticketObj);
      if (ticketObj!.assignee != null)
        _presenter.onGetUsers(
          GetUsersApiRequest(
            ids: [ticketObj!.author!.id, ticketObj!.assignee!.id],
          ),
          "owner",
        );
      else
        _presenter.onGetUsers(
          GetUsersApiRequest(ids: [ticketObj!.author!.id]),
          "owner",
        );
      if (ticketObj!.project != null)
        _presenter.onGetColumns(
          GetProjectColumnsApiRequest(
            ticketObj!.project!.id,
          ),
        );
      _presenter.onGetTicketSubscribers(
        GetTicketInfoApiRequest(
          ticketObj!.intId.toString(),
        ),
      );
    }

    if (projectObj != null && projectObj?.members != null) {
      getProject(
          _projectObj!.id, projectObj!.members!.map((e) => e.id).toList());
    }

    getTransaction();
  }

  void getTransaction() {
    _presenter.onGetTransactions(
      GetObjectTransactionsApiRequest(
        identifier: _data?.object.id,
      ),
    );
  }

  void getProject(String parents, List<String>? memberId) {
    _presenter.onGetProjects(
      GetProjectsApiRequest(
        parents: [parents],
      ),
      type: "subproject",
    );
    _presenter.onGetUsers(
      GetUsersApiRequest(ids: memberId),
      "project",
    );
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as DetailArgs;
      print(_data?.toPrint());
    }
  }

  @override
  void initListeners() {
    _eventBus.on<Refresh>().listen((event) {
      reload();
    });
    _presenter.getUsersOnNext =
        (List<User> users, PersistenceType type, String role) {
      print("detail: success getUsers $type $role, ${users.length}");
      if (role == "owner") {
        if (users.length == 1) {
          if (_ticketObj != null) {
            if (users.first.id == _ticketObj!.author!.id) {
              _ticketObj?.author = users.first;
            }
          }
        }
        users.forEach((u) {
          if (_ticketObj != null) {
            if (u.id == _ticketObj!.assignee!.id) {
              _ticketObj?.assignee = u;
            }

            if (u.id == _ticketObj!.author!.id) {
              _ticketObj?.author = u;
            }
          }
        });
      } else if (role == "subscribers") {
        _formerSubscribers.clear();
        _formerSubscribers.addAll(users);
        refreshUI();
      } else if (role == "project") {
        _projectObj?.members?.clear();
        _projectObj?.members?.addAll(users);
        // _projectObj?.members = users;
        refreshUI();
      }
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("detail: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error getUsers: $e $type");
    };

    _presenter.getTransactionsOnNext =
        (List<PhTransaction> transactions, PersistenceType type) {
      print("detail: success getTransactions $type");
      _transactions.addAll(transactions);

      List<String> phids = [];
      List<int> fileIds = [];
      _transactions.forEach((t) {
        phids.add(t.actor.id);
        phids.add(t.target.id);

        if (t.oldRelation != null) {
          phids.add(t.oldRelation!.id);
        }

        if (t.newRelation != null) {
          phids.add(t.newRelation!.id);
        }

        if (t.attachments!.isNotEmpty) {
          fileIds.addAll(t.attachments!.map((e) => e.idInt));
        }
      });

      if (phids.isNotEmpty) {
        _presenter.onGetObjects(GetObjectsApiRequest(phids));
      } else {
        loading(false);
      }

      if (fileIds.isNotEmpty) {
        _presenter.onGetFiles(GetFilesApiRequest(ids: fileIds));
      }
    };

    _presenter.getTransactionsOnComplete = (PersistenceType type) {
      print("detail: completed getTransactions $type");
      _presenter.onGetObjectReactions(GetObjectReactionsApiRequest(
          objectIds: _transactions.map((e) => e.id).toList()));
    };

    _presenter.getTransactionsOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error getTransactions: $e $type");
    };

    _presenter.getObjectsOnNext =
        (List<PhObject> objects, PersistenceType type) {
      print("detail: success getObjects $type");

      objects.forEach((obj) {
        // var ts = _transactions.where((t) => t.actor.id == obj.id);
        // ts.forEach((tsi) {
        //   var idx = _transactions.indexWhere((t) => t.id == tsi.id);
        //   if (idx >= 0) {
        //     _transactions[idx].actor = obj;
        //   }
        // });

        var ts = _transactions.where((t) => t.target.id == obj.id);
        ts.forEach((tsi) {
          var idx = _transactions.indexWhere((t) => t.id == tsi.id);
          if (idx >= 0) {
            _transactions[idx].target = obj;
          }
        });

        var tsOr = _transactions.where((t) => t.oldRelation?.id == obj.id);
        tsOr.forEach((tsi) {
          var idx = _transactions.indexWhere((t) => t.id == tsi.id);
          if (idx >= 0) {
            _transactions[idx].action = _transactions[idx]
                .action
                .replaceAll(tsi.oldRelation!.id, obj.name!);
          }
        });

        var tsNr = _transactions.where((t) => t.newRelation?.id == obj.id);
        tsNr.forEach((tsi) {
          var idx = _transactions.indexWhere((t) => t.id == tsi.id);
          if (idx >= 0) {
            _transactions[idx].action = _transactions[idx]
                .action
                .replaceAll(tsi.newRelation!.id, obj.name!);
          }
        });
      });
    };

    _presenter.getObjectsOnComplete = (PersistenceType type) {
      print("detail: completed getObjects $type");
      loading(false);
    };

    _presenter.getObjectsOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error getObjects: $e $type");
    };

    _presenter.joinEventOnNext = (bool result, PersistenceType type) {
      print("detail: success joinEvent $type");
    };

    _presenter.joinEventOnComplete = (PersistenceType type) {
      print("detail: completed joinEvent $type");
      var idx = _calendarObj!.invitees!
          .indexWhere((element) => element.id == _userData.id);
      if (idx > -1) {
        _calendarObj!.invitees![idx].status = _statusInvitation; //"attending";
      } else {
        User me = _userData.toUser();
        me.status = "attending";
        _calendarObj!.invitees!.add(me);
      }
      loading(false);
    };

    _presenter.joinEventOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error joinEvent: $e $type");
    };

    _presenter.getTicketSubscribersOnNext =
        (TicketSubscriberInfo subscribersInfo, PersistenceType type) {
      print("detail: success getTicketSubscribers $type");
      if (_ticketObj != null) {
        _ticketObj!.subscriberInfo = subscribersInfo;
        if (subscribersInfo.totalSubscriber > 0)
          _presenter.onGetUsers(
              GetUsersApiRequest(ids: ticketObj!.subscriberInfo!.subscriberIds),
              "subscribers");
      }
    };

    _presenter.getTicketSubscribersOnComplete = (PersistenceType type) {
      print("detail: completed getTicketSubscribers $type");
      refreshUI();
    };

    _presenter.getTicketSubscribersOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error getTicketSubscribers: $e $type");
    };

    _presenter.calendarTransactionOnNext = (bool result, PersistenceType type) {
      print("detail: success calendarTransaction $type");
    };

    _presenter.calendarTransactionOnComplete = (PersistenceType type) {
      print("detail: completed calendarTransaction $type");
      // _forceRefresh();
      reload();
    };

    _presenter.calendarTransactionOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error calendarTransaction: $e $type");
    };

    _presenter.stickitTransactionOnNext = (bool result, PersistenceType type) {
      print("detail: success stickitTransaction $type");
    };

    _presenter.stickitTransactionOnComplete = (PersistenceType type) {
      print("detail: completed stickitTransaction $type");
      // _forceRefresh();
      reload();
    };

    _presenter.stickitTransactionOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error.stickitTransaction: $e $type");
    };

    _presenter.taskTransactionOnNext = (bool result, PersistenceType type) {
      print("detail: success taskTransaction $type");
    };

    _presenter.taskTransactionOnComplete = (PersistenceType type) {
      print("detail: completed taskTransaction $type");
      // _forceRefresh();
      reload();
    };

    _presenter.taskTransactionOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error taskTransaction: $e $type");
    };

    _presenter.getColumnsOnNext = (List<ProjectColumn> columns) {
      _workboards.clear();
      _workboards.addAll(columns);

      print("detail: success getColumns");
    };

    _presenter.getColumnsOnComplete = () {
      print("detail: completed getColumns");
      refreshUI();
    };

    _presenter.getColumnsOnError = (e) {
      loading(false);
      print("detail: error getColumns: $e");
    };

    // send reaction
    _presenter.sendReactionOnNext = (bool result, PersistenceType type) {
      print("detail: success sendReaction");
      //
    };

    _presenter.sendReactionOnComplete = (PersistenceType type) {
      print("detail: completed sendReaction");
      _isReloadReaction = true;
      _presenter.onGetObjectReactions(GetObjectReactionsApiRequest(
          objectIds: _transactions.map((e) => e.id).toList()));
    };

    _presenter.sendReactionOnError = (e, PersistenceType type) {
      loading(false);
      print("detail: error sendReaction $e");
    };

    // get object reactions
    _presenter.getObjectReactionOnNext = (List<ObjectReactions> result) {
      print("detail: success getObjectReactions ${result.length}");
      if (_isReloadReaction) {
        _transactions.forEach((element) {
          element.reactions?.clear();
        });
        _objectReactions.clear();
      }
      _objectReactions.addAll(result);
      result.forEach((reaction) {
        int idx =
            _transactions.indexWhere((chat) => chat.id == reaction.objectId);
        if (idx > -1) {
          if (_transactions[idx].reactions != null)
            _transactions[idx].reactions?.add(reaction.reaction);
          else
            _transactions[idx].reactions = [reaction.reaction];
        }
      });
      refreshUI();
    };

    _presenter.getObjectReactionOnComplete = () {
      print("voice: completed getObjectReactions");
    };

    _presenter.getObjectReactionOnError = (e) {
      loading(false);
      print("voice: error getObjectReactions $e");
    };

    _presenter.getFilesOnNext = (List<File> files) {
      print("detail: success getFiles");

      files.forEach((f) {
        _transactions.forEach((tr) {
          var tsNr = tr.attachments?.where((att) => att.idInt == f.idInt);
          tsNr?.forEach((tsi) {
            var idx = tr.attachments?.indexWhere((t) => t.id == tsi.id);
            if (idx! >= 0) {
              tr.attachments?[idx].url = f.url;

              var replacement = "";
              if (f.fileType == FileType.image) {
                replacement = "<img src='${f.url}'/>";
              } else if (f.fileType == FileType.video) {
                replacement = "<video controls><source src='${f.url}'></video>";
              }

              if (replacement != "") {
                tr.action = tr.action.replaceAll("{F${f.idInt}}", replacement);
                tr.action = tr.action.replaceAll("<bold>", "");
                tr.action = tr.action.replaceAll("</bold>", "");
                tr.action = tr.action.replaceAll("\n", "<br />");
              }
            }
          });
        });
      });
    };

    _presenter.getFilesOnComplete = () {
      print("detail: completed getFiles");
      refreshUI();
    };

    _presenter.getFilesOnError = (e) {
      loading(false);
      print("detail: error getFiles $e");
    };
    _presenter.getTicketsOnNext = (List<Ticket> tickets, PersistenceType type) {
      if (tickets.isNotEmpty) {
        _ticketObj = tickets.first;
      }
      refreshUI();
      getRelatedTask(tickets.first);
    };
    _presenter.getTicketsOnComplete = (PersistenceType type) {
      print("detail: completed getTickets $type");
      loading(false);
    };
    _presenter.getTicketsOnError = (e, PersistenceType type) {
      print("detail: error getTickets $e $type");
      loading(false);
    };
    _presenter.getProjectsOnNext = (List<Project> projects, String type) {
      if (type == 'project') {
        if (projects.isNotEmpty) {
          _projectObj = projects.first;
        }
        if (!_isEditProject)
          getProject(
              _projectObj!.id, projectObj!.members!.map((e) => e.id).toList());
      } else {
        _mapProjects(projects);
      }
      refreshUI();
    };
    _presenter.getProjectsOnComplete = () {
      print("detail: completed getProjects");
      loading(false);
    };
    _presenter.getProjectsOnError = (e) {
      print("detail: error getProjects: $e");
      loading(false);
    };

    _presenter.setProjectStatusOnNext = (BaseApiResponse response) {
      print("detail: success setProjectStatus ${response.result}");
      _projectObj!.isArchived = !_projectObj!.isArchived;
    };

    _presenter.setProjectStatusOnComplete = () {
      print("detail: completed setProjectStatus");
      Navigator.pop(context);
      refreshUI();
    };

    _presenter.setProjectStatusOnError = (e) {
      loading(false);
      print("detail: error setProjectStatus: $e");
      Navigator.pop(context);
      showNotif(context, "Something went wrong");
      refreshUI();
    };

    _presenter.getStickitsOnNext =
        (List<Stickit> stickits, PersistenceType type) {
      if (stickits.isNotEmpty) {
        _stickitObj = stickits.first;
        print("detail: getStickitsOnNext ${_stickitObj!.id}");
      }
      refreshUI();
    };
    _presenter.getStickitsOnComplete = (PersistenceType type) {
      print("detail: completed getStickits $type");
      loading(false);
    };
    _presenter.getStickitsOnError = (e, PersistenceType type) {
      print("detail: error getStickits $e $type");
      loading(false);
    };

    _presenter.getCalendarOnNext =
        (List<Calendar> calendars, PersistenceType type) {
      if (calendars.isNotEmpty) {
        _calendarObj = calendars.first;
        print("detail: getCalendarOnNext $type");
      }
      refreshUI();
    };
    _presenter.getCalendarOnComplete = (PersistenceType type) {
      print("detail: completed calendar $type");
      loading(false);
    };
    _presenter.getCalendarOnError = (e, PersistenceType type) {
      print("detail: error calendar $e $type");
      loading(false);
    };
  }

  void _mapProjects(List<Project> projects) {
    _subProjects.clear();
    _milestones.clear();
    projects.forEach((project) {
      if (project.isMilestone) {
        _milestones.add(project);
      } else {
        _subProjects.add(project);
      }
    });
  }

  Type getArgsType() {
    if (_data!.object is Stickit) {
      _stickitObj = _data!.object as Stickit;
      return Stickit;
    } else if (_data!.object is Calendar) {
      _calendarObj = _data!.object as Calendar;
      return Calendar;
    } else if (_data!.object is Ticket) {
      _ticketObj = _data!.object as Ticket;
      return Ticket;
    } else if (_data!.object is Project) {
      _projectObj = _data!.object as Project;
      return Project;
    } else
      return PhObject;
  }

  bool isJoinedOrDeclined(bool isJoined) {
    if (getArgsType() == Calendar) {
      var invs = _calendarObj!.invitees!.where((inv) => inv.id == _userData.id);
      var status = "declined";
      if (isJoined) {
        status = "attending";
      }
      return invs.isNotEmpty && invs.first.status == status;
    } else
      return false;
  }

  bool isAuthor() {
    if (_data!.object is Stickit) {
      _stickitObj = _data!.object as Stickit;
      return _stickitObj!.author.id == _userData.id;
    } else if (_data!.object is Calendar) {
      _calendarObj = _data!.object as Calendar;
      return _calendarObj!.host.id == _userData.id;
    } else if (_data!.object is Ticket) {
      _ticketObj = _data!.object as Ticket;
      return _ticketObj!.author?.id == _userData.id ||
          _ticketObj!.assignee?.id == _userData.id;
    } else if (_data!.object is Project) {
      _projectObj = _data!.object as Project;
      return _projectObj!.members!
              .indexWhere((element) => element.id == _userData.id) >
          -1;
    } else
      return false;
  }

  bool isInvited() {
    return _calendarObj!.invitees!
        .where((inv) => inv.id == _userData.id)
        .isNotEmpty;
  }

  void onCalendarAct(bool willJoin) {
    _statusInvitation = willJoin ? 'attending' : 'declined';
    _presenter.onJoinEvent(JoinEventApiRequest(_calendarObj!.id, willJoin));
    loading(true);
  }

  void addActionClicked() {
    _onAddActionClicked = !_onAddActionClicked;
    refreshUI();
  }

  void onDeleteItem(int value) {
    _actionSet.remove(value);

    // clear data
    _setInitialActionData(value, isRefresh: true);
    refreshUI();
  }

  void actionClicked(int index) {
    _actionSet.add(index);
    _setInitialActionData(index, isRefresh: true);
  }

  void _setInitialActionData(int index, {bool isRefresh = false}) {
    if (_data!.object is Calendar) {
      switch (index) {
        case 0:
          if (isRefresh) _invitees.clear();
          _invitees.addAll(calendarObj!.invitees!);
          break;
        case 1:
          if (isRefresh) _projects.clear();
          // add project
          break;
        case 2:
          if (isRefresh) _subscribers.clear();
          _subscribers = _formerSubscribers;
          break;
        default:
          break;
      }
    } else if (_data!.object is Ticket) {
      switch (index) {
        case 0:
          if (isRefresh) _assignees.clear();
          _assignees.add(ticketObj!.assignee!);
          break;
        case 1:
          _ticketStatus = _ticketObj!.rawStatus!;
          break;
        case 2:
          _ticketPriority = _ticketObj!.priority;
          break;
        case 3:
          _spController.text = ticketObj!.storyPoint.toString();
          break;
        case 4:
          var idx =
              _workboards.indexWhere((e) => e.name == ticketObj!.position);
          if (idx >= 0) {
            _workboard = ticketObj!.position;
          }
          break;
        case 5:
          if (isRefresh) _projects.clear();
          if (_ticketObj!.project != null) _projects.add(ticketObj!.project!);
          break;
        case 6:
          if (isRefresh) _subscribers.clear();
          _subscribers.addAll(_formerSubscribers);
          break;
        default:
          break;
      }
    }
  }

  void createStickitTransaction() {
    var needUpdate = false;
    _createStickitRequest.objectIdentifier = _stickitObj!.id;

    if (_commentController.text.isNotEmpty) {
      _createStickitRequest.comment = _commentController.text;
      needUpdate = true;
    }

    if (needUpdate) _presenter.onStickitTransaction(_createStickitRequest);
  }

  void createCalendarTransaction() {
    var needUpdate = false;
    _createCalendarRequest.objectIdentifier = _calendarObj!.id;

    if (_commentController.text.isNotEmpty) {
      _createCalendarRequest.comment = _commentController.text;
      needUpdate = true;
    }

    // invitees
    if (_invitees.isNotEmpty) {
      _createCalendarRequest.invitees = _invitees.map((e) => e.id).toList();
      needUpdate = true;
    }

    // subscriber
    if (_subscribers.isNotEmpty) {
      _createCalendarRequest.setSubscriberIds =
          _subscribers.map((e) => e.id).toList();
      needUpdate = true;
    }

    // project
    if (_projects.isNotEmpty) {
      _createCalendarRequest.setProjectIds =
          _projects.map((e) => e.id).toList();
      needUpdate = true;
    }

    if (needUpdate) _presenter.onCalendarTransaction(_createCalendarRequest);
  }

  void createTaskTransaction() {
    var needUpdate = false;
    _createTaskRequest.objectIdentifier = _ticketObj!.id;

    if (_commentController.text.isNotEmpty) {
      _createTaskRequest.comment = _commentController.text;
      needUpdate = true;
    }

    // assignee
    if (_assignees.isNotEmpty) {
      _createTaskRequest.assigneeId = _assignees.first.id;
      needUpdate = true;
    }

    // subscriber
    if (_subscribers.isNotEmpty) {
      _createTaskRequest.setSubscriberIds =
          _subscribers.map((e) => e.id).toList();
      needUpdate = true;
    }

    // project
    if (_projects.isNotEmpty) {
      _createTaskRequest.setProjectIds = _projects.map((e) => e.id).toList();
      needUpdate = true;
    }

    // story point
    if (_spController.text.isNotEmpty) {
      _createTaskRequest.point = double.parse(_spController.text);
      needUpdate = true;
    }

    // priority
    if (_ticketPriority != null) {
      _createTaskRequest.priority = Ticket.getPriorityKey(_ticketPriority!);
      needUpdate = true;
    }

    if (_ticketStatus != null) {
      _createTaskRequest.status = _ticketStatus!.toLowerCase();
      needUpdate = true;
    }

    if (_workboard != null) {
      var wvIdx = _workboards.indexWhere((e) => e.name == _workboard);
      if (wvIdx >= 0) {
        _createTaskRequest.columns = [_workboards[wvIdx].id];
        needUpdate = true;
      }
    }

    if (needUpdate) _presenter.onTaskTransaction(_createTaskRequest);
  }

  FutureOr<bool> onOpen(String link) async {
    var uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
    return true;
  }

  Future<void> onObjectSearch(int action) async {
    var type = 'user';
    var title = '';
    var placeHolder = '';
    var selectionType = SearchSelectionType.single;
    var selectedBefore;

    if (_data!.object is Calendar) {
      switch (action) {
        case 0:
          type = 'user';
          title = 'Undangan';
          placeHolder = 'Pilih Undangan';
          selectionType = SearchSelectionType.multiple;
          selectedBefore = _invitees;
          break;
        case 1:
          type = 'project';
          title = 'Project';
          placeHolder = 'Pilih Project';
          selectedBefore = _projects;
          break;
        case 2:
          type = 'user';
          title = 'Subscriber';
          placeHolder = 'Pilih Subscriber';
          selectionType = SearchSelectionType.multiple;
          selectedBefore = _subscribers;
          break;
        default:
          break;
      }
    } else if (_data!.object is Ticket) {
      switch (action) {
        case 0:
          type = 'user';
          title = 'Assignee';
          placeHolder = 'Pilih Assignee';
          selectedBefore = _assignees;
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
        case 4:
          break;
        case 5:
          type = 'project';
          title = 'Project';
          placeHolder = 'Pilih Project';
          selectedBefore = _projects;
          break;
        case 6:
          type = 'user';
          title = 'Subscriber';
          placeHolder = 'Pilih Subscriber';
          selectionType = SearchSelectionType.multiple;
          selectedBefore = _subscribers;
          break;
        default:
          break;
      }
    }

    var result = await Navigator.pushNamed(context, Pages.objectSearch,
        arguments: ObjectSearchArgs(
          type,
          title: title,
          placeholderText: placeHolder,
          type: selectionType,
          selectedBefore: selectedBefore,
        ));

    if (_data!.object is Calendar) {
      switch (action) {
        case 0:
          _invitees.clear();
          _invitees.addAll(result as List<PhObject>);
          break;
        case 1:
          _projects.add(result as PhObject);
          break;
        case 2:
          _subscribers.clear();
          _subscribers.addAll(result as List<PhObject>);
          break;
        default:
          break;
      }
    } else if (_data!.object is Ticket) {
      switch (action) {
        case 0:
          _assignees.clear();
          _assignees.add(result as PhObject);
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
        case 5:
          _projects.add(result as PhObject);
          break;
        case 6:
          _subscribers.clear();
          _subscribers.addAll(result as List<PhObject>);
          break;
        default:
          break;
      }
    }
    refreshUI();
  }

  List<PhObject> getSearchResults(int action) {
    var results = List<PhObject>.empty(growable: true);
    if (_data!.object is Calendar) {
      switch (action) {
        case 0:
          results = _invitees;
          break;
        case 1:
          results = _projects;
          break;
        case 2:
          results = _subscribers;
          break;
        default:
          break;
      }
    } else if (_data!.object is Ticket) {
      switch (action) {
        case 0:
          results = _assignees;
          break;
        case 1:
          break;
        case 2:
          break;
        case 3:
          break;
        case 5:
          results = _projects;
          break;
        case 6:
          results = _subscribers;
          break;
        default:
          break;
      }
    }

    return results;
  }

  bool hasDependencies() {
    return _isHasParentTask || _isHasSubtasks;
  }

  void getRelatedTask(Ticket? ticket) {
    if (ticket!.parentTask != null || ticket.subTasks != null) {
      if (ticket.parentTask!.length > 0) {
        _parentTaskLength = ticket.parentTask!.length;
        _parentTask = ticket.parentTask!;
        _isHasParentTask = true;
      } else if (ticket.subTasks!.length > 0) {
        _subTaskLength = ticket.subTasks!.length;
        _subtask = ticket.subTasks!;
        _isHasSubtasks = true;
      } else {
        _parentTaskLength = 0;
        _isHasParentTask = false;
        _subTaskLength = 0;
        _subtask.clear();
        _isHasSubtasks = false;
      }
    }
  }

  //TODO: check if ticket has mocks
  bool hasMocks() {
    return false;
  }

  //TODO: check if ticket has duplicates
  bool hasDuplicates() {
    return false;
  }

  String parseTime(DateTime dt) {
    return _dateUtil.displayDateTimeFormat(dt);
  }

  void _forceRefresh() {
    _actionSet.clear();
    _transactions.clear();
    _commentController.clear();
    loading(true);
    load();
  }

  TextEditingController getTextController(int action) {
    var results = _spController;
    if (_data!.object is Ticket) {
      switch (action) {
        case 3:
          results = _spController;
          break;
        default:
          break;
      }
    }

    return results;
  }

  final List<String> _ticketStatuses = [
    "Open",
    "Resolved",
    "Wontfix",
    "Invalid"
  ];
  final List<String> _ticketPriorities = [
    Ticket.STATUS_UNBREAK,
    Ticket.STATUS_TRIAGE,
    Ticket.STATUS_HIGH,
    Ticket.STATUS_NORMAL,
    Ticket.STATUS_LOW,
    Ticket.STATUS_WISHLIST
  ];

  List<String> getDropdownItems(int action) {
    var results = List<String>.empty(growable: true);
    if (_data!.object is Ticket) {
      switch (action) {
        case 1:
          results = _ticketStatuses;
          break;
        case 2:
          results = _ticketPriorities;
          break;
        case 4:
          results = _workboards.map((e) => e.name).toList();
          break;
        default:
          break;
      }
    }

    return results;
  }

  String dropdownCurrentValue(int action) {
    var val = '';
    if (_data!.object is Ticket) {
      switch (action) {
        case 1:
          val = _ticketObj!.rawStatus!;
          if (_ticketStatus != null) val = _ticketStatus!;
          break;
        case 2:
          val = _ticketObj!.priority;
          if (_ticketPriority != null) val = _ticketPriority!;
          break;
        case 4:
          val = _workboards.first.name;
          if (_workboard != null) val = _workboard!;
          break;
        default:
          break;
      }
    }

    return val;
  }

  void setDropdownValue(int action, String? value) {
    if (value == null) return;
    if (_data!.object is Ticket) {
      switch (action) {
        case 1:
          _ticketStatus = value;
          break;
        case 2:
          _ticketPriority = value;
          break;
        case 4:
          _workboard = value;
          break;
        default:
          break;
      }
    }

    refreshUI();
  }

  String getCalendarStatus() {
    if (_calendarObj!.isCancelled) {
      return "Cancelled";
    } else {
      return "Active";
    }
  }

  String getCalendarPolicy() {
    return "All User";
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    reloading(true);
    switch (getArgsType()) {
      case Ticket:
        _refreshDetailTickets();
        _createTaskRequest = CreateLobbyRoomTicketApiRequest();
        break;
      case Project:
        _refreshDetailProject();
        break;
      case Stickit:
        _refreshDetailStickit();
        _createStickitRequest = CreateLobbyRoomStickitApiRequest();
        _forceRefresh();
        break;
      case Calendar:
        _refreshDetailEvent();
        _createCalendarRequest = CreateEventApiRequest();
        _forceRefresh();
        break;
      default:
        break;
    }
  }

  void showAuthorsReaction(String transactionId,
      Map<String, List<Reaction>> reactionMapList, String reactionId) {
    List<ObjectReactions> listAllReactions = [];

    listAllReactions.addAll(
        _objectReactions.where((object) => object.objectId == transactionId));

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return AuthorReactionSheet(
            reactionMapList: reactionMapList,
            listAllReactions: listAllReactions,
            reactionId: reactionId,
            userList: _userList,
          );
        });
  }

  String getProjectStatus(BuildContext context) {
    return projectObj!.isArchived
        ? S.of(context).label_archive
        : S.of(context).status_task_open;
  }

  void editProject() async {
    isChanged = true;
    var result = await Navigator.pushNamed(
      context,
      Pages.createProject,
      arguments: CreateProjectArgs(
        project: _projectObj,
        type: projectObj!.isMilestone
            ? CreateProjectType.milestoneEdit
            : CreateProjectType.projectEdit,
      ),
    );
    if (result != null || isChanged) {
      _isEditProject = true;
      reload();
      refreshUI();
    }
  }

  void addSubProject() async {
    isChanged = true;
    var result = await Navigator.pushNamed(
      context,
      Pages.createProject,
      arguments: CreateProjectArgs(
        project: _projectObj,
        type: CreateProjectType.subProject,
      ),
    );
    if (result != null && result is bool) {
      reload();
    }
  }

  void addMilestone() async {
    isChanged = true;
    var result = await Navigator.pushNamed(
      context,
      Pages.createProject,
      arguments: CreateProjectArgs(
        project: _projectObj,
        type: CreateProjectType.milestoneCreate,
      ),
    );
    if (result != null && result is bool) {
      if (result) {
        loading(true);
        reload();
      }
    }
  }

  void goToMemberPage(ProjectMemberActionType type) async {
    isChanged = true;
    var result = await Navigator.pushNamed(
      context,
      Pages.projectMember,
      arguments: ProjectMemberArgs(
        _projectObj!,
        type,
      ),
    );
    if (result != null) {
      reload();
    }
  }

  void setProjectStatus() {
    showOnLoading(context, null);
    _presenter.onSetProjectStatus(
      SetProjectStatusApiRequest(
        _projectObj!.id,
        _projectObj!.isArchived
            ? SetProjectStatusApiRequest.STATUS_ACTIVE
            : SetProjectStatusApiRequest.STATUS_ARCHIVE,
      ),
    );
  }

  String? getDisplayDateMilestone(BuildContext context) {
    if (_projectObj?.startDate == null || _projectObj?.endDate == null) {
      return null;
    }
    String format = "dd MMMM";
    String status = "";
    if (!_dateUtil
        .now()
        .isBefore(_projectObj!.endDate!.add(Duration(days: 1)))) {
      status = S.of(context).project_milestone_end;
    } else {
      status = S.of(context).project_milestone_day_left(_projectObj!.endDate!
          .add(Duration(days: 1))
          .difference(_dateUtil.now())
          .inDays);
    }
    return "${_dateUtil.format(format, _projectObj!.startDate!)} - ${_dateUtil.format(format, _projectObj!.endDate!)} ($status)";
  }

  void backPage() {
    if (_data!.from == Pages.splash) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Pages.main,
        (Route<dynamic> route) => false,
        arguments: MainArgs(Pages.splash),
      );
    } else {
      _eventBus.fire(Refresh());
      Navigator.pop(context, true);
    }
  }
}
