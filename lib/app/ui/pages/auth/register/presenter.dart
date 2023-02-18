import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/auth/register_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/use_cases/auth/register.dart';

class RegisterPresenter extends Presenter {
  RegisterUseCase _registerUseCase;

  RegisterPresenter(this._registerUseCase);

  late Function registerOnNext;
  late Function registerOnComplete;
  late Function registerOnError;

  onRegister(RegisterRequestInterface req) {
    if (req is RegisterApiRequest) {
      _registerUseCase.execute(_RegisterObserver(this), req);
    }
  }

  @override
  void dispose() {
    _registerUseCase.dispose();
  }

}

class _RegisterObserver implements Observer<BaseApiResponse> {
  RegisterPresenter _presenter;

  _RegisterObserver(this._presenter);

  void onNext(BaseApiResponse? resp) {
    _presenter.registerOnNext(resp);
  }

  void onComplete() {
    _presenter.registerOnComplete();
  }

  void onError(e) {
    _presenter.registerOnError(e);
  }
}