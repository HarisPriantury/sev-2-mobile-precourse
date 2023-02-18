import 'package:mobile_sev2/domain/base.dart';

class Country extends BaseDomain {
  String flagEmoji;
  String name;

  Country(this.flagEmoji, this.name);
  @override
  clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
