import 'package:mobile_sev2/domain/base.dart';

class Policy extends BaseDomain {
  String title;
  String value;
  String type;

  Policy(this.title, this.value, this.type);

  @override
  Policy clone() {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
