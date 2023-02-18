import 'package:mobile_sev2/domain/policy.dart';
import 'package:mobile_sev2/domain/space.dart';

class PolicyMapper {
  List<Policy> convertGetPoliciesApiResponse(Map<String, dynamic> response) {
    var policies = List<Policy>.empty(growable: true);

    var data = response['result'];

    if (data != null) {
      data['basicPolicies'].forEach((val) {
        policies.add(Policy(val['title'], val['value'], 'basic'));
      });

      data['objectPolicies'].forEach((val) {
        policies.add(Policy(val['title'], val['value'], 'object'));
      });

      data['userPolicies'].forEach((val) {
        policies.add(Policy(val['title'], val['value'], 'user'));
      });
    }
    return policies;
  }

  List<Space> convertGetSpacesApiResponse(Map<String, dynamic> response) {
    var spaces = List<Space>.empty(growable: true);

    var data = response['result']['data'];
    for (var space in data) {
      spaces.add(Space(
        space['phid'],
        space['name'],
        space['description'],
      ));
    }
    return spaces;
  }
}
