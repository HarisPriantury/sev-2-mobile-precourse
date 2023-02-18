import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class DetailWikiPresenter extends Presenter {
  DetailWikiPresenter(
    this._getUsersUseCase,
  );

  late Function getUsersOnComplete;
  late Function getUsersOnError;
  // get users
  late Function getUsersOnNext;

  GetUsersUseCase _getUsersUseCase;

  @override
  void dispose() {
    _getUsersUseCase.dispose();
  }

  void onGetUsers(GetUsersRequestInterface req) {
    if (req is GetUsersApiRequest) {
      _getUsersUseCase.execute(
          _GetUsersObserver(this, PersistenceType.api), req);
    }
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  _GetUsersObserver(this._presenter, this._type);

  DetailWikiPresenter _presenter;
  PersistenceType _type;

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
