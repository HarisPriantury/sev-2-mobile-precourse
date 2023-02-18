import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/column_list/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/form_column/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/view.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/move_ticket_api_request.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class WorkboardController extends BaseController {
  WorkboardArgs? _data;
  WorkboardPresenter _presenter;
  final EventBus _eventBus;

  PageController _pageController = PageController(viewportFraction: 0.85);
  TextEditingController _textEditingController = TextEditingController();
  GlobalKey _draggableKey = GlobalKey();
  UserData _userData;
  bool _isDragging = false;
  String _columnFrom = "";
  String _ticketOnMoveCode = "";
  String _columnWillAccept = "";
  int _columnWillAcceptIdx = 0;
  Project? _project;
  List<ProjectColumn> _openProjectColumns = [];
  List<ProjectColumn> _allProjectColumns = [];
  List<ProjectColumn> _assignedProjectColumns = [];
  ProjectView projectView = ProjectView.board;
  TicketFilterType _type = TicketFilterType.Open;

  WorkboardController(this._presenter, this._userData, this._eventBus);

  bool get isDragging => _isDragging;

  String get columnFrom => _columnFrom;

  String get ticketOnMoveCode => _ticketOnMoveCode;

  String get columnWillAccept => _columnWillAccept;

  int get columnWillAcceptIdx => _columnWillAcceptIdx;

  Project? get project => _project;

  String get projectName => _project!.fullName ?? "";

  List<ProjectColumn> get projectColumns {
    if (_type == TicketFilterType.Open) {
      return _openProjectColumns;
    } else if (_type == TicketFilterType.AssignedTome) {
      return _assignedProjectColumns;
    } else {
      return _allProjectColumns;
    }
  }

  PageController get pageController => _pageController;

  TextEditingController get textEditingController => _textEditingController;

  GlobalKey get draggableKey => _draggableKey;

  void _onReceiveArgs(Object object) {
    object as String;
    _presenter.onGetColumnTicket(GetProjectColumnTicketApiRequest(object));
  }

  void goToColumnList() async {
    final object = await Navigator.pushNamed(context, Pages.columnList,
        arguments: ColumnListArgs(
          projectId: _project!.id,
        ));

    if (object != null) {
      _onReceiveArgs(object);
    }
  }

  void goToDetail(Ticket ticket) {
    Navigator.pushNamed(
      context,
      Pages.ticketDetail,
      arguments: DetailTicketArgs(phid: ticket.id, id: ticket.intId),
    );
  }

  void goToCreateColumn() async {
    final object = await Navigator.pushNamed(context, Pages.formColumn,
        arguments: FormColumnArgs(
          projectId: _project!.id,
          formType: FormType.create,
        ));

    if (object != null) {
      _onReceiveArgs(object);
    }
  }

  void goToRenameColumn(String columnId, String columnName) async {
    final object = await Navigator.pushNamed(context, Pages.formColumn,
        arguments: FormColumnArgs(
          projectId: _project!.id,
          columnId: columnId,
          columnName: columnName,
        ));

    if (object != null) {
      _onReceiveArgs(object);
    }
  }

  void goToCreateTaskPage(String columnId) async {
    final object = await Navigator.pushNamed(context, Pages.create,
        arguments: CreateArgs(
          type: Project,
          object: _project,
          columnId: columnId,
        ));

    if (object != null) {
      object as Project;
      _onReceiveArgs(object.id);
    }
  }

  void changeView() {
    if (projectView == ProjectView.board) {
      projectView = ProjectView.list;
    } else {
      projectView = ProjectView.board;
    }
    refreshUI();
  }

  Future _scrollColumn(int idxColumn) async {
    _pageController.animateToPage(
      idxColumn,
      duration: Duration(milliseconds: 750),
      curve: Curves.easeIn,
    );
  }

  void onDragFrom(String columnName, String ticketCode) {
    _isDragging = true;
    _columnFrom = columnName;
    _ticketOnMoveCode = ticketCode;
  }

  void onWillAccept(String columnName, int idxColumn) {
    _columnWillAccept = columnName;
    _columnWillAcceptIdx = idxColumn;
    _scrollColumn(idxColumn);
  }

  void clearMoveHistory() {
    _isDragging = false;
    _columnFrom = "";
    _ticketOnMoveCode = "";
    _columnWillAccept = "";
    refreshUI();
  }

  void onDroppedTask(
    int idxColFrom,
    int idxColTo,
    int idxTicket,
    Ticket ticket,
  ) {
    /// TODO: extract this line of code into a new method and implement this into 3 lists above
    onAfterDroppedTask(idxColFrom, ticket, idxColTo);

    _presenter.onMoveTicket(MoveTicketApiRequest(
      _project!.id,
      projectColumns[idxColTo].id,
      [ticket.id],
    ));
    clearMoveHistory();
  }

  void onAfterDroppedTask(int idxColFrom, Ticket ticket, int idxColTo) {
    _openProjectColumns[idxColFrom]
        .tasks!
        .removeWhere((element) => element.id == ticket.id);
    _openProjectColumns[idxColTo].tasks!.insert(0, ticket);

    _assignedProjectColumns[idxColFrom]
        .tasks!
        .removeWhere((element) => element.id == ticket.id);
    _assignedProjectColumns[idxColTo].tasks!.insert(0, ticket);

    _allProjectColumns[idxColFrom]
        .tasks!
        .removeWhere((element) => element.id == ticket.id);
    _allProjectColumns[idxColTo].tasks!.insert(0, ticket);
  }

  void backToPreviousPage() {
    if (args != null) Navigator.pop(context, _project?.id);
    Navigator.pop(context);
  }

  @override
  void load() {
    _presenter
        .onGetColumnTicket(GetProjectColumnTicketApiRequest(_project!.id));
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();

    reloading(true);
    projectColumns.clear();
    _presenter.onGetColumnTicket(
      GetProjectColumnTicketApiRequest(_project!.id),
    );
  }

  @override
  void initListeners() {
    _eventBus.on<Refresh>().listen((event) {
      reload();
    });
    _presenter.getColumnsTicketOnNext = (List<ProjectColumn> columns) {
      print("workboard: success getColumnTicket ${columns.length}");
      List<ProjectColumn> _tempColumns = [];
      _tempColumns.addAll(columns);
      _tempColumns.removeWhere((col) {
        return col.name == _project!.name || col.isHidden();
      });
      _tempColumns.sort((a, b) {
        if (a.sequence == null) {
          return 1;
        } else if (b.sequence == null) {
          return -1;
        }
        return a.sequence!.compareTo(b.sequence!);
      });
      _allProjectColumns.clear();
      _allProjectColumns.addAll(List.from(_tempColumns));
      _filterOpen(List.from(_tempColumns));
      _filterAssigned(List.from(_tempColumns));
      filter(TicketFilterType.Open);
    };

    _presenter.getColumnsTicketOnComplete = () {
      print("workboard: completed getColumnTicket");
      loading(false);
      refreshUI();
    };

    _presenter.getColumnsTicketOnError = (e) {
      print("workboard: error getColumnTicket: $e");
      loading(false);
    };

    _presenter.moveTicketOnNext = (BaseApiResponse response) {
      print("workboard: success moveTicket");
    };

    _presenter.moveTicketOnComplete = () {
      print("workboard: complete moveTicket");
    };

    _presenter.moveTicketOnError = (e) {
      print("workboard: error moveTicket");
      showNotif(context, S.of(context).error_disconnected);
    };
  }

  @override
  void getArgs() {
    if (args != null) _data = args as WorkboardArgs;
    _project = _data?.project;
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  void _filterAssigned(List<ProjectColumn> column) {
    for (int idx = 0; idx < column.length; idx++) {
      ProjectColumn _temp = column[idx].clone();
      if (_temp.tasks != null) {
        _temp.tasks!.removeWhere((e) => e.assignee?.name != _userData.username);
      }
      _assignedProjectColumns.add(_temp);
    }
  }

  void _filterOpen(List<ProjectColumn> column) {
    _openProjectColumns.clear();
    for (int idx = 0; idx < column.length; idx++) {
      ProjectColumn _temp = column[idx].clone();
      if (_temp.tasks != null) {
        _temp.tasks!.removeWhere(
            (element) => element.ticketStatus != TicketStatus.open);
      }
      _openProjectColumns.add(_temp);
    }
  }

  void filter(TicketFilterType filterType) {
    _type = filterType;
    refreshUI();
  }

  Future<void> onMoveTicketToProject(
      bool isMoveToProject, List<Ticket>? tickets) async {
    List<String> ticketId = [];
    tickets?.forEach((element) {
      ticketId.add(element.id);
    });

    var result = await Navigator.pushNamed(
      context,
      Pages.projectColumnSearch,
      arguments: ProjectColumnSearchArgs(
        isMoveToProject ? 'move_task_to_project' : 'move_task_to_column',
        title: isMoveToProject
            ? "Pindah Tiket ke Project"
            : "Pindah Tiket ke Kolom",
        placeholderText: "Pilih Project",
        projectColumn: projectColumns,
        type: isMoveToProject
            ? ProjectColumnSearchType.moveTicketToProject
            : ProjectColumnSearchType.moveTicketToColumn,
        ticketIds: ticketId,
        projectId: _project!.id,
      ),
    );

    if (result != null) {
      projectColumns.clear();
      loading(true);
      _presenter
          .onGetColumnTicket(GetProjectColumnTicketApiRequest(_project!.id));
      showNotif(context, "Tiket Berhasil Dipindah");
    }
  }

  void reportWorkboard() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments:
                ReportArgs(phId: _project!.id, reportedType: "WORKBOARD"),
          );
        });
  }
}

enum ProjectView {
  board,
  list,
}

enum TicketFilterType { All, Open, AssignedTome }
