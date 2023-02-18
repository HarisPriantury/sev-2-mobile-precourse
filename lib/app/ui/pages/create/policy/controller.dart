import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/policy/get_policies_api_request.dart';
import 'package:mobile_sev2/data/payload/api/policy/get_spaces_api_request.dart';
import 'package:mobile_sev2/domain/policy.dart';
import 'package:mobile_sev2/domain/space.dart';

class PolicyController extends BaseController {
  PolicyPresenter _presenter;
  PolicyArgs? _data;

  late PolicyType type;

  List<Policy> _policies = [];
  List<Policy> _basicPolicies = [];
  List<Policy> _objectPolicies = [];
  List<Policy> _userPolicies = [];
  List<Space> _spaces = [];

  PolicyController(this._presenter);

  List<Policy> get basicPolicies => _basicPolicies;
  List<Policy> get objectPolicies => _objectPolicies;
  List<Policy> get userPolicies => _userPolicies;
  List<Space> get spaces => _spaces;
  PolicyArgs? get policyData => _data;

  @override
  void getArgs() {
    if (args != null) {
      _data = args as PolicyArgs;
    }
  }

  @override
  void load() {
    _presenter.onGetPolicies(GetPoliciesApiRequest());
  }

  @override
  void initListeners() {
    _presenter.getPoliciesOnNext = (List<Policy> policies) {
      print("policy: success getPolicies");
      _policies.addAll(policies);

      policies.forEach((p) {
        if (p.type == 'basic') {
          _basicPolicies.add(p);
        } else if (p.type == 'object') {
          _objectPolicies.add(p);
        } else if (p.type == 'user') {
          _userPolicies.add(p);
        }
      });
    };

    _presenter.getPoliciesOnComplete = () {
      print("policy: completed getPolicies");

      _presenter.onGetSpaces(GetSpacesApiRequest());
    };

    _presenter.getPoliciesOnError = (e) {
      loading(false);
      print("policy: error getPolicies: $e");
    };

    _presenter.getSpacesOnNext = (List<Space> spaces) {
      print("policy: success getSpaces");

      _spaces.addAll(spaces);
    };

    _presenter.getSpacesOnComplete = () {
      print("policy: completed getSpaces");
      loading(false);
    };

    _presenter.getSpacesOnError = (e) {
      print("policy: error getSpaces: $e");
      loading(false);
    };
  }

  void onSelectedPolicy(String? newValue) {
    _data?.policy = _policies.where((e) => e.value == newValue).first;
    refreshUI();
  }

  bool isSelected() {
    if (_data?.policy != null)
      return true;
    else
      return false;
  }

  void onSelectedSpace(String? newValue) {
    _data?.space = _spaces.where((e) => e.id == newValue).first;
    refreshUI();
  }

  //waiting data from pushed page
  Future<void> goToCustomPolicy() async {
    var result = await Navigator.pushNamed(context, Pages.customPolicy);
    print(result);
    refreshUI();
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
