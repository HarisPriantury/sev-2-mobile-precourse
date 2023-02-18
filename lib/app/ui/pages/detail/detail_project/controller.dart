import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/args.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/view.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/set_project_status_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:url_launcher/url_launcher.dart';

import 'presenter.dart';

class DetailProjectController extends SheetController {
  bool _isExpandDescription = false;

  DetailProjectPresenter _presenter;
  DetailProjectArgs? _data;
  DateUtilInterface _dateUtil;
  UserData _userData;
  EventBus _eventBus;

  Project? _projectObj;
  List<PhTransaction> _transactions = [];

  List<Project> _subProjects = [];
  List<Project> _milestones = [];

  // project status
  bool _isForRsp = false;
  bool _isForDev = false;
  bool _isArchived = false;
  bool isChanged = true;
  bool _isEditProject = false;
  String? _projectStatus;

  DetailProjectController(
    this._presenter,
    this._userData,
    this._dateUtil,
    this._eventBus,
  );

  bool get isExpandDescription => _isExpandDescription;

  DateUtilInterface get dateUtil => _dateUtil;

  DetailProjectArgs? get data => _data;

  Project? get projectObj => _projectObj;

  UserData get userData => _userData;

  List<Project> get subProjects => _subProjects;

  List<Project> get milestones => _milestones;

  List<PhTransaction>? get transactions => _transactions;

  bool get isForRsp => _isForRsp;

  bool get isForDev => _isForDev;

  bool get isArchived => _isArchived;

  String? get projectStatus => _projectStatus;

  void onExpandDescription() {
    _isExpandDescription = !_isExpandDescription;
    refreshUI();
  }

  void _refreshDetailProject() {
    _presenter.onGetProjects(GetProjectsApiRequest(ids: [data!.phid!]));
    loading(true);
  }

  void goToDetailProject(Project project) async {
    isChanged = true;
    var result = await Navigator.pushNamed(
      context,
      Pages.projectDetail,
      arguments: DetailProjectArgs(phid: project.id),
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
    _refreshDetailProject();

    getTransaction();
  }

  void getTransaction() {
    _presenter.onGetTransactions(
      GetObjectTransactionsApiRequest(
        identifier: _data?.phid,
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
      _data = args as DetailProjectArgs;
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
      _projectObj?.members?.clear();
      _projectObj?.members?.addAll(users);
      // _projectObj?.members = users;
      refreshUI();
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("detail: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      print("detail: error getUsers: $e $type");
      loading(false);
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
    };

    _presenter.getTransactionsOnComplete = (PersistenceType type) {
      print("detail: completed getTransactions $type");
    };

    _presenter.getTransactionsOnError = (e, PersistenceType type) {
      print("detail: error getTransactions: $e $type");
      loading(false);
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
      print("detail: error getObjects: $e $type");
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
      print("detail: error setProjectStatus: $e");
      Navigator.pop(context);
      showNotif(context, "Something went wrong");
      loading(false);
      refreshUI();
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

  bool isAuthor() {
    return _projectObj!.members!
            .indexWhere((element) => element.id == _userData.id) >
        -1;
  }

  Future<void> onOpen(String link) async {
    Uri uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }

  String parseTime(DateTime dt) {
    return _dateUtil.displayDateTimeFormat(dt);
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    reloading(true);
    _refreshDetailProject();
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

  void reportProject() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments: ReportArgs(
                phId: _projectObj?.id ?? "", reportedType: "PROJECT"),
          );
        });
  }
}
