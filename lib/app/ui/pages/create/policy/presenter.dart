import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/policy/get_policies_api_request.dart';
import 'package:mobile_sev2/data/payload/api/policy/get_spaces_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/policy_request_interface.dart';
import 'package:mobile_sev2/domain/policy.dart';
import 'package:mobile_sev2/domain/space.dart';
import 'package:mobile_sev2/use_cases/policy/get_policies.dart';
import 'package:mobile_sev2/use_cases/policy/get_spaces.dart';

class PolicyPresenter extends Presenter {
  GetPoliciesUseCase _policiesUseCase;
  GetSpacesUseCase _spacesUseCase;

  PolicyPresenter(this._policiesUseCase, this._spacesUseCase);

  // get policies
  late Function getPoliciesOnNext;
  late Function getPoliciesOnComplete;
  late Function getPoliciesOnError;

  // get spaces
  late Function getSpacesOnNext;
  late Function getSpacesOnComplete;
  late Function getSpacesOnError;

  void onGetPolicies(GetPoliciesRequestInterface req) {
    if (req is GetPoliciesApiRequest) {
      _policiesUseCase.execute(_GetPoliciesObserver(this), req);
    }
  }

  void onGetSpaces(GetSpacesRequestInterface req) {
    if (req is GetSpacesApiRequest) {
      _spacesUseCase.execute(_GetSpacesObserver(this), req);
    }
  }

  @override
  void dispose() {
    _policiesUseCase.dispose();
    _spacesUseCase.dispose();
  }
}

class _GetPoliciesObserver implements Observer<List<Policy>> {
  PolicyPresenter _presenter;

  _GetPoliciesObserver(this._presenter);

  void onNext(List<Policy>? policies) {
    _presenter.getPoliciesOnNext(policies);
  }

  void onComplete() {
    _presenter.getPoliciesOnComplete();
  }

  void onError(e) {
    _presenter.getPoliciesOnError(e);
  }
}

class _GetSpacesObserver implements Observer<List<Space>> {
  PolicyPresenter _presenter;

  _GetSpacesObserver(this._presenter);

  void onNext(List<Space>? spaces) {
    _presenter.getSpacesOnNext(spaces);
  }

  void onComplete() {
    _presenter.getSpacesOnComplete();
  }

  void onError(e) {
    _presenter.getSpacesOnError(e);
  }
}
