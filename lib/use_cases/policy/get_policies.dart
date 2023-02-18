import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/policy_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/policy_repository_interface.dart';
import 'package:mobile_sev2/domain/policy.dart';

class GetPoliciesUseCase extends UseCase<List<Policy>, GetPoliciesRequestInterface> {
  PolicyRepository _repository;

  GetPoliciesUseCase(this._repository);

  @override
  Future<Stream<List<Policy>?>> buildUseCaseStream(GetPoliciesRequestInterface? params) async {
    final StreamController<List<Policy>> _controller = StreamController();
    try {
      List<Policy> policies = await _repository.getPolicies(params!);
      _controller.add(policies);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
