import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/wiki.dart';

class WikiDetailArgs implements BaseArgs {
  WikiDetailArgs(this.wiki);

  Wiki wiki;

  @override
  String toPrint() {
    return "WikiDetailArgs data: ${wiki.toJson()}";
  }
}
