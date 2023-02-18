import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';

class DetailChangeProjectPresenter extends Presenter {
  GetProjectsUseCase _projectsUseCase;

  DetailChangeProjectPresenter(this._projectsUseCase);

  // get projects
  late Function getProjectsOnNext;
  late Function getProjectsOnComplete;
  late Function getProjectsOnError;

  void onGetProjects(GetProjectsRequestInterface req) {
    _projectsUseCase.execute(
        _GetProjectsObserver(
          this,
          PersistenceType.api,
        ),
        req);
  }

  @override
  void dispose() {
    _projectsUseCase.dispose();
  }
}

class _GetProjectsObserver implements Observer<List<Project>> {
  DetailChangeProjectPresenter _presenter;
  PersistenceType _type;

  _GetProjectsObserver(this._presenter, this._type);

  void onNext(List<Project>? projects) {
    _presenter.getProjectsOnNext(projects, _type);
  }

  void onComplete() {
    _presenter.getProjectsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getProjectsOnError(e, _type);
  }
}
