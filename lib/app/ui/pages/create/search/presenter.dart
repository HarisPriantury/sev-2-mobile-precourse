import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class ObjectSearchPresenter extends Presenter {
  GetUsersUseCase _usersUseCase;
  GetProjectsUseCase _projectsUseCase;

  ObjectSearchPresenter(this._usersUseCase, this._projectsUseCase);

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // get projects
  late Function getProjectsOnNext;
  late Function getProjectsOnComplete;
  late Function getProjectsOnError;

  void onGetUsers(GetUsersRequestInterface req) {
    _usersUseCase.execute(_GetUsersObserver(this), req);
  }

  void onGetProjects(GetProjectsRequestInterface req) {
    _projectsUseCase.execute(_GetProjectsObserver(this), req);
  }

  @override
  void dispose() {
    _usersUseCase.dispose();
    _projectsUseCase.dispose();
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  ObjectSearchPresenter _presenter;

  _GetUsersObserver(this._presenter);

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users);
  }

  void onComplete() {
    _presenter.getUsersOnComplete();
  }

  void onError(e) {
    _presenter.getUsersOnError(e);
  }
}

class _GetProjectsObserver implements Observer<List<Project>> {
  ObjectSearchPresenter _presenter;

  _GetProjectsObserver(this._presenter);

  void onNext(List<Project>? projects) {
    _presenter.getProjectsOnNext(projects);
  }

  void onComplete() {
    _presenter.getProjectsOnComplete();
  }

  void onError(e) {
    _presenter.getProjectsOnError(e);
  }
}
