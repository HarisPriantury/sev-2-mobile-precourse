import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'search_history.g.dart';

@HiveType(typeId: 43)
class SearchHistory extends BaseDomain {
  @HiveField(0)
  String keyword;
  @HiveField(1)
  String filterType;
  @HiveField(2)
  String workspace;

  SearchHistory(this.keyword, this.filterType, this.workspace);

  static String getName() {
    return "search_history";
  }

  @override
  clone() {
    return SearchHistory(this.keyword, this.filterType, this.workspace);
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
