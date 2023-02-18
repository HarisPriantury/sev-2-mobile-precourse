import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/create_milestone_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/create_project_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/use_cases/project/create_milestone.dart';
import 'package:mobile_sev2/use_cases/project/create_project.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';

class CreateProjectPresenter extends Presenter {
  CreateProjectUseCase _createProjectUseCase;
  GetProjectsUseCase _getProjectsUseCase;
  CreateMilestoneUseCase _createMilestoneUseCase;

  CreateProjectPresenter(
    this._createProjectUseCase,
    this._getProjectsUseCase,
    this._createMilestoneUseCase,
  );

  late Function createProjectOnComplete;
  late Function createProjectOnError;
  late Function createProjectOnNext;

  late Function getProjectsOnComplete;
  late Function getProjectsOnError;
  late Function getProjectsOnNext;

  late Function createMilestoneOnComplete;
  late Function createMilestoneOnError;
  late Function createMilestoneOnNext;

  @override
  void dispose() {
    _createProjectUseCase.dispose();
    _getProjectsUseCase.dispose();
    _createMilestoneUseCase.dispose();
  }

  void onCreateProject(CreateProjectRequestInterface req) {
    if (req is CreateProjectApiRequest) {
      _createProjectUseCase.execute(_CreateProjectObserver(this), req);
    }
  }

  void onGetProjects(
    GetProjectsRequestInterface req, {
    String type = 'project',
  }) {
    _getProjectsUseCase.execute(_GetProjectsObserver(this, type), req);
  }

  void onCreateMilestone(CreateMilestoneRequestInterface req) {
    if (req is CreateMilestoneApiRequest) {
      _createMilestoneUseCase.execute(_CreateMilestoneObserver(this), req);
    }
  }
}

class _CreateProjectObserver implements Observer<BaseApiResponse> {
  _CreateProjectObserver(this._presenter);

  CreateProjectPresenter _presenter;

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

class _GetProjectsObserver implements Observer<List<Project>> {
  _GetProjectsObserver(
    this._presenter,
    this._type,
  );

  CreateProjectPresenter _presenter;
  String _type;

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

class _CreateMilestoneObserver implements Observer<BaseApiResponse> {
  _CreateMilestoneObserver(
    this._presenter,
  );

  CreateProjectPresenter _presenter;

  void onNext(BaseApiResponse? response) {
    _presenter.createMilestoneOnNext(response);
  }

  void onComplete() {
    _presenter.createMilestoneOnComplete();
  }

  void onError(e) {
    _presenter.createMilestoneOnError(e);
  }
}
