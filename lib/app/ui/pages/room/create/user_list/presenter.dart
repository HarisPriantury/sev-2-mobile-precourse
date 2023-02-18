import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/room/create_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/user/create_user_db_request.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/room/create_room.dart';
import 'package:mobile_sev2/use_cases/room/get_rooms.dart';
import 'package:mobile_sev2/use_cases/user/create_user.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class UserListPresenter extends Presenter {
  GetUsersUseCase _usersUseCase;
  GetUsersUseCase _usersDbUseCase;
  CreateRoomUseCase _createUseCase;
  CreateRoomUseCase _createDbUseCase;
  GetRoomsUseCase _getRoomsUseCase;
  GetRoomsUseCase _getRoomsDbUseCase;
  CreateUserUseCase _createUserDbUseCase;

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // create room
  late Function createRoomOnNext;
  late Function createRoomOnComplete;
  late Function createRoomOnError;

  // get room
  late Function getRoomsOnNext;
  late Function getRoomsOnComplete;
  late Function getRoomsOnError;

  // create user
  late Function createUserOnNext;
  late Function createUserOnComplete;
  late Function createUserOnError;

  UserListPresenter(this._usersUseCase, this._usersDbUseCase, this._createUseCase, this._createDbUseCase,
      this._getRoomsUseCase, this._getRoomsDbUseCase, this._createUserDbUseCase);

  void onGetUsers(GetUsersRequestInterface req) {
    if (req is GetUsersApiRequest) {
      _usersUseCase.execute(_GetUsersObserver(this, PersistenceType.api), req);
    } else {
      _usersDbUseCase.execute(_GetUsersObserver(this, PersistenceType.db), req);
    }
  }

  void onCreateRoom(CreateRoomRequestInterface req, User user) {
    if (req is CreateRoomApiRequest) {
      _createUseCase.execute(_CreateRoomObserver(this, PersistenceType.api, user), req);
    } else {
      _createDbUseCase.execute(_CreateRoomObserver(this, PersistenceType.db, user), req);
    }
  }

  void onGetRooms(GetRoomsRequestInterface req, user) {
    if (req is GetRoomsApiRequest) {
      _getRoomsUseCase.execute(_GetRoomsObserver(this, PersistenceType.api, user), req);
    } else {
      _getRoomsDbUseCase.execute(_GetRoomsObserver(this, PersistenceType.db, user), req);
    }
  }

  void onCreateUser(CreateUserRequestInterface req) {
    if (req is CreateUserDBRequest) {
      _createUserDbUseCase.execute(_CreateUserObserver(this, PersistenceType.db), req);
    }
  }

  void dispose() {
    _usersUseCase.dispose();
    _usersDbUseCase.dispose();
    _createUseCase.dispose();
    _createDbUseCase.dispose();
    _getRoomsUseCase.dispose();
    _getRoomsDbUseCase.dispose();
    _createUserDbUseCase.dispose();
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  UserListPresenter _presenter;
  PersistenceType _type;

  _GetUsersObserver(this._presenter, this._type);

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users, _type);
  }

  void onComplete() {
    _presenter.getUsersOnComplete(_type);
  }

  void onError(e) {
    _presenter.getUsersOnError(e, _type);
  }
}

class _CreateRoomObserver implements Observer<BaseApiResponse> {
  UserListPresenter _presenter;
  PersistenceType _type;
  User _user;

  _CreateRoomObserver(this._presenter, this._type, this._user);

  void onNext(BaseApiResponse? resp) {
    _presenter.createRoomOnNext(resp, _type, _user);
  }

  void onComplete() {
    _presenter.createRoomOnComplete(_type);
  }

  void onError(e) {
    _presenter.createRoomOnError(e, _type);
  }
}

class _GetRoomsObserver implements Observer<List<Room>> {
  UserListPresenter _presenter;
  PersistenceType _type;
  User _user;

  _GetRoomsObserver(this._presenter, this._type, this._user);

  void onNext(List<Room>? resp) {
    _presenter.getRoomsOnNext(resp, _type, _user);
  }

  void onComplete() {
    _presenter.getRoomsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getRoomsOnError(e, _type);
  }
}

class _CreateUserObserver implements Observer<bool> {
  UserListPresenter _presenter;
  PersistenceType _type;

  _CreateUserObserver(this._presenter, this._type);

  void onNext(bool? resp) {
    _presenter.createUserOnNext(resp, _type);
  }

  void onComplete() {
    _presenter.createUserOnComplete(_type);
  }

  void onError(e) {
    _presenter.createUserOnError(e, _type);
  }
}
