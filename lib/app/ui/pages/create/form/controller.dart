import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_stickit_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

class CreateController extends BaseController {
  CreatePresenter _presenter;
  DateUtilInterface _dateUtil;
  EventBus _eventBus;
  CreateArgs? _data;
  UserData _userData;

  // create transaction request
  CreateEventApiRequest _createCalendarRequest = CreateEventApiRequest();
  CreateLobbyRoomStickitApiRequest _createStickitRequest =
      CreateLobbyRoomStickitApiRequest();
  CreateLobbyRoomTicketApiRequest _createTaskRequest =
      CreateLobbyRoomTicketApiRequest();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _storyPointsController =
      new TextEditingController(); // ticket

  // calendar
  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  TextEditingController _startTimeController = new TextEditingController();
  TextEditingController _endTimeController = new TextEditingController();

  // populate data from args to fill form
  Room? _room;
  Stickit? _stickitObj;
  Ticket? _ticketObj;
  Calendar? _calendarObj;
  Project? _projectObj;
  String? _columnId;
  List<PhObject> _subscribers = [];
  List<PhObject> _visibleTo = [];
  List<PhObject> _editableBy = [];
  List<PhObject> _projects = [];
  List<PhObject> _formerSubscribers = [];
  bool _isValidated = false;
  bool _isProcessing = false;
  bool _isSubTask = false;
  bool _isValidatedTextField = false;
  bool _validateTitle = false;
  bool _validateDesc = false;
  bool _validateDropDown = false;
  bool _validateDate = false;
  String? _space;
  String _objectIdentifier = "";

  // Stickit
  String? _stickitType;
  final List<String> stickitTypeList = [
    "Announcement",
    "Pitch an Idea",
    "Praise",
    "Minutes of Meeting"
  ];

  // Ticket, get this info from [Ticket] if the object is not null
  User? _assignee;
  String? _ticketStatus;
  String? _ticketReportedBy;
  String? _ticketPriority;
  final Map<String, String> ticketStatuses = {
    "Open": "Open",
    "Resolved": "Resolved",
    "Wontfix": "Wontfix",
    "Invalid": "Invalid"
  };
  final Map<String, String> ticketPriorities = {
    Ticket.STATUS_UNBREAK: Ticket.STATUS_UNBREAK,
    Ticket.STATUS_TRIAGE: Ticket.STATUS_TRIAGE,
    Ticket.STATUS_HIGH: Ticket.STATUS_HIGH,
    Ticket.STATUS_NORMAL: Ticket.STATUS_NORMAL,
    Ticket.STATUS_LOW: Ticket.STATUS_LOW,
    Ticket.STATUS_WISHLIST: Ticket.STATUS_WISHLIST
  };
  final List<String> ticketReports = [
    "Internal",
    "External",
  ];

  // Calendar, get this info from [Calendar] if the object is not null
  List<PhObject> _participants = [];
  bool _isAllDay = false;
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  CreateController(
    this._presenter,
    this._dateUtil,
    this._eventBus,
    this._userData,
  );

  CreateArgs? get data => _data;

  Type get argsType => _data!.type;

  Stickit? get stickitObj => _stickitObj;

  Ticket? get ticketObj => _ticketObj;

  Calendar? get calendarObj => _calendarObj;

  Project? get projectObj => _projectObj;

  String? get columnId => _columnId;

  TextEditingController get titleController => _titleController;

  TextEditingController get descriptionController => _descriptionController;

  List<PhObject> get subscribers => _subscribers;

  List<PhObject> get visibleTo => _visibleTo;

  List<PhObject> get editableBy => _editableBy;

  List<PhObject> get label => _projects;

  bool get isValidated => _isValidated;

  bool get isProcessing => _isProcessing;

  bool get isSubTask => _isSubTask;

  bool get isValidatedTextField => _isValidatedTextField;

  bool get validateTitle => _validateTitle;

  bool get validateDesc => _validateDesc;

  bool get validateDropDown => _validateDropDown;

  bool get validateDate => _validateDate;

  DateUtilInterface get dateUtil => _dateUtil;

  // identifier
  String get objectIdentifier => _objectIdentifier;

  // stickit
  String? get stickitType => _stickitType;

  // ticket
  User? get assignee => _assignee;

  String? get ticketStatus => _ticketStatus;

  String? get ticketReportedBy => _ticketReportedBy;

  String? get ticketPriority => _ticketPriority;

  TextEditingController get storyPointsController => _storyPointsController;

  // calendar
  List<PhObject> get participants => _participants;

  TextEditingController get startDateController => _startDateController;

  TextEditingController get endDateController => _endDateController;

  TextEditingController get startTimeController => _startTimeController;

  TextEditingController get endTimeController => _endTimeController;

  DateTime? get startDate => _startDate;

  TimeOfDay? get startTime => _startTime;

  bool get isAllDay => _isAllDay;

  @override
  void getArgs() {
    if (args != null) {
      _data = args as CreateArgs;
      _isSubTask = _data!.isSubTask;
      if (_data!.object != null) {
        if (_data!.type == Stickit)
          _stickitObj = _data!.object as Stickit;
        else if (_data!.type == Ticket)
          _ticketObj = _data!.object as Ticket;
        else if (_data!.type == Calendar) {
          _calendarObj = _data!.object as Calendar;
        } else if (_data!.type == Project) {
          _projectObj = _data!.object as Project;
          _projects.add(_projectObj!);
        }
      }

      if (_data!.room != null) {
        _room = _data!.room;
      }

      if (_data!.columnId != null) {
        _columnId = _data!.columnId;
      }
    }
  }

  @override
  void load() {
    if (_stickitObj != null) {
      _objectIdentifier = _stickitObj?.id ?? "";
      _stickitType = Stickit.getKeyFromType(_stickitObj?.type ?? "");
      _titleController.text = _stickitObj?.name ?? "";
      _descriptionController.text = _stickitObj?.plainContent ?? "";
    } else if (_calendarObj != null) {
      _objectIdentifier = _calendarObj?.id ?? "";
      _titleController.text = _calendarObj?.name ?? "";
      setCalendarStartDate(_calendarObj!.startTime);
      setCalendarStartTime(TimeOfDay.fromDateTime(_calendarObj!.startTime));
      setCalendarEndDate(_calendarObj!.endTime);
      setCalendarEndTime(TimeOfDay.fromDateTime(_calendarObj!.endTime));
      _participants.addAll(_calendarObj!.invitees!);
      if (_calendarObj!.subcribersPhid?.isNotEmpty ?? false) {
        _presenter.onGetUsers(
            GetUsersApiRequest(ids: _calendarObj!.subcribersPhid),
            "subscribers");
      }
      _isAllDay = _calendarObj?.isAllDay ?? false;
      _descriptionController.text = _calendarObj?.description ?? "";
    } else if (_ticketObj != null) {
      if (_isSubTask) {
        if (_ticketObj?.project != null)
          _projects = [_ticketObj?.project as PhObject];
      } else {
        _objectIdentifier = _ticketObj?.id ?? "";
        _titleController.text = _ticketObj?.name ?? "";
        _assignee = _ticketObj?.assignee;
        _ticketStatus = _ticketObj?.rawStatus;

        _ticketPriority = _ticketObj?.priority;
        _storyPointsController.text = (_ticketObj?.storyPoint ?? "").toString();
        _descriptionController.text = _ticketObj?.description ?? "";
        if (_ticketObj?.projectList != null) {
          loading(true);
          List<String> phids = [];
          _ticketObj!.projectList!.forEach((element) {
            phids.add(element.id);
          });
          _presenter.onGetObjects(GetObjectsApiRequest(phids));
        }
      }
    }

    validate();
  }

  @override
  void initListeners() {
    _presenter.createCalendarOnNext = (bool result) {
      print("create: success createCalendar");
    };

    _presenter.createCalendarOnComplete = () {
      print("create: completed createCalendar");
      _closeAndRefreshPage();
    };

    _presenter.createCalendarOnError = (e) {
      loading(false);
      print("create: error createCalendar: $e");
    };

    _presenter.createStickitOnNext = (bool result) {
      print("create: success createStickit");
    };

    _presenter.createStickitOnComplete = () {
      print("create: completed createStickit");
      _closeAndRefreshPage();
    };

    _presenter.createStickitOnError = (e) {
      loading(false);
      print("create: error.createStickit: $e");
      Navigator.pop(context);
      showNotif(context, "Something went wrong");
    };

    _presenter.createTaskOnNext = (bool result) {
      print("create: success createTask");
    };

    _presenter.createTaskOnComplete = () {
      print("create: completed createTask");
      if (_ticketObj != null && !_data!.isCreateTicketFromMain)
        Navigator.pop(context);
      _closeAndRefreshPage();
    };

    _presenter.createTaskOnError = (e) {
      loading(false);
      print("create: error createTask: $e");
    };

    _presenter.getUsersOnNext =
        (List<User> users, PersistenceType type, String role) {
      print("create: success getUsers $type $role, ${users.length}");
      _formerSubscribers.clear();
      _formerSubscribers.addAll(users);
      _subscribers = _formerSubscribers;
      refreshUI();
    };
    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("create: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      loading(false);
      print("create: error getUsers: $e $type");
    };

    _presenter.getObjectsOnNext =
        (List<PhObject> objects, PersistenceType type) {
      _projects = objects;
    };

    _presenter.getObjectsOnComplete = (PersistenceType type) {
      print("create: completed getObjects $type");
      loading(false);
    };

    _presenter.getObjectsOnError = (e, PersistenceType type) {
      print("create: error getObjects: $e $type");
      loading(false);
    };
  }

  void _closeAndRefreshPage() {
    _eventBus.fire(Refresh());

    if (_stickitObj != null) {
      Navigator.pop(context);
      Navigator.pop(context, _stickitObj);
    } else if (_calendarObj != null) {
      Navigator.pop(context);
      Navigator.pop(context, _calendarObj);
    } else if (_ticketObj != null) {
      Navigator.pop(context, _ticketObj);
    } else if (_projectObj != null) {
      Navigator.pop(context);
      Navigator.pop(context, _projectObj);
    } else {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> onSearchSubscribers() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        'user',
        title: S.of(context).label_subscriber,
        placeholderText: S.of(context).create_form_subscribers_select,
        selectedBefore: _subscribers,
      ),
    );

    if (result != null) {
      _subscribers.clear();
      _subscribers.addAll(result as List<PhObject>);
      refreshUI();
    }
  }

  Future<void> onSearchProjects() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        'project',
        title: S.of(context).label_tag,
        placeholderText: S.of(context).create_form_tags_select,
        selectedBefore: _projects,
      ),
    );

    if (result != null) {
      _projects.clear();
      _projects = result as List<PhObject>;
      validate();
      refreshUI();
    }
  }

  Future<void> onChangeVisibility() async {
    var result = await Navigator.pushNamed(context, Pages.policy,
        arguments: PolicyArgs(type: PolicyType.visible));
    if (result != null) {
      var data = result as PolicyArgs;
      _visibleTo.clear();
      _visibleTo.add(PhObject(data.policy!.value,
          name: data.policy!.title, fullName: data.policy!.title));

      if (data.space != null) {
        _space = 'PHID-SPCE-walzsiv5l4numifcxrjb'; // default space
      }
      _space = data.space?.id;
    }
    refreshUI();
  }

  Future<void> onChangeEditability() async {
    var result = await Navigator.pushNamed(context, Pages.policy,
        arguments: PolicyArgs(type: PolicyType.editable));
    if (result != null) {
      var data = result as PolicyArgs;
      _editableBy.clear();
      _editableBy.add(PhObject(data.policy!.value,
          name: data.policy!.title, fullName: data.policy!.title));
    }
    refreshUI();
  }

  void onStickitTypeChanged(String? newValue) {
    _stickitType = newValue;
    refreshUI();
  }

  void onTicketStatusChanged(String? newValue) {
    _ticketStatus = newValue;
    validate();
    refreshUI();
  }

  void onTicketReportChanged(String? newValue) {
    _ticketReportedBy = newValue;
    validate();
    refreshUI();
  }

  void onTicketPriorityChanged(String? newValue) {
    _ticketPriority = newValue;
    validate();
    refreshUI();
  }

  Future<void> onSearchTicketAssignee() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        'user',
        title: S.of(context).create_form_assignation_label,
        placeholderText: S.of(context).create_form_assignee_label,
        type: SearchSelectionType.single,
        selectedBefore: _assignee != null ? [_assignee!] : null,
      ),
    );

    if (result != null) {
      _assignee = result as User;
      validate();
      refreshUI();
    }
  }

  void setCalendarStartDate(DateTime date) {
    _startDateController.text = _dateUtil.basicDateFormat(date);
    _startDate = date;
    validate();
    refreshUI();
  }

  void setCalendarEndDate(DateTime date) {
    _endDateController.text = _dateUtil.basicDateFormat(date);
    _endDate = date;
    validate();
    refreshUI();
  }

  void setCalendarStartTime(TimeOfDay time) {
    var now = _startDate ?? _dateUtil.now();
    var dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    _startTimeController.text = _dateUtil.basicTimeFormat(dt);
    _startTime = time;
    validate();
    refreshUI();
  }

  void setCalendarEndTime(TimeOfDay time) {
    var now = _endDate ?? _dateUtil.now();
    var dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    endTimeController.text = _dateUtil.basicTimeFormat(dt);
    _endTime = time;
    validate();
    refreshUI();
  }

  void onSelectedAllDay() {
    _isAllDay = !_isAllDay;
    validate();
    refreshUI();
  }

  Future<void> onSearchCalendarParticipants() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        'user',
        title: S.of(context).create_form_participants_label,
        placeholderText: S.of(context).create_form_participants_select,
        type: SearchSelectionType.multiple,
        selectedBefore: _participants,
      ),
    );
    if (result != null) {
      _participants.clear();
      _participants = result as List<PhObject>;
      refreshUI();
    }
  }

  void validate() {
    if (argsType == Stickit) {
      _isValidated = _stickitType != null &&
          _titleController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty;
    } else if (argsType == Calendar) {
      _isValidated = _titleController.text.isNotEmpty &&
          _startDateController.text.isNotEmpty &&
          _endDateController.text.isNotEmpty &&
          _descriptionController.text.isNotEmpty;
    } else if (argsType == Ticket || argsType == Project) {
      _isValidated = _titleController.text.isNotEmpty &&
          _ticketPriority != null &&
          _descriptionController.text.isNotEmpty;
    } else {
      _isValidated = false;
    }
    refreshUI();
  }

  void validateOnTap() {
    if (argsType == Stickit) {
      if (_stickitType == null) {
        _validateDropDown = true;
      }
      if (titleController.text.isNotEmpty) {
        _validateTitle = true;
      }
      if (_descriptionController.text.isNotEmpty) {
        _validateDesc = true;
      }
    } else if (argsType == Calendar) {
      if (titleController.text.isNotEmpty) {
        _validateTitle = true;
      }
      if (_startDateController.text.isNotEmpty) {
        _validateDate = true;
      }
      if (_endDateController.text.isNotEmpty) {
        _validateDate = true;
      }
      if (_descriptionController.text.isNotEmpty) {
        _validateDesc = true;
      }
    } else if (argsType == Ticket || argsType == Project) {
      if (titleController.text.isNotEmpty) {
        _validateTitle = true;
      }
      if (_ticketPriority == null) {
        _validateDropDown = true;
      }
      if (_descriptionController.text.isNotEmpty) {
        _validateDesc = true;
      }
      _isValidated = true;
    } else {
      _isValidated = false;
      _validateTitle = false;
      _validateDesc = false;
      _validateDropDown = false;
      _validateDate = false;
    }
    refreshUI();
  }

  void onCreateTransaction() {
    showOnLoading(context, "Loading...");
    _isProcessing = true;
    refreshUI();

    if (argsType == Stickit) {
      _createStickitRequest.noteType = Stickit.getTypeKey(_stickitType!);
      _createStickitRequest.title = _titleController.text;
      _createStickitRequest.content = _descriptionController.text;

      if (_room != null) {
        _createStickitRequest.setRoomIds = [_room!.id];
      }

      if (_objectIdentifier.isNotEmpty) {
        _createStickitRequest.objectIdentifier = _objectIdentifier;
      }

      // returned to detail
      _stickitObj?.name = _createStickitRequest.title;
      _stickitObj?.plainContent = _createStickitRequest.content ?? "";
      _stickitObj?.stickitType = _createStickitRequest.noteType!;
      _stickitObj?.htmlContent = _createStickitRequest.content ?? "";

      _presenter.onCreateStickit(_createStickitRequest);
    } else if (argsType == Project) {
      _createTaskRequest.title = _titleController.text;
      _createTaskRequest.point =
          double.tryParse(_storyPointsController.text) ?? 0;
      _createTaskRequest.description = _descriptionController.text;
      _createTaskRequest.assigneeId = _assignee?.id;
      _createTaskRequest.setSubscriberIds =
          _subscribers.map((e) => e.id).toList();
      _createTaskRequest.status = _ticketStatus?.toLowerCase();
      _createTaskRequest.priority = Ticket.getPriorityKey(_ticketPriority!);
      _createTaskRequest.setProjectIds = _projects.map((e) => e.id).toList();

      if (_room != null) {
        _createTaskRequest.setRoomIds = [_room!.id];
      }

      // view policy
      if (_visibleTo.isNotEmpty) {
        _createTaskRequest.viewPolicy = _visibleTo.first.id;
      }

      if (_space != null) {
        _createTaskRequest.space = _space;
      }

      // edit policy
      if (_editableBy.isNotEmpty) {
        _createTaskRequest.editPolicy = _editableBy.first.id;
      }

      if (_objectIdentifier.isNotEmpty) {
        _createTaskRequest.objectIdentifier = _objectIdentifier;
      }

      if (argsType == Project) {
        _createTaskRequest.setProjectIds = [_projectObj!.id];
      }

      if (_columnId != null) {
        _createTaskRequest.columns = [_columnId!];
      }

      if (_isSubTask) {
        _createTaskRequest.parentId = _ticketObj!.id;
      }

      // returning value
      _ticketObj?.name = _createTaskRequest.title;
      _ticketObj?.assignee = _assignee;
      _ticketObj?.status = _ticketStatus;
      _ticketObj?.priority =
          Ticket.getLabelFromKey(_createTaskRequest.priority ?? "");
      _ticketObj?.storyPoint = _createTaskRequest.point ?? 0;
      _ticketObj?.description = _createTaskRequest.description ?? "";

      _presenter.onCreateTask(_createTaskRequest);
    } else if (argsType == Ticket) {
      _createTaskRequest.title = _titleController.text;
      _createTaskRequest.point =
          double.tryParse(_storyPointsController.text) ?? 0;
      _createTaskRequest.description = _descriptionController.text;
      _createTaskRequest.assigneeId = _assignee?.id;
      _createTaskRequest.setSubscriberIds =
          _subscribers.map((e) => e.id).toList();
      _createTaskRequest.status = _ticketStatus?.toLowerCase();
      if (_data?.taskType == TaskType.bug) {
        _createTaskRequest.reportedBy =
            'bug:reported-by:$_ticketReportedBy'.toLowerCase();
        _createTaskRequest.subtype = "bug";
      } else if (_data?.taskType == TaskType.spike) {
        _createTaskRequest.subtype = "spike";
      } else {
        _createTaskRequest.subtype = "default";
      }
      _createTaskRequest.priority = Ticket.getPriorityKey(_ticketPriority!);
      _createTaskRequest.setProjectIds = _projects.map((e) => e.id).toList();

      if (_room != null) {
        _createTaskRequest.setRoomIds = [_room!.id];
      }

      // view policy
      if (_visibleTo.isNotEmpty) {
        _createTaskRequest.viewPolicy = _visibleTo.first.id;
      }

      if (_space != null) {
        _createTaskRequest.space = _space;
      }

      // edit policy
      if (_editableBy.isNotEmpty) {
        _createTaskRequest.editPolicy = _editableBy.first.id;
      }

      if (_objectIdentifier.isNotEmpty) {
        _createTaskRequest.objectIdentifier = _objectIdentifier;
      }

      if (argsType == Project) {
        _createTaskRequest.setProjectIds = [_projectObj!.id];
      }

      if (_columnId != null) {
        _createTaskRequest.columns = [_columnId!];
      }

      if (_isSubTask) {
        _createTaskRequest.parentId = _ticketObj!.id;
      }

      // returning value
      _ticketObj?.name = _createTaskRequest.title;
      _ticketObj?.assignee = _assignee;
      _ticketObj?.status = _ticketStatus;
      _ticketObj?.priority =
          Ticket.getLabelFromKey(_createTaskRequest.priority ?? "");
      _ticketObj?.storyPoint = _createTaskRequest.point ?? 0;
      _ticketObj?.description = _createTaskRequest.description ?? "";

      _presenter.onCreateTask(_createTaskRequest);
    } else if (argsType == Calendar) {
      _createCalendarRequest.name = _titleController.text;
      _createCalendarRequest.isAllDay = isAllDay;

      if (_isAllDay) {
        _createCalendarRequest.start = (DateTime(_startDate!.year,
                        _startDate!.month, _startDate!.day, 0, 0, 0)
                    .millisecondsSinceEpoch /
                1000)
            .ceil();
        _createCalendarRequest.end =
            (DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 0, 0, 0)
                        .millisecondsSinceEpoch /
                    1000)
                .ceil();
      } else {
        _createCalendarRequest.start = (DateTime(
                  _startDate!.year,
                  _startDate!.month,
                  _startDate!.day,
                  _startTime!.hour,
                  _startTime!.minute,
                  0,
                ).millisecondsSinceEpoch /
                1000)
            .ceil();
        _createCalendarRequest.end = (DateTime(
                  _endDate!.year,
                  _endDate!.month,
                  _endDate!.day,
                  _endTime!.hour,
                  _endTime!.minute,
                  0,
                ).millisecondsSinceEpoch /
                1000)
            .ceil();
      }
      // check authorIsParticipant
      bool authorIsParticipant =
          _participants.any((par) => par.id == _userData.id);
      if (!authorIsParticipant) _participants.add(_userData.toUser());
      _createCalendarRequest.invitees = _participants.map((e) => e.id).toList();
      _createCalendarRequest.setProjectIds =
          _projects.map((e) => e.id).toList();

      // check authorIsSubcriber
      bool authorIsSubcriber =
          _subscribers.any((sub) => sub.id == _userData.id);
      if (!authorIsSubcriber) _subscribers.add(_userData.toUser());
      _createCalendarRequest.setSubscriberIds =
          _subscribers.map((e) => e.id).toList();

      _createCalendarRequest.description = _descriptionController.text;
      _createCalendarRequest.setProjectIds =
          _projects.map((e) => e.id).toList();

      if (_room != null) {
        _createCalendarRequest.setRoomIds = [_room!.id];
      }

      // view policy
      if (_visibleTo.isNotEmpty) {
        _createCalendarRequest.viewPolicy = _visibleTo.first.id;
      }

      if (_space != null) {
        _createCalendarRequest.space = _space;
      }

      // edit policy
      if (_editableBy.isNotEmpty) {
        _createCalendarRequest.editPolicy = _editableBy.first.id;
      }

      if (_objectIdentifier.isNotEmpty) {
        _createCalendarRequest.objectIdentifier = _objectIdentifier;
      }

      _presenter.onCreateCalendar(_createCalendarRequest);

      // returned to detail
      _calendarObj?.name = _createCalendarRequest.name;
      _calendarObj?.startTime =
          _dateUtil.fromSeconds(_createCalendarRequest.start ?? 0);
      _calendarObj?.endTime =
          _dateUtil.fromSeconds(_createCalendarRequest.end ?? 0);
      _participants.forEach((p) {
        if (_calendarObj?.invitees != null) {
          if (!_calendarObj!.invitees!.contains(p)) {
            _calendarObj?.invitees?.add(User(p.id,
                name: p.name, fullName: p.fullName, avatar: p.avatar));
          }
        }
      });
      _calendarObj?.isAllDay = _createCalendarRequest.isAllDay ?? false;
      _calendarObj?.description = _createCalendarRequest.description ?? "";
    }
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
