import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class AddActionArgs extends BaseArgs {
  final String id;

  AddActionArgs({required this.id});

  @override
  String toPrint() {
    return 'AddActionArgs data : $id';
  }
}
