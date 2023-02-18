import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class DetailArgs implements BaseArgs {
  PhObject object;
  String from;

  DetailArgs(this.object, {this.from = ""});

  @override
  String toPrint() {
    return "DetailArgs data: object ${jsonEncode(object)} $from";
  }
}
