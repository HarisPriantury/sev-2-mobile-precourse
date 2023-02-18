import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class DetailChangeSubscriberPresenter extends Presenter {
  final GetUsersUseCase _usersUseCase;

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  DetailChangeSubscriberPresenter(
    this._usersUseCase,
  );

  void onGetUsers(GetUsersRequestInterface req) {
    if (req is GetUsersApiRequest) {
      _usersUseCase.execute(_GetUsersObserver(this, PersistenceType.api), req);
    }
  }

  @override
  void dispose() {
    _usersUseCase.dispose();
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  DetailChangeSubscriberPresenter _presenter;
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
