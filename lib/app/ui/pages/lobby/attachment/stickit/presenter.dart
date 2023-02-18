import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_stickits_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/set_as_read_stickit_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_stickits.dart';
import 'package:mobile_sev2/use_cases/lobby/set_as_read_stickit.dart';

class RoomStickitPresenter extends Presenter {
  GetLobbyRoomStickitsUseCase _stickitUseCase;
  SetAsReadStickitUseCase _setAsReadStickitUseCase;
  RoomStickitPresenter(this._stickitUseCase, this._setAsReadStickitUseCase);

  // get stickits
  late Function getLobbyRoomStickitsOnNext;
  late Function getLobbyRoomStickitsOnComplete;
  late Function getLobbyRoomStickitsOnError;

  // setAsReadStickit
  late Function setAsReadStickitOnNext;
  late Function setAsReadStickitOnComplete;
  late Function setAsReadStickitOnError;

  void onGetLobbyRoomStickits(GetLobbyRoomStickitsRequestInterface req) {
    if (req is GetLobbyRoomStickitsApiRequest) {
      _stickitUseCase.execute(_GetLobbyRoomStickitsObserver(this, PersistenceType.api), req);
    }
  }

  void onSetAsReadStickit(SetAsReadStickitRequestInterface req) {
    if (req is SetAsReadStickitApiRequest) {
      _setAsReadStickitUseCase.execute(_SetAsReadStickitObserver(this), req);
    }
  }

  @override
  void dispose() {
    _stickitUseCase.dispose();
    _setAsReadStickitUseCase.dispose();
  }
}

class _GetLobbyRoomStickitsObserver implements Observer<List<Stickit>> {
  RoomStickitPresenter _presenter;
  PersistenceType _type;

  _GetLobbyRoomStickitsObserver(this._presenter, this._type);

  void onNext(List<Stickit>? stickits) {
    _presenter.getLobbyRoomStickitsOnNext(stickits, _type);
  }

  void onComplete() {
    _presenter.getLobbyRoomStickitsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getLobbyRoomStickitsOnError(e, _type);
  }
}

class _SetAsReadStickitObserver implements Observer<bool> {
  RoomStickitPresenter _presenter;

  _SetAsReadStickitObserver(this._presenter);

  void onNext(bool? read) {
    _presenter.setAsReadStickitOnNext(read);
  }

  void onComplete() {
    _presenter.setAsReadStickitOnComplete();
  }

  void onError(e) {
    _presenter.setAsReadStickitOnError(e);
  }
}
