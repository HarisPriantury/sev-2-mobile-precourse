import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/flag/delete_flag_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/get_flags_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/contribution.dart';
import 'package:mobile_sev2/domain/flag.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/flag/delete_flag.dart';
import 'package:mobile_sev2/use_cases/flag/get_flags.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/user/get_profile_info.dart';
import 'package:mobile_sev2/use_cases/user/get_user_contribution.dart';

class ProfilePresenter extends Presenter {
  GetProfileUseCase _profileUsecase;
  GetTicketsUseCase _ticketUseCase;
  GetProjectsUseCase _projectsUseCase;
  GetUserContributionsUseCase _userContributionsUseCase;
  GetFlagsUseCase _getFlagsUseCase;
  DeleteFlagUseCase _deleteFlagUseCase;

  // for get profile
  late Function getProfileOnNext;
  late Function getProfileOnComplete;
  late Function getProfileOnError;

  // get tickets, used by connect
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // get tickets, to count total SP
  late Function getTicketSummaryOnNext;
  late Function getTicketSummaryOnComplete;
  late Function getTicketSummaryOnError;

  // get projects
  late Function getProjectsOnNext;
  late Function getProjectsOnComplete;
  late Function getProjectsOnError;

  // get user Contributions
  late Function getUserContributionsOnNext;
  late Function getUserContributionsOnComplete;
  late Function getUserContributionsOnError;

  // get flags
  late Function getFlagsOnNext;
  late Function getFlagsOnComplete;
  late Function getFlagsOnError;

  // delete flags
  late Function deleteFlagOnNext;
  late Function deleteFlagOnComplete;
  late Function deleteFlagOnError;

  ProfilePresenter(
    this._profileUsecase,
    this._ticketUseCase,
    this._projectsUseCase,
    this._userContributionsUseCase,
    this._getFlagsUseCase,
    this._deleteFlagUseCase,
  );

  void onGetProfile(GetProfileRequestInterface req) {
    if (req is GetProfileApiRequest) {
      _profileUsecase.execute(
          _GetProfileObserver(this, PersistenceType.api), req);
    }
  }

  void onGetTickets(GetTicketsRequestInterface req, bool subscribed) {
    if (req is GetTicketsApiRequest) {
      _ticketUseCase.execute(
          _GetTicketsObserver(this, PersistenceType.api, subscribed), req);
    }
  }

  void onGetTicketSummary(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketUseCase.execute(
          _GetTicketSummaryObserver(this, PersistenceType.api), req);
    }
  }

  void onGetProjects(GetProjectsRequestInterface req) {
    _projectsUseCase.execute(_GetProjectsObserver(this), req);
  }

  void onGetUserContributions(GetUserContributionsRequestInterface req) {
    _userContributionsUseCase.execute(_GetUserContributionsObserver(this), req);
  }

  void onGetFlags(GetFlagsRequestInterface req) {
    if (req is GetFlagsApiRequest) {
      _getFlagsUseCase.execute(
        _GetFlagsObserver(
          this,
          PersistenceType.api,
        ),
        req,
      );
    }
  }

  void onDeleteFlag(DeleteFlagRequestInterface req) {
    if (req is DeleteFlagApiRequest) {
      _deleteFlagUseCase.execute(
        _DeleteFlagObserver(
          this,
          PersistenceType.api,
        ),
        req,
      );
    }
  }

  void dispose() {
    _profileUsecase.dispose();
    _ticketUseCase.dispose();
    _projectsUseCase.dispose();
    _userContributionsUseCase.dispose();
    _getFlagsUseCase.dispose();
    _deleteFlagUseCase.dispose();
  }
}

class _GetProfileObserver implements Observer<User> {
  ProfilePresenter _presenter;
  PersistenceType _type;

  _GetProfileObserver(this._presenter, this._type);

  void onNext(User? user) {
    _presenter.getProfileOnNext(user, _type);
  }

  void onComplete() {
    _presenter.getProfileOnComplete(_type);
  }

  void onError(e) {
    _presenter.getProfileOnError(e, _type);
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  ProfilePresenter _presenter;
  PersistenceType _type;
  bool _subscribed;

  _GetTicketsObserver(
    this._presenter,
    this._type,
    this._subscribed,
  );

  void onNext(List<Ticket>? tickets) {
    _presenter.getTicketsOnNext(tickets, _type, _subscribed);
  }

  void onComplete() {
    _presenter.getTicketsOnComplete(_type, _subscribed);
  }

  void onError(e) {
    _presenter.getTicketsOnError(e, _type, _subscribed);
  }
}

class _GetTicketSummaryObserver implements Observer<List<Ticket>> {
  ProfilePresenter _presenter;
  PersistenceType _type;

  _GetTicketSummaryObserver(
    this._presenter,
    this._type,
  );

  void onNext(List<Ticket>? tickets) {
    _presenter.getTicketSummaryOnNext(tickets, _type);
  }

  void onComplete() {
    _presenter.getTicketSummaryOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTicketSummaryOnError(e, _type);
  }
}

class _GetProjectsObserver implements Observer<List<Project>> {
  ProfilePresenter _presenter;

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

class _GetUserContributionsObserver implements Observer<List<Contribution>> {
  ProfilePresenter _presenter;

  _GetUserContributionsObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getUserContributionsOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getUserContributionsOnError(e);
  }

  @override
  void onNext(List<Contribution>? response) {
    _presenter.getUserContributionsOnNext(response);
  }
}

class _GetFlagsObserver implements Observer<List<Flag>> {
  ProfilePresenter _presenter;
  PersistenceType _type;

  _GetFlagsObserver(this._presenter, this._type);

  void onNext(List<Flag>? result) {
    _presenter.getFlagsOnNext(result, _type);
  }

  void onComplete() {
    _presenter.getFlagsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getFlagsOnError(e, _type);
  }
}

class _DeleteFlagObserver implements Observer<bool> {
  ProfilePresenter _presenter;
  PersistenceType _type;

  _DeleteFlagObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.deleteFlagOnNext(result, _type);
  }

  void onComplete() {
    _presenter.deleteFlagOnComplete(_type);
  }

  void onError(e) {
    _presenter.deleteFlagOnError(e, _type);
  }
}
