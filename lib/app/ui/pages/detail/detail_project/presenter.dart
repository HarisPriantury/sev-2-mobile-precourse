import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/set_project_status_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/phobject/get_object_transactions.dart';
import 'package:mobile_sev2/use_cases/phobject/get_objects.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';
import 'package:mobile_sev2/use_cases/project/set_project_status.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class DetailProjectPresenter extends Presenter {
  GetUsersUseCase _usersUseCase;
  GetObjectTransactionsUseCase _transactionsUseCase;
  GetObjectsUseCase _objectUseCase;
  GetProjectsUseCase _projectsUseCase;

  SetProjectStatusUseCase _projectStatusUseCase;

  DetailProjectPresenter(
    this._usersUseCase,
    this._transactionsUseCase,
    this._objectUseCase,
    this._projectsUseCase,
    this._projectStatusUseCase,
  );

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

  // get projects
  late Function getProjectsOnNext;
  late Function getProjectsOnComplete;
  late Function getProjectsOnError;

  // get projects
  late Function setProjectStatusOnNext;
  late Function setProjectStatusOnComplete;
  late Function setProjectStatusOnError;

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

  @override
  void dispose() {
    _usersUseCase.dispose();
    _transactionsUseCase.dispose();
    _objectUseCase.dispose();
    _projectsUseCase.dispose();
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  DetailProjectPresenter _presenter;
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
  DetailProjectPresenter _presenter;
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
  DetailProjectPresenter _presenter;
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

class _GetProjectsObserver implements Observer<List<Project>> {
  DetailProjectPresenter _presenter;
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
  DetailProjectPresenter _presenter;

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
