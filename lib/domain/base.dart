import 'package:hive/hive.dart';

// All domain must inherit this class, in order to get Hive feature
abstract class BaseDomain extends HiveObject {
  dynamic clone();
  Map<String, dynamic> toJson();
}
