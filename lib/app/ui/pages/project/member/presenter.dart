import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/create_project_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/project/create_project.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class ProjectMemberPresenter extends Presenter {
  CreateProjectUseCase _createProjectUseCase;
  GetUsersUseCase _usersUseCase;

  late Function createProjectOnComplete;
  late Function createProjectOnError;
  late Function createProjectOnNext;

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  ProjectMemberPresenter(
    this._createProjectUseCase,
    this._usersUseCase,
  );

  void onCreateProject(CreateProjectRequestInterface req) {
    if (req is CreateProjectApiRequest) {
      _createProjectUseCase.execute(_CreateProjectObserver(this), req);
    }
  }

  void onGetUsers(GetUsersRequestInterface req) {
    _usersUseCase.execute(_GetUsersObserver(this), req);
  }

  @override
  void dispose() {
    _createProjectUseCase.dispose();
    _usersUseCase.dispose();
  }
}

class _CreateProjectObserver implements Observer<BaseApiResponse> {
  _CreateProjectObserver(this._presenter);

  ProjectMemberPresenter _presenter;

  void onNext(BaseApiResponse? result) {
    _presenter.createProjectOnNext(result);
  }

  void onComplete() {
    _presenter.createProjectOnComplete();
  }

  void onError(e) {
    _presenter.createProjectOnError(e);
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  ProjectMemberPresenter _presenter;

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