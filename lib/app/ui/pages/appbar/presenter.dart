import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_participants.dart';

class AppbarPresenter extends Presenter {
  GetLobbyParticipantsUseCase _participantsUseCase;

  AppbarPresenter(this._participantsUseCase);

  late Function getLobbyParticipantsOnNext;
  late Function getLobbyParticipantsOnComplete;
  late Function getLobbyParticipantsOnError;

  void onGetLobbyParticipants(GetLobbyParticipantsRequestInterface req) {
    if (req is GetLobbyParticipantsApiRequest) {
      _participantsUseCase.execute(_GetLobbyParticipantsObserver(this, PersistenceType.api), req);
    }
  }

  @override
  void dispose() {
    _participantsUseCase.dispose();
  }
}

class _GetLobbyParticipantsObserver implements Observer<List<User>> {
  AppbarPresenter _presenter;
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
