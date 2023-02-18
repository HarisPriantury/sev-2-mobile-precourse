import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/update_user_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/update_user_avatar_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';
import 'package:mobile_sev2/use_cases/user/update_avatar.dart';
import 'package:mobile_sev2/use_cases/user/update_user.dart';

class ProfileEditPresenter extends Presenter {
  UpdateUserUseCase _updateUserUseCase;
  UpdateAvatarUserUseCase _updateAvatarUserUseCase;
  GetUsersUseCase _getUsersUseCase;

  ProfileEditPresenter(this._updateUserUseCase, this._updateAvatarUserUseCase,
      this._getUsersUseCase);

  // for get profile
  late Function updateProfileOnNext;
  late Function updateProfileOnComplete;
  late Function updateProfileOnError;

  // for Update Avatar profile
  late Function updateAvatarProfileOnNext;
  late Function updateAvatarProfileOnComplete;
  late Function updateAvatarProfileOnError;

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  void onUpdateProfile(UpdateUserRequestInterface req) {
    if (req is UpdateUserApiRequest) {
      _updateUserUseCase.execute(
          _UpdateProfileObserver(this, PersistenceType.api), req);
    }
  }

  void onUpdateAvatar(UpdateAvatarUserRequestInterface req) {
    if (req is UpdateAvatarUserApiRequest) {
      _updateAvatarUserUseCase.execute(
          _UpdateAvatarProfileObserver(this, PersistenceType.api), req);
    }
  }

  void onGetUsers(GetUsersRequestInterface req) {
    if (req is GetUsersApiRequest) {
      _getUsersUseCase.execute(
          _GetUsersObserver(this, PersistenceType.api), req);
    }
  }

  @override
  void dispose() {
    _updateUserUseCase.dispose();
    _updateAvatarUserUseCase.dispose();
    _getUsersUseCase.dispose();
  }
}

class _UpdateProfileObserver implements Observer<bool> {
  ProfileEditPresenter _presenter;
  PersistenceType _type;

  _UpdateProfileObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.updateProfileOnNext(result, _type);
  }

  void onComplete() {
    _presenter.updateProfileOnComplete(_type);
  }

  void onError(e) {
    _presenter.updateProfileOnError(e, _type);
  }
}

class _UpdateAvatarProfileObserver implements Observer<bool> {
  ProfileEditPresenter _presenter;
  PersistenceType _type;

  _UpdateAvatarProfileObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.updateAvatarProfileOnNext(result, _type);
  }

  void onComplete() {
    _presenter.updateAvatarProfileOnComplete(_type);
  }

  void onError(e) {
    _presenter.updateAvatarProfileOnError(e, _type);
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  ProfileEditPresenter _presenter;
  PersistenceType _type;

  _GetUsersObserver(this._presenter, this._type);

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users, _type);
  }

  void onComplete() {
    _presenter.getUsersOnComplete(_type);
  }

  void onError(e) {
    _presenter.getUsersOnError(e, _type);
  }
}
