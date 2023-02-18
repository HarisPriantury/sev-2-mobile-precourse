import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';

part 'faq.g.dart';

@HiveType(typeId: 37)
class Faq extends BaseDomain {
  @HiveField(0)
  String id;

  @HiveField(1)
  String questionTitle;

  @HiveField(2)
  String questionDescription;

  @HiveField(3)
  String answers;

  @HiveField(4)
  String status;

  @HiveField(5)
  DateTime updatedAt;

  Faq(
    this.id,
    this.questionTitle,
    this.questionDescription,
    this.answers,
    this.status,
    this.updatedAt,
  );

  @override
  Faq clone() {
    return Faq(
      this.id,
      this.questionTitle,
      this.questionDescription,
      this.answers,
      this.status,
      this.updatedAt,
    );
  }

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      json['id'],
      json['question_title'],
      json['question_description'],
      json['answer'],
      json['status'],
      DateTime.fromMillisecondsSinceEpoch(json['update_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'question_title': this.questionTitle,
        'question_description': this.questionDescription,
        'answers': this.answers,
        'status': this.status,
        'update_at': updatedAt.millisecondsSinceEpoch,
      };

  static String getName() {
    return 'faq';
  }
}
