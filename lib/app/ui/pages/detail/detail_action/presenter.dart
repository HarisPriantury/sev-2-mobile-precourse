import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_ticket_info_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_task.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';
import 'package:mobile_sev2/use_cases/ticket/get_ticket_projects.dart';
import 'package:mobile_sev2/use_cases/ticket/get_ticket_subscribers.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class DetailActionPresenter extends Presenter {
  final CreateLobbyRoomTaskUseCase _taskUseCase;
  final GetTicketSubscribersUseCase _ticketSubscribersUseCase;
  final GetUsersUseCase _usersUseCase;
  final GetTicketProjectsUseCase _ticketProjectsUseCase;
  final GetProjectsUseCase _projectsUseCase;

  DetailActionPresenter(
    this._taskUseCase,
    this._ticketSubscribersUseCase,
    this._usersUseCase,
    this._ticketProjectsUseCase,
    this._projectsUseCase,
  );

  late Function createTaskOnNext;
  late Function createTaskOnComplete;
  late Function createTaskOnError;

  // get ticket subscribers
  late Function getTicketSubscribersOnNext;
  late Function getTicketSubscribersOnComplete;
  late Function getTicketSubscribersOnError;

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // get ticket projects
  late Function getTicketProjectsOnNext;
  late Function getTicketProjectsOnComplete;
  late Function getTicketProjectsOnError;

  // get projects
  late Function getProjectsOnNext;
  late Function getProjectsOnComplete;
  late Function getProjectsOnError;

  void onCreateTask(CreateLobbyRoomTaskRequestInterface req) {
    if (req is CreateLobbyRoomTicketApiRequest) {
      _taskUseCase.execute(_TaskTransactionObserver(this), req);
    }
  }

  void onGetTicketSubscribers(GetTicketInfoRequestInterface req) {
    if (req is GetTicketInfoApiRequest) {
      _ticketSubscribersUseCase.execute(
          _GetTicketSubscribersObserver(this, PersistenceType.api), req);
    }
  }

  void onGetUsers(GetUsersRequestInterface req, String role) {
    if (req is GetUsersApiRequest) {
      _usersUseCase.execute(
          _GetUsersObserver(this, PersistenceType.api, role), req);
    }
  }

  void onGetTicketProjects(GetTicketInfoRequestInterface req) {
    if (req is GetTicketInfoApiRequest) {
      _ticketProjectsUseCase.execute(
          _GetTicketProjectsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetProjects(GetProjectsRequestInterface req) {
    if (req is GetProjectsApiRequest) {
      _projectsUseCase.execute(
        _GetProjectsObserver(this, PersistenceType.api),
        req,
      );
    }
  }

  @override
  void dispose() {
    _taskUseCase.dispose();
    _ticketSubscribersUseCase.dispose();
    _usersUseCase.dispose();
    _ticketProjectsUseCase.dispose();
    _projectsUseCase.dispose();
  }
}

class _TaskTransactionObserver implements Observer<bool> {
  DetailActionPresenter _presenter;

  _TaskTransactionObserver(this._presenter);

  void onNext(bool? result) {
    _presenter.createTaskOnNext(result);
  }

  void onComplete() {
    _presenter.createTaskOnComplete();
  }

  void onError(e) {
    _presenter.createTaskOnError(e);
  }
}

class _GetTicketSubscribersObserver implements Observer<TicketSubscriberInfo> {
  final DetailActionPresenter _presenter;
  final PersistenceType _type;

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

class _GetUsersObserver implements Observer<List<User>> {
  DetailActionPresenter _presenter;
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

class _GetTicketProjectsObserver implements Observer<TicketProjectInfo> {
  final DetailActionPresenter _presenter;
  final PersistenceType _type;

  _GetTicketProjectsObserver(this._presenter, this._type);

  @override
  void onNext(TicketProjectInfo? response) {
    _presenter.getTicketProjectsOnNext(response, _type);
  }

  @override
  void onComplete() {
    _presenter.getTicketProjectsOnComplete(_type);
  }

  @override
  void onError(e) {
    _presenter.getTicketProjectsOnError(e, _type);
  }
}

class _GetProjectsObserver implements Observer<List<Project>> {
  final DetailActionPresenter _presenter;
  final PersistenceType _type;

  _GetProjectsObserver(this._presenter, this._type);

  @override
  void onNext(List<Project>? response) {
    _presenter.getProjectsOnNext(response, _type);
  }

  @override
  void onComplete() {
    _presenter.getProjectsOnComplete(_type);
  }

  @override
  void onError(e) {
    _presenter.getProjectsOnError(e, _type);
  }
}
