import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/args.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/create_milestone_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/create_project_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/project.dart';

class CreateProjectController extends BaseController {
  CreateProjectArgs? _data;
  CreateProjectPresenter _presenter;
  UserData _userData;
  DateUtilInterface _dateUtil;
  EventBus _eventBus;
  late CreateProjectType _type;

  // create transaction request
  CreateProjectApiRequest _createProjectRequest = CreateProjectApiRequest();

  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  Project? _projectObj;

  /// milestone
  DateTime? _startDate;
  DateTime? _endDate;

  TextEditingController _startDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();

  bool _validateDate = false;

  /// end milestone

  List<PhObject> _projects = [];
  List<String> _accessibility = ["Public", "Private"];
  List<String> _accessibilityDescription = [
    "Siapa saja di jaringan dapat melihat di project, tetapi\nhanya anggota grup memiliki akses ke project ini",
    "Hanya anggota grup yang dapat melihat, mengakses,\ndan berpartisipasi di dalam project ini."
  ];
  bool _isValidated = false,
      _isProcessing = false,
      _validateTitle = false,
      _validateDesc = false,
      _isFromDetailProject = false;

  String? _objectIdentifier;
  String _selectedAccessibility = "";

  CreateProjectController(
    this._presenter,
    this._userData,
    this._dateUtil,
    this._eventBus,
  );

  Project? get projectObj => _projectObj;

  CreateProjectType get type => _type;

  TextEditingController get titleController => _titleController;

  TextEditingController get descriptionController => _descriptionController;

  TextEditingController get startDateController => _startDateController;

  TextEditingController get endDateController => _endDateController;

  bool get validateDate => _validateDate;

  DateTime? get startDate => _startDate;

  List<PhObject> get label => _projects;

  List<String> get accessibility => _accessibility;

  List<String> get accessibilityDescription => _accessibilityDescription;

  bool get isValidated => _isValidated;

  bool get isProcessing => _isProcessing;

  bool get validateTitle => _validateTitle;

  bool get validateDesc => _validateDesc;

  DateUtilInterface get dateUtil => _dateUtil;

  //identifier
  String? get objectIdentifier => _objectIdentifier;

  String get selectedAccessibility => _selectedAccessibility;

  @override
  void getArgs() {
    if (args != null) {
      _data = args as CreateProjectArgs;
      _type = _data!.type;
      _projectObj = _data!.project;
      _objectIdentifier = _data?.project?.id ?? "";
      if (_type == CreateProjectType.projectEdit) {
        _titleController.text = _data?.project?.name ?? "";
        _descriptionController.text = _data?.project?.description ?? "";
        if (_data?.project?.viewPolicy == "users") {
          _selectedAccessibility = "Public";
        } else {
          _isFromDetailProject = true;
          _presenter.onGetProjects(GetProjectsApiRequest(
              ids: [_data!.project!.editPolicy], limit: 1));
          _selectedAccessibility = "Private";
        }
      } else if (_type == CreateProjectType.milestoneEdit) {
        _titleController.text = _data?.project?.name ?? "";
        _descriptionController.text = _data?.project?.description ?? "";
        _startDateController.text =
            _dateUtil.basicDateFormat(_data!.project!.startDate!);
        _startDate = _data!.project!.startDate!;
        _endDateController.text =
            _dateUtil.basicDateFormat(_data!.project!.endDate!);
        _endDate = _data!.project!.endDate!;
      }
    } else {
      _type = CreateProjectType.projectCreate;
    }
  }

  @override
  void load() {}

  @override
  void initListeners() {
    _presenter.createProjectOnNext = (BaseApiResponse resp) {
      print("create: success createProject");
      _presenter
          .onGetProjects(GetProjectsApiRequest(ids: [resp.result], limit: 1));
    };

    _presenter.createProjectOnComplete = () {
      print("create: completed createProject");
    };

    _presenter.createProjectOnError = (e) {
      Navigator.pop(context);
      print("create: error createProject: $e");
    };

    _presenter.getProjectsOnNext = (List<Project> projects, String type) {
      print("get project: success getRooms, $_type");
      if (_data != null && _isFromDetailProject) {
        _projects = projects;
        _isFromDetailProject = false;
        refreshUI();
      } else if (_data != null && !_isFromDetailProject) {
        // navigate user to edited project
        refreshUI();
        if (_type == CreateProjectType.projectEdit) {
          Navigator.pop(context);
          Navigator.pop(context);
          _moveToDetailProject(projects.first);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          _moveToDetailProject(projects.first);
        }
      } else {
        // navigate user to newly created project
        Navigator.pop(context);
        Navigator.pop(context);
        // _moveToDetailProject(projects.first);
        showActionSnackbar(
          context,
          S.of(context).project_created_successfully,
        );
      }
      if (_type == CreateProjectType.subProject) {
        _moveToDetailProject(projects.first);
      }
    };
    _presenter.getProjectsOnComplete = () {
      print("get project: completed getRooms");
    };

    _presenter.getProjectsOnError = (e) {
      Navigator.pop(context);
      print("get project: error getRooms $e");
    };

    _presenter.createMilestoneOnNext = (BaseApiResponse resp) {
      print("create: success createMilestone ${resp.result}");
      // _presenter
      //     .onGetProjects(GetProjectsApiRequest(ids: [resp.result], limit: 1));
      if (resp.result.contains('same hashtag')) {
        Navigator.pop(context);
        _isProcessing = false;
        showNotif(context,
            '${_titleController.text} ${S.of(context).already_in_use}');
      } else {
        Navigator.pop(context);
        Navigator.of(context).pop(true);
      }
    };

    _presenter.createMilestoneOnComplete = () {
      print("create: completed createMilestone");
    };

    _presenter.createMilestoneOnError = (e) {
      Navigator.pop(context);

      print("create: error createMilestone: $e");
    };
  }

  void validate() {
    bool _isValid = false;
    if (isMilestone()) {
      _isValid = _startDateController.text.isNotEmpty &&
          _endDateController.text.isNotEmpty;
    } else {
      _isValid = _selectedAccessibility != "" &&
          (_projects.isNotEmpty || _selectedAccessibility == "Public");
    }
    _isValidated = _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _isValid;

    refreshUI();
  }

  bool isMilestone() {
    return _type == CreateProjectType.milestoneCreate ||
        _type == CreateProjectType.milestoneEdit;
  }

  void validateOnTap() {
    if (titleController.text.isEmpty) {
      _validateTitle = true;
    }
    if (_descriptionController.text.isEmpty) {
      _validateDesc = true;
    }
    if (_selectedAccessibility == "Public" || _projects.isNotEmpty) {
      _validateDesc = true;
    }
    if (_startDateController.text.isEmpty) {
      _validateDate = true;
    }
    if (_endDateController.text.isEmpty) {
      _validateDate = true;
    }
    refreshUI();
  }

  void onCreateTransaction() {
    _isProcessing = true;
    refreshUI();
    showOnLoading(context, "Loading...");
    if (_type == CreateProjectType.milestoneCreate) {
      _presenter.onCreateMilestone(
        CreateMilestoneApiRequest(
          projectId: _projectObj!.id,
          name: _titleController.text,
          description: _descriptionController.text,
          start: (_startDate!.millisecondsSinceEpoch / 1000).floor(),
          end: (_endDate!.millisecondsSinceEpoch / 1000).floor(),
        ),
      );
    } else if (_type == CreateProjectType.milestoneEdit) {
      _createProjectRequest.objectIdentifier = _objectIdentifier;
      _createProjectRequest.name = _titleController.text;
      _createProjectRequest.description = _descriptionController.text;
      _createProjectRequest.start =
          (_startDate!.millisecondsSinceEpoch / 1000).floor();
      _createProjectRequest.end =
          (_endDate!.millisecondsSinceEpoch / 1000).floor();
      _presenter.onCreateProject(_createProjectRequest);
    } else {
      if (_type == CreateProjectType.projectEdit)
        _createProjectRequest.objectIdentifier = _objectIdentifier;
      if (_type == CreateProjectType.subProject)
        _createProjectRequest.parentPhid = _objectIdentifier;
      if (_type != CreateProjectType.projectEdit)
        _createProjectRequest.membersPhid = [_userData.id];

      _createProjectRequest.name = _titleController.text;
      _createProjectRequest.description = _descriptionController.text;
      _createProjectRequest.policy = _selectedAccessibility;
      if (_projects.isNotEmpty)
        _createProjectRequest.projectPhid = _projects.first.id;
      _presenter.onCreateProject(_createProjectRequest);
    }
  }

  void onSelectedPolicy(String newValue) {
    _selectedAccessibility = newValue;
    if (_selectedAccessibility != newValue) _selectedAccessibility = newValue;
    validate();
    refreshUI();
  }

  Future<void> onSearchProjects() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs('project',
          title: S.of(context).label_project,
          placeholderText: "Pilih Project",
          selectedBefore: _projects,
          type: SearchSelectionType.single),
    );

    if (result != null) {
      _projects.clear();
      Project project;
      project = result as Project;
      _projects = [project];
      validate();
      refreshUI();
    }
  }

  void onDeleteProjects() {
    _projects.clear();
    validate();
    refreshUI();
  }

  void _moveToDetailProject(Project project) {
    _eventBus.fire(Refresh());
    Navigator.pushReplacementNamed(
      context,
      Pages.projectDetail,
      arguments: DetailProjectArgs(phid: project.id),
    );
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

  void clearEndDate() {
    _endDateController.clear();
    _endDate = null;
    validate();
    refreshUI();
  }

  void showActionSnackbar(BuildContext context, String content) {
    final snackBar = SnackBar(
      content: Text(
        content,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: ColorsItem.whiteFEFEFE,
        ),
      ),
      margin: EdgeInsets.only(
        bottom: Dimens.SPACE_30,
        left: Dimens.SPACE_10,
        right: Dimens.SPACE_10,
      ),
      backgroundColor: ColorsItem.black32373D,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context)..showSnackBar(snackBar);
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
