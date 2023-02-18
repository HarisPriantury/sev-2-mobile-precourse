import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/calendar/join_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_stickit_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_columns_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/set_project_status_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/stickit/get_stickit_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_ticket_info_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/stickit_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/calendar/create_event.dart';
import 'package:mobile_sev2/use_cases/calendar/get_events.dart';
import 'package:mobile_sev2/use_cases/calendar/join_event.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_stickits.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_task.dart';
import 'package:mobile_sev2/use_cases/phobject/get_object_transactions.dart';
import 'package:mobile_sev2/use_cases/phobject/get_objects.dart';
import 'package:mobile_sev2/use_cases/project/get_project_columns.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';
import 'package:mobile_sev2/use_cases/project/set_project_status.dart';
import 'package:mobile_sev2/use_cases/reaction/get_object_reactions.dart';
import 'package:mobile_sev2/use_cases/reaction/give_reaction.dart';
import 'package:mobile_sev2/use_cases/stickit/get_stickit.dart';
import 'package:mobile_sev2/use_cases/ticket/get_ticket_subscribers.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class DetailPresenter extends Presenter {
  GetUsersUseCase _usersUseCase;
  GetObjectTransactionsUseCase _transactionsUseCase;
  GetObjectsUseCase _objectUseCase;
  JoinEventUseCase _joinEventUseCase;
  GetTicketSubscribersUseCase _ticketSubscribersUseCase;
  GetTicketsUseCase _ticketsUseCase;
  GetProjectsUseCase _projectsUseCase;

  SetProjectStatusUseCase _projectStatusUseCase;

  GetStickitsUseCase _stickitsUseCase;

  GetEventsUseCase _eventsUseCase;

  // for comment
  CreateEventUseCase _createCalendarUseCase;
  GiveReactionUseCase _giveReactionUseCase;
  CreateLobbyRoomStickitUseCase _createStickitUseCase;
  CreateLobbyRoomTaskUseCase _createTaskUseCase;
  GetProjectColumnsUseCase _columnsUseCase;
  GetObjectReactionsUseCase _getObjectReactionsUseCase;
  GetFilesUseCase _getFilesUseCase;

  DetailPresenter(
      this._usersUseCase,
      this._transactionsUseCase,
      this._objectUseCase,
      this._joinEventUseCase,
      this._ticketSubscribersUseCase,
      this._createCalendarUseCase,
      this._createStickitUseCase,
      this._createTaskUseCase,
      this._columnsUseCase,
      this._giveReactionUseCase,
      this._getObjectReactionsUseCase,
      this._getFilesUseCase,
      this._ticketsUseCase,
      this._projectsUseCase,
      this._projectStatusUseCase,
      this._stickitsUseCase,
      this._eventsUseCase);

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // get transactions
  late Function getTransactionsOnNext;
  late Function getTransactionsOnComplete;
  late Function getTransactionsOnError;

  // get object
  late Function getObjectsOnNext;
  late Function getObjectsOnComplete;
  late Function getObjectsOnError;

  // join event
  late Function joinEventOnNext;
  late Function joinEventOnComplete;
  late Function joinEventOnError;

  // get ticket subscribers
  late Function getTicketSubscribersOnNext;
  late Function getTicketSubscribersOnComplete;
  late Function getTicketSubscribersOnError;

  // comment
  late Function calendarTransactionOnNext;
  late Function calendarTransactionOnComplete;
  late Function calendarTransactionOnError;

  late Function stickitTransactionOnNext;
  late Function stickitTransactionOnComplete;
  late Function stickitTransactionOnError;

  late Function taskTransactionOnNext;
  late Function taskTransactionOnComplete;
  late Function taskTransactionOnError;

  late Function getColumnsOnNext;
  late Function getColumnsOnComplete;
  late Function getColumnsOnError;

  // send reaction
  late Function sendReactionOnNext;
  late Function sendReactionOnComplete;
  late Function sendReactionOnError;

  // get object reaction
  late Function getObjectReactionOnNext;
  late Function getObjectReactionOnComplete;
  late Function getObjectReactionOnError;

  // get attachment
  late Function getFilesOnNext;
  late Function getFilesOnComplete;
  late Function getFilesOnError;

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // get projects
  late Function getProjectsOnNext;
  late Function getProjectsOnComplete;
  late Function getProjectsOnError;

  // get projects
  late Function setProjectStatusOnNext;
  late Function setProjectStatusOnComplete;
  late Function setProjectStatusOnError;

  // get stickits
  late Function getStickitsOnNext;
  late Function getStickitsOnComplete;
  late Function getStickitsOnError;

  // get events
  late Function getCalendarOnNext;
  late Function getCalendarOnComplete;
  late Function getCalendarOnError;

  void onGetUsers(GetUsersRequestInterface req, String role) {
    if (req is GetUsersApiRequest) {
      _usersUseCase.execute(
          _GetUsersObserver(this, PersistenceType.api, role), req);
    }
  }

  void onGetTransactions(GetObjectTransactionsRequestInterface req) {
    if (req is GetObjectTransactionsApiRequest) {
      _transactionsUseCase.execute(
          _GetTransactionsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetObjects(GetObjectsRequestInterface req) {
    if (req is GetObjectsApiRequest) {
      _objectUseCase.execute(
          _GetObjectsObserver(this, PersistenceType.api), req);
    }
  }

  void onJoinEvent(JoinEventRequestInterface req) {
    if (req is JoinEventApiRequest) {
      _joinEventUseCase.execute(
          _JoinEventObserver(this, PersistenceType.api), req);
    }
  }

  void onGetTicketSubscribers(GetTicketInfoRequestInterface req) {
    if (req is GetTicketInfoApiRequest) {
      _ticketSubscribersUseCase.execute(
          _GetTicketSubscribersObserver(this, PersistenceType.api), req);
    }
  }

  void onCalendarTransaction(CreateEventRequestInterface req) {
    if (req is CreateEventApiRequest) {
      _createCalendarUseCase.execute(
          _CalendarTransactionObserver(this, PersistenceType.api), req);
    }
  }

  void onStickitTransaction(CreateLobbyRoomStickitRequestInterface req) {
    if (req is CreateLobbyRoomStickitApiRequest) {
      _createStickitUseCase.execute(
          _StickitTransactionObserver(this, PersistenceType.api), req);
    }
  }

  void onTaskTransaction(CreateLobbyRoomTaskRequestInterface req) {
    if (req is CreateLobbyRoomTicketApiRequest) {
      _createTaskUseCase.execute(
          _TaskTransactionObserver(this, PersistenceType.api), req);
    }
  }

  void onGetColumns(GetProjectColumnsRequestInterface req) {
    if (req is GetProjectColumnsApiRequest) {
      _columnsUseCase.execute(_GetColumnsObserver(this), req);
    }
  }

  void onSendReaction(GiveReactionRequestInterface req) {
    if (req is GiveReactionApiRequest) {
      _giveReactionUseCase.execute(
          _GiveReactionObserver(this, PersistenceType.api), req);
    }
  }

  void onGetObjectReactions(GetObjectReactionsRequestInterface req) {
    if (req is GetObjectReactionsApiRequest) {
      _getObjectReactionsUseCase.execute(
          _GetObjectReactionsObserver(this), req);
    }
  }

  void onGetFiles(GetFilesRequestInterface req) {
    if (req is GetFilesApiRequest) {
      _getFilesUseCase.execute(_GetFilesObserver(this), req);
    }
  }

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketsUseCase.execute(
          _GetTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetProjects(
    GetProjectsRequestInterface req, {
    String type = 'project',
  }) {
    _projectsUseCase.execute(_GetProjectsObserver(this, type), req);
  }

  void onSetProjectStatus(SetProjectStatusRequestInterface req) {
    if (req is SetProjectStatusApiRequest)
      _projectStatusUseCase.execute(_SetProjectStatusObserver(this), req);
  }

  void onGetStickit(GetStickitRequestInterface req) {
    if (req is GetStickitsApiRequest) {
      _stickitsUseCase.execute(
          _GetStickitsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetEvent(GetEventsRequestInterface req) {
    _eventsUseCase.execute(_GetEventsObserver(this, PersistenceType.api), req);
  }

  @override
  void dispose() {
    _usersUseCase.dispose();
    _transactionsUseCase.dispose();
    _objectUseCase.dispose();
    _joinEventUseCase.dispose();
    _createCalendarUseCase.dispose();
    _createStickitUseCase.dispose();
    _createTaskUseCase.dispose();
    _columnsUseCase.dispose();
    _giveReactionUseCase.dispose();
    _getObjectReactionsUseCase.dispose();
    _ticketSubscribersUseCase.dispose();
    _getFilesUseCase.dispose();
    _ticketsUseCase.dispose();
    _projectsUseCase.dispose();
    _stickitsUseCase.dispose();
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  DetailPresenter _presenter;
  PersistenceType _type;
  String _role;

  _GetUsersObserver(this._presenter, this._type, this._role);

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users, _type, _role);
  }

  void onComplete() {
    _presenter.getUsersOnComplete(_type);
  }

  void onError(e) {
    _presenter.getUsersOnError(e, _type);
  }
}

class _GetTransactionsObserver implements Observer<List<PhTransaction>> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _GetTransactionsObserver(this._presenter, this._type);

  void onNext(List<PhTransaction>? users) {
    _presenter.getTransactionsOnNext(users, _type);
  }

  void onComplete() {
    _presenter.getTransactionsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTransactionsOnError(e, _type);
  }
}

class _GetObjectsObserver implements Observer<List<PhObject>> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _GetObjectsObserver(this._presenter, this._type);

  void onNext(List<PhObject>? objects) {
    _presenter.getObjectsOnNext(objects, _type);
  }

  void onComplete() {
    _presenter.getObjectsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getObjectsOnError(e, _type);
  }
}

class _JoinEventObserver implements Observer<bool> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _JoinEventObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.joinEventOnNext(result, _type);
  }

  void onComplete() {
    _presenter.joinEventOnComplete(_type);
  }

  void onError(e) {
    _presenter.joinEventOnError(e, _type);
  }
}

class _GetTicketSubscribersObserver implements Observer<TicketSubscriberInfo> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _GetTicketSubscribersObserver(this._presenter, this._type);

  void onNext(TicketSubscriberInfo? subscriberInfo) {
    _presenter.getTicketSubscribersOnNext(subscriberInfo, _type);
  }

  void onComplete() {
    _presenter.getTicketSubscribersOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTicketSubscribersOnError(e, _type);
  }
}

class _CalendarTransactionObserver implements Observer<bool> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _CalendarTransactionObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.calendarTransactionOnNext(result, _type);
  }

  void onComplete() {
    _presenter.calendarTransactionOnComplete(_type);
  }

  void onError(e) {
    _presenter.calendarTransactionOnError(e, _type);
  }
}

class _StickitTransactionObserver implements Observer<bool> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _StickitTransactionObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.stickitTransactionOnNext(result, _type);
  }

  void onComplete() {
    _presenter.stickitTransactionOnComplete(_type);
  }

  void onError(e) {
    _presenter.stickitTransactionOnError(e, _type);
  }
}

class _TaskTransactionObserver implements Observer<bool> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _TaskTransactionObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.taskTransactionOnNext(result, _type);
  }

  void onComplete() {
    _presenter.taskTransactionOnComplete(_type);
  }

  void onError(e) {
    _presenter.taskTransactionOnError(e, _type);
  }
}

class _GetColumnsObserver implements Observer<List<ProjectColumn>> {
  DetailPresenter _presenter;

  _GetColumnsObserver(this._presenter);

  void onNext(List<ProjectColumn>? columns) {
    _presenter.getColumnsOnNext(columns);
  }

  void onComplete() {
    _presenter.getColumnsOnComplete();
  }

  void onError(e) {
    _presenter.getColumnsOnError(e);
  }
}

class _GiveReactionObserver implements Observer<bool> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _GiveReactionObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.sendReactionOnNext(result, _type);
  }

  void onComplete() {
    _presenter.sendReactionOnComplete(_type);
  }

  void onError(e) {
    _presenter.sendReactionOnError(e, _type);
  }
}

class _GetObjectReactionsObserver implements Observer<List<ObjectReactions>> {
  DetailPresenter _presenter;

  _GetObjectReactionsObserver(this._presenter);

  void onNext(List<ObjectReactions>? result) {
    _presenter.getObjectReactionOnNext(result);
  }

  void onComplete() {
    _presenter.getObjectReactionOnComplete();
  }

  void onError(e) {
    _presenter.getObjectReactionOnError(e);
  }
}

class _GetFilesObserver implements Observer<List<File>> {
  DetailPresenter _presenter;

  _GetFilesObserver(this._presenter);

  void onNext(List<File>? files) {
    _presenter.getFilesOnNext(files);
  }

  void onComplete() {
    _presenter.getFilesOnComplete();
  }

  void onError(e) {
    _presenter.getFilesOnError(e);
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _GetTicketsObserver(this._presenter, this._type);

  void onNext(List<Ticket>? tickets) {
    _presenter.getTicketsOnNext(tickets, _type);
  }

  void onComplete() {
    _presenter.getTicketsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTicketsOnError(e, _type);
  }
}

class _GetProjectsObserver implements Observer<List<Project>> {
  DetailPresenter _presenter;
  String _type;

  _GetProjectsObserver(
    this._presenter,
    this._type,
  );

  void onNext(List<Project>? projects) {
    _presenter.getProjectsOnNext(projects, _type);
  }

  void onComplete() {
    _presenter.getProjectsOnComplete();
  }

  void onError(e) {
    _presenter.getProjectsOnError(e);
  }
}

class _SetProjectStatusObserver implements Observer<BaseApiResponse> {
  DetailPresenter _presenter;

  _SetProjectStatusObserver(
    this._presenter,
  );

  void onNext(BaseApiResponse? response) {
    _presenter.setProjectStatusOnNext(response);
  }

  void onComplete() {
    _presenter.setProjectStatusOnComplete();
  }

  void onError(e) {
    _presenter.setProjectStatusOnError(e);
  }
}

class _GetStickitsObserver implements Observer<List<Stickit>> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _GetStickitsObserver(this._presenter, this._type);

  void onNext(List<Stickit>? stickits) {
    _presenter.getStickitsOnNext(stickits, _type);
  }

  void onComplete() {
    _presenter.getStickitsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getStickitsOnError(e, _type);
  }
}

class _GetEventsObserver implements Observer<List<Calendar>> {
  DetailPresenter _presenter;
  PersistenceType _type;

  _GetEventsObserver(this._presenter, this._type);

  void onNext(List<Calendar>? calendar) {
    _presenter.getCalendarOnNext(calendar, _type);
  }

  void onComplete() {
    _presenter.getCalendarOnComplete(_type);
  }

  void onError(e) {
    _presenter.getCalendarOnError(e, _type);
  }
}
