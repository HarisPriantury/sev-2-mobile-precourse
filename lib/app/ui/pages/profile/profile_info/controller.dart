import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_sev2/app/infrastructures/events/logout.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/events/reporting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/view.dart';
import 'package:mobile_sev2/app/ui/pages/status/args.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/api/flag/delete_flag_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/get_flags_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_user_contribution.dart';
import 'package:mobile_sev2/domain/contribution.dart';
import 'package:mobile_sev2/domain/flag.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

class ProfileController extends BaseController {
  ProfileArgs? _data;

  // properties
  ProfilePresenter _presenter;
  UserData _userData;
  DateUtilInterface _dateUtil;
  EventBus _eventBus;

  late User _user;
  Project? _team;
  Flag? _userFlag;
  DateTime _now = DateTime.now();
  List<Project> _projects = [];
  List<Ticket> _unbreakTickets = [];
  List<Ticket> _triageTickets = [];
  List<Ticket> _highTickets = [];
  List<Ticket> _normalTickets = [];
  List<Ticket> _lowTickets = [];
  List<Ticket> _wishlistTickets = [];
  List<Ticket> _ticketSummary = [];
  List<Contribution> _contributions = [];
  Map<DateTime, int> _contributionsLevel = {};
  int _totalHour = 0;
  double _totalSP = 0;
  bool _isReported = false;
  bool _isBlocked = false;

  // MARK: This is just dummy data waiting for Conduit API from BE
  User? _leraningScore = User("",
      stackoverflowScore: 388,
      hackkerrankScore: 90,
      duolingoScore: 200,
      typingSpeedScore: 65);
  User? get learningScore => _leraningScore;

  late TabController thisTabController;
  late ScrollController _thisScrollController = ScrollController();

  // getter
  ProfileArgs? get data => _data;

  bool get isReported => _isReported;

  bool get isBlocked => _isBlocked;

  User get profile => _user;

  Flag? get userFlag => _userFlag;

  DateTime get now => _now;

  UserData get userData => _userData;

  Project? get team => _team;

  DateUtilInterface get dateUtil => _dateUtil;

  List<Project> get project => _projects;

  List<Ticket> get unbreakTickets => _unbreakTickets;

  List<Ticket> get triageTickets => _triageTickets;

  List<Ticket> get highTickets => _highTickets;

  List<Ticket> get normalTickets => _normalTickets;

  List<Ticket> get lowTickets => _lowTickets;

  List<Ticket> get wishlistTickets => _wishlistTickets;

  List<Ticket> get ticketSummary => _ticketSummary;

  List<Contribution> get contributions => _contributions;

  Map<DateTime, int> get contributionsLevel => _contributionsLevel;

  ScrollController get thisScrollController => _thisScrollController;

  int get totalHour => _totalHour;

  double get totalSP => _totalSP;

  ProfileController(
    this._presenter,
    this._userData,
    this._dateUtil,
    this._eventBus,
  ) : super();

  @override
  void load() {
    if (_data?.user != null) {
      _user = _data!.user!;
      print("${_user.id} isRSP: ${_user.roles}");
      _getUserInfo();
      _getReportedUser();
    } else {
      _getProfile();
    }
  }

  @override
  void getArgs() {
    if (args != null) _data = args as ProfileArgs;
    print(_data?.toPrint());
  }

  bool isToday(DateTime date) {
    DateTime now = _dateUtil.now();
    return DateTime(date.year, date.month, date.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  // format date used in profile page
  String formatProfileDate(DateTime dt) {
    return _dateUtil.format("d/MM/y", dt);
  }

  List<String> getMonthLabels() {
    List<String> monthLabels = [""];
    DateFormat formatter = DateFormat('MMM');
    for (int i = 1; i <= 12; i++) {
      monthLabels.add(formatter.format(DateTime.utc(_now.year, i)));
    }
    return monthLabels;
  }

  List<String> getWeekDaysLabels() {
    var days = DateFormat.EEEE().dateSymbols.STANDALONENARROWWEEKDAYS;
    return days;
  }

  DateTime prevMonth() {
    return _dateUtil.from(now.year, now.month - 1, 1);
  }

  DateTime firstDate() {
    return _dateUtil.firstDate(prevMonth());
  }

  DateTime lastDate() {
    return _dateUtil.lastDate(prevMonth());
  }

  String getFirstDate() {
    DateFormat formatter = DateFormat('MMM dd yyyy');
    return formatter.format(firstDate());
  }

  String getLastDate() {
    DateFormat formatter = DateFormat('MMM dd yyyy');
    return formatter.format(lastDate());
  }

  int searchIdxOfDate(int countDay) {
    DateTime date = DateTime(
      firstDate().year,
      firstDate().month,
      firstDate().day + countDay,
    );
    return _contributions.indexWhere((val) {
      return val.epoch!.isSameDate(date);
    });
  }

  void goToSetting() {
    Navigator.pushNamed(context, Pages.setting);
  }

  void goToEditProfile() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.profileEdit,
    );
    if (result != null) {
      loading(true);
      _getProfile();
    }
  }

  void goToStatus() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.status,
      arguments: StatusArgs(newPage: true),
    );
    if (result != null) {
      loading(true);
      _getProfile();
    }
  }

  void goToProjectDetail(Project project) async {
    var result = await Navigator.pushNamed(
      context,
      Pages.projectDetail,
      arguments: DetailProjectArgs(phid: project.id, id: project.intId),
    );
    if (result != null) {
      loading(true);
      _getProjects();
    }
  }

  void goToTicketDetail(Ticket ticket) async {
    var result = await Navigator.pushNamed(
      context,
      Pages.ticketDetail,
      arguments: DetailTicketArgs(phid: ticket.id, id: ticket.intId),
    );
    if (result != null) {
      loading(true);
      _getTickets();
    }
  }

  void _getUserInfo() {
    loading(true);
    _getTickets();
    _getProjects();
    _getUserContributions();
    _getTicketSummary();
  }

  void _getTicketSummary() {
    int closedStart = firstDate().toEpoch();
    int closedEnd = _dateUtil
        .firstDate(_now)
        .subtract(Duration(
          seconds: 1,
        ))
        .toEpoch();
    _presenter.onGetTicketSummary(
      GetTicketsApiRequest(
        assigned: [_user.id],
        statuses: ['resolved'],
        closedStart: closedStart,
        closedEnd: closedEnd,
      ),
    );
  }

  void _getTickets({bool subscribed = false}) {
    if (subscribed) {
      _presenter.onGetTickets(
        GetTicketsApiRequest(
          subscribers: [_user.id],
          queryKey: GetTicketsApiRequest.QUERY_OPEN,
        ),
        subscribed,
      );
    } else {
      _presenter.onGetTickets(
        GetTicketsApiRequest(
          assigned: [_user.id],
        ),
        subscribed,
      );
    }
  }

  void _getProjects() {
    _presenter.onGetProjects(
      GetProjectsApiRequest(
        members: [_user.id],
        queryKey: GetProjectsApiRequest.QUERY_ALL,
        limit: 5,
      ),
    );
  }

  void _getProfile() {
    _presenter.onGetProfile(GetProfileApiRequest());
  }

  void _getUserContributions() {
    if (_userData.id != _user.id) {
      _presenter.onGetUserContributions(
          GetUserContributionsApiRequest(userPHID: _user.id));
    } else {
      _presenter.onGetUserContributions(GetUserContributionsApiRequest());
    }
  }

  @override
  void initListeners() {
    // get profile
    _presenter.getProfileOnNext = (User user, PersistenceType type) {
      print("profile: success getProfile $type");
      _user = user;

      // save to user data for latest data updated
      _userData.fromUser(user);
      _userData.save().then((_) {
        _getReportedUser();
      });
    };

    _presenter.getProfileOnComplete = (PersistenceType type) {
      print("profile: completed getProfile $type");
      loading(false);
      _getUserInfo();
    };

    _presenter.getProfileOnError = (e, PersistenceType type) {
      loading(false);
      print("profile: error getProfile $e $type");
    };

    _presenter.getTicketSummaryOnNext =
        (List<Ticket> tickets, PersistenceType type) {
      print("profile: success getTicketSummary $type ${tickets.length}");
      _ticketSummary.clear();
      _totalSP = 0;
      _ticketSummary.addAll(tickets);
      if (tickets.isNotEmpty) {
        _ticketSummary.forEach((ticket) {
          _totalSP += ticket.storyPoint;
        });
        refreshUI();
      }
    };

    _presenter.getTicketSummaryOnComplete = (PersistenceType type) {
      print("profile: completed getTicketSummary $type");
      loading(false);
    };

    _presenter.getTicketSummaryOnError = (e, PersistenceType type) {
      print("profile: ERROR getTicketSummary $e $type");
      loading(false);
    };

    _presenter.getTicketsOnNext =
        (List<Ticket> tickets, PersistenceType type, bool subscribed) {
      print("profile: success getTickets $type ${tickets.length} $subscribed");
      if (!subscribed) {
        _unbreakTickets.clear();
        _triageTickets.clear();
        _highTickets.clear();
        _normalTickets.clear();
        _lowTickets.clear();
        _wishlistTickets.clear();
      }

      tickets.forEach((t) {
        // t.assignee = _user;
        switch (t.priority) {
          case Ticket.STATUS_UNBREAK:
            _unbreakTickets.add(t);
            break;
          case Ticket.STATUS_TRIAGE:
            _triageTickets.add(t);
            break;
          case Ticket.STATUS_HIGH:
            _highTickets.add(t);
            break;
          case Ticket.STATUS_NORMAL:
            _normalTickets.add(t);
            break;
          case Ticket.STATUS_LOW:
            _lowTickets.add(t);
            break;
          case Ticket.STATUS_WISHLIST:
            _wishlistTickets.add(t);
            break;
          default:
        }
      });
    };

    _presenter.getTicketsOnComplete = (PersistenceType type, bool subscribed) {
      print("profile: completed getTickets $type");
      if (subscribed)
        loading(false);
      else {
        loading(false);
        _getTickets(subscribed: true);
      }
    };

    _presenter.getTicketsOnError = (e, PersistenceType type, bool subscribed) {
      print("profile: ERROR getTickets $e $type");
      loading(false);
    };

    _presenter.getProjectsOnNext = (List<Project> projects) {
      print("profile: success getProjects");
      _projects.clear();
      _projects.addAll(projects);
    };

    _presenter.getProjectsOnComplete = () {
      print("profile: completed getProjects");
      _projects.forEach((element) {
        if (element.isGroup) {
          _team = element;
          return;
        }
      });
      loading(false);
    };

    _presenter.getProjectsOnError = (e) {
      loading(false);
      print("profile: error getProjects: $e");
    };

    _presenter.getUserContributionsOnNext = (List<Contribution> contributions) {
      print("profile: success getUserContributions ");
      _totalHour = 0;
      _contributions.clear();
      _contributions.addAll(contributions);
      if (_contributions.isNotEmpty) {
        int dayCheck = 0;
        int rangeDay = lastDate().day;
        int idxOfDate = -1;

        for (; dayCheck < rangeDay; dayCheck++) {
          idxOfDate = searchIdxOfDate(dayCheck);
          _totalHour += idxOfDate >= 0 ? _contributions[idxOfDate].hours! : 0;
        }

        _contributions.forEach((contribution) {
          _contributionsLevel[_dateUtil.removeTime(contribution.epoch!)] =
              contribution.level!;
        });
      }
      refreshUI();
    };

    _presenter.getUserContributionsOnComplete = () {
      loading(false);
      print("profile: complete getUserContributions");
    };

    _presenter.getUserContributionsOnError = (e) {
      loading(false);
      print("profile: error getUserContributions $e");
    };

    _eventBus.on<Refresh>().listen((event) {
      loading(true);
      load();
    });

    _eventBus.on<ReportingSuccess>().listen((event) {
      if (event.objectPHID == _user.id) {
        _isBlocked = true;
        _isReported = true;
        refreshUI();
      }
    });

    _presenter.getFlagsOnNext = (List<Flag> result, PersistenceType type) {
      if (result.isNotEmpty) {
        _userFlag = result.first;
        if (result.first.ownerPHID == _userData.id) {
          _isBlocked = true;
        }
        _isReported = true;
        refreshUI();
      }
    };
    _presenter.getFlagsOnComplete = (PersistenceType type) {
      loading(false);
    };
    _presenter.getFlagsOnError = (e) {
      loading(false);
    };

    _presenter.deleteFlagOnNext = (bool? result, PersistenceType type) {
      if (result == true) {
        _isBlocked = false;
        _isReported = false;
        refreshUI();
      }
    };
    _presenter.deleteFlagOnComplete = (PersistenceType type) {
      loading(false);
    };
    _presenter.deleteFlagOnError = (e, PersistenceType type) {
      loading(false);
    };
  }

  void logout() async {
    showOnLoading(context, "Log out...");
    await DataUtil.clearDb();
    await _userData.clear();
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
      context,
      Pages.publicSpace,
      (_) => false,
    );
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    _projects.clear();
    load();
  }

  void reportUser() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments: ReportArgs(phId: _user.id, reportedType: "USER"),
          );
        });
  }

  void undoReportUser(Flag? _flag) {
    if (_flag != null) {
      _presenter.onDeleteFlag(DeleteFlagApiRequest(
          flagId: int.tryParse(_flag.id), objectPHID: _flag.objectPHID ?? ""));
    }
  }

  void _getReportedUser() {
    _presenter.onGetFlags(
      GetFlagsApiRequest(types: ['USER'], objectPHIDs: ['${_data?.user?.id}']),
    );
  }
}
