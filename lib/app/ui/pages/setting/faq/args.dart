import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/faq.dart';

class FaqArgs implements BaseArgs {
  Faq faq;

  FaqArgs(this.faq);

  @override
  String toPrint() {
    return "FaqArgs faq: ${jsonEncode(this.faq)}";
  }
}
