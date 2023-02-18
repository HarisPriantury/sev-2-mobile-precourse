import 'package:mobile_sev2/domain/base.dart';

class Contribution extends BaseDomain {
  String? title;
  int? level;
  DateTime? epoch;
  int? seconds;
  int? hours;

  Contribution({
    this.title,
    this.level,
    this.epoch,
    this.seconds,
    this.hours,
  });

  @override
  clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() => {
     "title": title,
        "level": level,
        "epoch": epoch!.millisecondsSinceEpoch,
        "seconds": seconds,
        "hours": hours,
  };

  factory Contribution.fromJson(Map<String, dynamic> json) => Contribution(
        title: json["title"],
        level: json["level"],
        epoch: DateTime.fromMillisecondsSinceEpoch(json["epoch"]),
        seconds: json["seconds"],
        hours: json["hours"],
      );
}
