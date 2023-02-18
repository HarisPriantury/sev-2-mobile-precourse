import 'package:mobile_sev2/data/payload/contracts/policy_request_interface.dart';
import 'package:mobile_sev2/domain/policy.dart';
import 'package:mobile_sev2/domain/space.dart';

abstract class PolicyRepository {
  Future<List<Policy>> getPolicies(GetPoliciesRequestInterface params);
  Future<List<Space>> getSpaces(GetSpacesRequestInterface params);
}
