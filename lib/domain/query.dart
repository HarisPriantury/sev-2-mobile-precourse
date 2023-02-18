import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/phobject.dart';

part 'query.g.dart';

@HiveType(typeId: 44)
class Query extends BaseDomain {
  @HiveField(0)
  String queryName;
  @HiveField(1)
  String keyword;
  @HiveField(2)
  List<PhObject> authoredBy;
  @HiveField(3)
  List<PhObject> subscribedBy;
  @HiveField(4)
  String documentType;
  @HiveField(5)
  String documentStatus;
  @HiveField(6)
  String workspace;

  Query(
    this.queryName,
    this.keyword,
    this.authoredBy,
    this.subscribedBy,
    this.documentType,
    this.documentStatus,
    this.workspace,
  );

  static String getName() {
    return "query";
  }

  @override
  clone() {
    return Query(
      this.queryName,
      this.keyword,
      this.authoredBy,
      this.subscribedBy,
      this.documentType,
      this.documentStatus,
      this.workspace,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
