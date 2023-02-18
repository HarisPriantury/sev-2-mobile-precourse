import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/user.dart';

enum DetailChangeSubscriberType {
  add,
  search,
}

class DetailChangeSubscriberArgs extends BaseArgs {
  final String id;
  final List<User> currentSubscriber;
  final DetailChangeSubscriberType type;

  DetailChangeSubscriberArgs({
    required this.id,
    required this.currentSubscriber,
    required this.type,
  });

  @override
  String toPrint() {
    return 'DetailChangeSubscriberArgs data : $type $id';
  }
}
