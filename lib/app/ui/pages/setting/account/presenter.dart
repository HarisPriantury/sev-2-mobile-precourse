import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/user/update_user_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/use_cases/user/delete_account.dart';
import 'package:mobile_sev2/use_cases/user/update_user.dart';

class SettingPresenter extends Presenter {
  UpdateUserUseCase _updateUserUseCase;
  UserDeleteAccountUseCase _userDeleteAccountUseCase;

  SettingPresenter(
    this._updateUserUseCase,
    this._userDeleteAccountUseCase,
  );

  // update user
  late Function updateUserOnNext;
  late Function updateUserOnComplete;
  late Function updateUserOnError;

  // delete account user
  late Function deleteAccountUserOnNext;
  late Function deleteAccountUserOnComplete;
  late Function deleteAccountUserOnError;

  void onGetLobbyRoomStickits(UpdateUserRequestInterface req) {
    if (req is UpdateUserApiRequest) {
      _updateUserUseCase.execute(
          _UpdateUserObserver(this, PersistenceType.api), req);
    }
  }

  void onDeleteAccount(UserDeleteAccountRequestInterface req) {
    _userDeleteAccountUseCase.execute(_DeleteUserObserver(this), req);
  }

  @override
  void dispose() {
    _updateUserUseCase.dispose();
    _userDeleteAccountUseCase.dispose();
  }
}

class _UpdateUserObserver implements Observer<bool> {
  SettingPresenter _presenter;
  PersistenceType _type;

  _UpdateUserObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.updateUserOnNext(result, _type);
  }

  void onComplete() {
    _presenter.updateUserOnComplete(_type);
  }

  void onError(e) {
    _presenter.updateUserOnError(e, _type);
  }
}

class _DeleteUserObserver implements Observer<bool> {
  SettingPresenter _presenter;

  _DeleteUserObserver(this._presenter);

  void onNext(bool? result) {
    _presenter.deleteAccountUserOnNext(result);
  }

  void onComplete() {
    _presenter.deleteAccountUserOnComplete();
  }

  void onError(e) {
    _presenter.deleteAccountUserOnError(e);
  }
}
