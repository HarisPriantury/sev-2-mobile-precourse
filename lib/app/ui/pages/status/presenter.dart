import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_statuses_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/update_status_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/work_on_task_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_profile_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/setting_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/setting/get_setting_db_request.dart';
import 'package:mobile_sev2/data/payload/db/setting/update_setting_db_request.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_participants.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_statuses.dart';
import 'package:mobile_sev2/use_cases/lobby/update_status.dart';
import 'package:mobile_sev2/use_cases/lobby/work_on_task.dart';
import 'package:mobile_sev2/use_cases/setting/get_setting.dart';
import 'package:mobile_sev2/use_cases/setting/update_setting.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/user/get_profile_info.dart';

class StatusPresenter extends Presenter {
  GetProfileUseCase _profileUsecase;
  GetLobbyParticipantsUseCase _participantsUseCase;
  GetLobbyStatusesUseCase _statusesUseCase;
  GetTicketsUseCase _ticketsUseCase;
  WorkOnTaskUseCase _workUseCase;
  UpdateStatusUseCase _updateStatusUseCase;
  GetSettingUseCase _getSettingUseCase;
  UpdateSettingUseCase _updateSettingUseCase;

  // for get profile
  late Function getProfileOnNext;
  late Function getProfileOnComplete;
  late Function getProfileOnError;

  // get lobby participants
  late Function getLobbyParticipantsOnNext;
  late Function getLobbyParticipantsOnComplete;
  late Function getLobbyParticipantsOnError;

  // get availability status
  late Function getAvailabilityStatusOnNext;
  late Function getAvailabilityStatusOnComplete;
  late Function getAvailabilityStatusOnError;

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // work on task
  late Function workOnTaskOnNext;
  late Function workOnTaskOnComplete;
  late Function workOnTaskOnError;

  // update status
  late Function updateStatusOnNext;
  late Function updateStatusOnComplete;
  late Function updateStatusOnError;

  // get setting
  late Function getSettingOnNext;
  late Function getSettingOnComplete;
  late Function getSettingOnError;

  // update setting
  late Function updateSettingOnNext;
  late Function updateSettingOnComplete;
  late Function updateSettingOnError;

  StatusPresenter(
    this._profileUsecase,
    this._participantsUseCase,
    this._statusesUseCase,
    this._ticketsUseCase,
    this._workUseCase,
    this._updateStatusUseCase,
    this._getSettingUseCase,
    this._updateSettingUseCase,
  );

  void onGetProfile(GetProfileRequestInterface req) {
    if (req is GetProfileApiRequest) {
      _profileUsecase.execute(_GetProfileObserver(this, PersistenceType.api), req);
    }
  }

  void onGetLobbyParticipants(GetLobbyParticipantsRequestInterface req) {
    if (req is GetLobbyParticipantsApiRequest) {
      _participantsUseCase.execute(_GetLobbyParticipantsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetAvailabilityStatuses(GetLobbyStatusesRequestInterface req) {
    if (req is GetLobbyStatusesApiRequest) {
      _statusesUseCase.execute(_GetLobbyStatusesObserver(this, PersistenceType.api), req);
    }
  }

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketsUseCase.execute(_GetTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onWorkOnTask(WorkOnTaskRequestInterface req) {
    if (req is WorkOnTaskApiRequest) {
      _workUseCase.execute(_WorkOnTaskObserver(this, PersistenceType.api), req);
    }
  }

  void onUpdateStatus(UpdateStatusRequestInterface req) {
    if (req is UpdateStatusApiRequest) {
      _updateStatusUseCase.execute(_UpdateStatusObserver(this, PersistenceType.api), req);
    }
  }

  void onGetSetting(GetSettingRequestInterface req) {
    if (req is GetSettingDBRequest) {
      _getSettingUseCase.execute(_GetSettingObserver(this, PersistenceType.db), req);
    }
  }

  void onUpdateSetting(UpdateSettingRequestInterface req) {
    if (req is UpdateSettingDBRequest) {
      _updateSettingUseCase.execute(_UpdateSettingObserver(this, PersistenceType.db), req);
    }
  }

  @override
  void dispose() {
    _profileUsecase.dispose();
    _participantsUseCase.dispose();
    _statusesUseCase.dispose();
    _ticketsUseCase.dispose();
    _workUseCase.dispose();
    _updateStatusUseCase.dispose();
    _getSettingUseCase.dispose();
    _updateSettingUseCase.dispose();
  }
}

class _GetProfileObserver implements Observer<User> {
  StatusPresenter _presenter;
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

class _GetLobbyParticipantsObserver implements Observer<List<User>> {
  StatusPresenter _presenter;
  PersistenceType _type;

  _GetLobbyParticipantsObserver(this._presenter, this._type);

  void onNext(List<User>? users) {
    _presenter.getLobbyParticipantsOnNext(users, _type);
  }

  void onComplete() {
    _presenter.getLobbyParticipantsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getLobbyParticipantsOnError(e, _type);
  }
}

class _GetLobbyStatusesObserver implements Observer<List<LobbyStatus>> {
  StatusPresenter _presenter;
  PersistenceType _type;

  _GetLobbyStatusesObserver(this._presenter, this._type);

  void onNext(List<LobbyStatus>? statuses) {
    _presenter.getAvailabilityStatusOnNext(statuses, _type);
  }

  void onComplete() {
    _presenter.getAvailabilityStatusOnComplete(_type);
  }

  void onError(e) {
    _presenter.getAvailabilityStatusOnError(e, _type);
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  StatusPresenter _presenter;
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

class _WorkOnTaskObserver implements Observer<bool> {
  StatusPresenter _presenter;
  PersistenceType _type;

  _WorkOnTaskObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.workOnTaskOnNext(result, _type);
  }

  void onComplete() {
    _presenter.workOnTaskOnComplete(_type);
  }

  void onError(e) {
    _presenter.workOnTaskOnError(e, _type);
  }
}

class _UpdateStatusObserver implements Observer<bool> {
  StatusPresenter _presenter;
  PersistenceType _type;

  _UpdateStatusObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.updateStatusOnNext(result, _type);
  }

  void onComplete() {
    _presenter.updateStatusOnComplete(_type);
  }

  void onError(e) {
    _presenter.updateStatusOnError(e, _type);
  }
}

class _GetSettingObserver implements Observer<Setting> {
  StatusPresenter _presenter;
  PersistenceType _type;

  _GetSettingObserver(this._presenter, this._type);

  void onNext(Setting? setting) {
    _presenter.getSettingOnNext(setting, _type);
  }

  void onComplete() {
    _presenter.getSettingOnComplete(_type);
  }

  void onError(e) {
    _presenter.getSettingOnError(e, _type);
  }
}

class _UpdateSettingObserver implements Observer<bool> {
  StatusPresenter _presenter;
  PersistenceType _type;

  _UpdateSettingObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.updateSettingOnNext(result, _type);
  }

  void onComplete() {
    _presenter.updateSettingOnComplete(_type);
  }

  void onError(e) {
    _presenter.updateSettingOnError(e, _type);
  }
}
