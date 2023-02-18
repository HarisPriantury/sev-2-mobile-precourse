import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/policy.dart';
import 'package:mobile_sev2/domain/space.dart';

class PolicyArgs implements BaseArgs {
  PolicyType? type;
  Policy? policy;
  Space? space;

  PolicyArgs({this.type, this.policy, this.space});

  @override
  String toPrint() {
    return "PolicyArgs data: $policy $space";
  }
}

enum PolicyType { visible, editable }
