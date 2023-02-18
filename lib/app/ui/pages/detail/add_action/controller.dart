import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/pages/detail/add_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/add_action/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_ticket_info_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';

class AddActionController extends BaseController {
  final AddActionPresenter _presenter;
  final EventBus _eventBus;
  late Ticket _ticket;
  late AddActionArgs _data;
  List<ProjectColumn> _projectColumns = [];

  AddActionController(this._presenter, this._eventBus);

  Ticket get ticket => _ticket;
  AddActionArgs get data => _data;

  List<ActionItem> get actionItems {
    return [
      ActionItem(
        S.of(context).add_action_assign_claim,
        () => goToDetailAction(
          DetailActionType.assign,
        ),
      ),
      ActionItem(
        S.of(context).add_action_change_status,
        () => goToDetailAction(
          DetailActionType.changeStatus,
        ),
      ),
      ActionItem(
        S.of(context).add_action_change_priority,
        () => goToDetailAction(
          DetailActionType.changePriority,
        ),
      ),
      ActionItem(
        S.of(context).add_action_update_story_point,
        () => goToDetailAction(
          DetailActionType.updateStoryPoint,
        ),
      ),
      ActionItem(
        S.of(context).add_action_move_on_workboard,
        () => goToMoveWorkboard(),
      ),
      ActionItem(
        S.of(context).add_action_change_project_label,
        () => goToDetailAction(
          DetailActionType.changeProjectLabel,
        ),
      ),
      ActionItem(
        S.of(context).add_action_change_subscribers,
        () => goToDetailAction(
          DetailActionType.changeSubscriber,
        ),
      ),
    ];
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as AddActionArgs;
    }
  }

  @override
  void load() {
    loading(false);
    _refreshDetailTickets();
  }

  @override
  void initListeners() {
    _presenter.getTicketsOnNext =
        (List<Ticket> ticketsResponse, PersistenceType type) {
      print("addAction: success getTickets ${ticketsResponse.length} $type");
      if (ticketsResponse.isNotEmpty) {
        _ticket = ticketsResponse.first;

        _presenter.onGetTicketProjects(
          GetTicketInfoApiRequest(_ticket.intId.toString()),
        );
      }
    };
    _presenter.getTicketsOnComplete = (PersistenceType type) {
      print("addAction: completed getTickets $type");
    };
    _presenter.getTicketsOnError = (e, PersistenceType type) {
      loading(false);
      print("addAction: error getTickets $e $type");
    };

    _presenter.getTicketProjectsOnNext =
        (TicketProjectInfo projectInfo, PersistenceType type) {
      print(
        "addAction: success getTicketProjets $type, ${projectInfo.projectIds}",
      );
      _presenter.onGetColumnTicket(
        GetProjectColumnTicketApiRequest(projectInfo.projectIds.first),
      );
    };

    _presenter.getTicketProjectsOnComplete = (PersistenceType type) {
      print("addAction: completed getTicketProjects $type");
    };

    _presenter.getTicketProjectsOnError = (e, PersistenceType type) {
      loading(false);
      print("addAction: error getTicketProjects: $e $type");
    };

    _presenter.getColumnsTicketOnNext = (List<ProjectColumn> columns) {
      print("addAction: success getColumnTicket ${columns.length}");

      List<ProjectColumn> _tempColumns = [];
      _tempColumns.addAll(columns);

      _tempColumns.sort((a, b) {
        return a.sequence!.compareTo(b.sequence!);
      });
      _projectColumns.clear();
      _projectColumns.addAll(List.from(_tempColumns));
    };

    _presenter.getColumnsTicketOnComplete = () {
      print("addAction: completed getColumnTicket");
      loading(false);
      refreshUI();
    };

    _presenter.getColumnsTicketOnError = (e) {
      loading(false);
      print("addAction: error getColumnTicket: $e");
    };
  }

  void goToDetailAction(DetailActionType type) {
    Navigator.of(context)
        .pushNamed(
      Pages.detailAction,
      arguments: DetailActionArgs(
        type: type,
        ticket: ticket,
      ),
    )
        .then((value) {
      if (value != null) {
        _onSuccessSave();
      }
    });
  }

  void goToMoveWorkboard() {
    Navigator.pushNamed(
      context,
      Pages.projectColumnSearch,
      arguments: ProjectColumnSearchArgs(
        'move_task_to_column',
        title: S.of(context).add_action_move_on_workboard,
        placeholderText: "Pilih Project",
        projectColumn: _projectColumns,
        type: ProjectColumnSearchType.moveOnWorkboard,
        ticketIds: [_ticket.id],
        projectId: _ticket.project?.id,
      ),
    ).then((value) {
      if (value != null) {
        _onSuccessSave();
      }
    });
  }

  void _refreshDetailTickets() {
    loading(true);
    _presenter.onGetTickets(
      GetTicketsApiRequest(
        queryKey: GetTicketsApiRequest.QUERY_ALL,
        phids: [_data.id],
      ),
    );
  }

  void _onSuccessSave() {
    showNotif(context, S.of(context).add_action_change_success_save);
    _eventBus.fire(Refresh());
    _refreshDetailTickets();
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}

class ActionItem {
  final String title;
  final Function() onPressed;

  ActionItem(this.title, this.onPressed);
}
