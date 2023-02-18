import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/phobject.dart';

part 'job.g.dart';

@HiveType(typeId: 7)
class Job extends PhObject {
  @HiveField(7)
  String occupation;

  @HiveField(8)
  String description;

  @HiveField(9)
  JobStatus jobStatus;

  @HiveField(10)
  int totalApplicant;

  @HiveField(11)
  DateTime expiredDate;

  Job(id, this.occupation, this.description, this.jobStatus, this.expiredDate,
      {this.totalApplicant = 0, uri, typeName, type, name, fullName, status})
      : super(id,
            uri: uri,
            typeName: typeName,
            type: type,
            name: name,
            fullName: fullName,
            status: status);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'occupation': occupation,
        'description': description,
        'job_status': jobStatus == JobStatus.open ? 'open' : 'expired',
        'total_applicant': totalApplicant,
        'expired_date': expiredDate.millisecondsSinceEpoch,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
      };

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      json['id'],
      json['occupation'],
      json['description'],
      json['job_status'],
      json['expired_date'],
      totalApplicant: json['total_applicant'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
    );
  }

  static String getName() {
    return 'job';
  }

  @override
  clone() {
    return Job(
      this.id,
      this.occupation,
      this.description,
      this.jobStatus,
      this.expiredDate,
      totalApplicant: this.totalApplicant,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
    );
  }
}

@HiveType(typeId: 8)
class JobApplication extends BaseDomain {
  @HiveField(0)
  Job job;

  @HiveField(1)
  ApplyStatus status;

  @HiveField(2)
  DateTime applyDate;

  JobApplication(
    this.job,
    this.status,
    this.applyDate,
  );

  @override
  Map<String, dynamic> toJson() => {
        'job': jsonEncode(job),
        'status': status == ApplyStatus.accepted
            ? 'accepted'
            : status == ApplyStatus.rejected
                ? 'rejected'
                : status == ApplyStatus.review
                    ? 'review'
                    : 'sent',
        'apply_date': applyDate.millisecondsSinceEpoch
      };

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
        jsonDecode(json['job']),
        json['status'] == 'accepted'
            ? ApplyStatus.accepted
            : json['status'] == 'rejected'
                ? ApplyStatus.rejected
                : json['status'] == 'review'
                    ? ApplyStatus.review
                    : ApplyStatus.sent,
        DateTime.fromMillisecondsSinceEpoch(json['apply_date']));
  }

  static String getName() {
    return 'job_application';
  }

  @override
  JobApplication clone() {
    return JobApplication(
      this.job,
      this.status,
      this.applyDate,
    );
  }
}

@HiveType(typeId: 9)
enum JobStatus {
  @HiveField(0)
  open,
  @HiveField(1)
  expired
}

@HiveType(typeId: 10)
enum ApplyStatus {
  @HiveField(0)
  sent,
  @HiveField(1)
  review,
  @HiveField(2)
  rejected,
  @HiveField(3)
  accepted
}
