import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_stickit_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/calendar/create_event.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_stickits.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_task.dart';
import 'package:mobile_sev2/use_cases/phobject/get_objects.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class CreatePresenter extends Presenter {
  CreateEventUseCase _calendarUseCase;
  CreateLobbyRoomTaskUseCase _taskUseCase;
  CreateLobbyRoomStickitUseCase _stickitUseCase;
  GetUsersUseCase _usersUseCase;
  GetObjectsUseCase _objectUseCase;

  CreatePresenter(
    this._calendarUseCase,
    this._taskUseCase,
    this._stickitUseCase,
    this._usersUseCase,
    this._objectUseCase,
  );

  late Function createCalendarOnNext;
  late Function createCalendarOnComplete;
  late Function createCalendarOnError;

  late Function createStickitOnNext;
  late Function createStickitOnComplete;
  late Function createStickitOnError;

  late Function createTaskOnNext;
  late Function createTaskOnComplete;
  late Function createTaskOnError;

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // get object
  late Function getObjectsOnNext;
  late Function getObjectsOnComplete;
  late Function getObjectsOnError;

  void onCreateCalendar(CreateEventRequestInterface req) {
    if (req is CreateEventApiRequest) {
      _calendarUseCase.execute(_CalendarTransactionObserver(this), req);
    }
  }

  void onCreateStickit(CreateLobbyRoomStickitRequestInterface req) {
    if (req is CreateLobbyRoomStickitApiRequest) {
      _stickitUseCase.execute(_StickitTransactionObserver(this), req);
    }
  }

  void onCreateTask(CreateLobbyRoomTaskRequestInterface req) {
    if (req is CreateLobbyRoomTicketApiRequest) {
      _taskUseCase.execute(_TaskTransactionObserver(this), req);
    }
  }

  void onGetUsers(GetUsersRequestInterface req, String role) {
    if (req is GetUsersApiRequest) {
      _usersUseCase.execute(
          _GetUsersObserver(this, PersistenceType.api, role), req);
    }
  }

  void onGetObjects(GetObjectsRequestInterface req) {
    if (req is GetObjectsApiRequest) {
      _objectUseCase.execute(
          _GetObjectsObserver(this, PersistenceType.api), req);
    }
  }

  @override
  void dispose() {
    _calendarUseCase.dispose();
    _taskUseCase.dispose();
    _stickitUseCase.dispose();
    _usersUseCase.dispose();
    _objectUseCase.dispose();
  }
}

class _CalendarTransactionObserver implements Observer<bool> {
  CreatePresenter _presenter;

  _CalendarTransactionObserver(this._presenter);

  void onNext(bool? result) {
    _presenter.createCalendarOnNext(result);
  }

  void onComplete() {
    _presenter.createCalendarOnComplete();
  }

  void onError(e) {
    _presenter.createCalendarOnError(e);
  }
}

class _StickitTransactionObserver implements Observer<bool> {
  CreatePresenter _presenter;

  _StickitTransactionObserver(this._presenter);

  void onNext(bool? result) {
    _presenter.createStickitOnNext(result);
  }

  void onComplete() {
    _presenter.createStickitOnComplete();
  }

  void onError(e) {
    _presenter.createStickitOnError(e);
  }
}

class _TaskTransactionObserver implements Observer<bool> {
  CreatePresenter _presenter;

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

class _GetUsersObserver implements Observer<List<User>> {
  CreatePresenter _presenter;
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

class _GetObjectsObserver implements Observer<List<PhObject>> {
  CreatePresenter _presenter;
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
