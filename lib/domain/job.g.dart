// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JobAdapter extends TypeAdapter<Job> {
  @override
  final int typeId = 7;

  @override
  Job read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Job(
      fields[0] as dynamic,
      fields[7] as String,
      fields[8] as String,
      fields[9] as JobStatus,
      fields[11] as DateTime,
      totalApplicant: fields[10] as int,
      uri: fields[1] as dynamic,
      typeName: fields[2] as dynamic,
      type: fields[3] as dynamic,
      name: fields[4] as dynamic,
      fullName: fields[5] as dynamic,
      status: fields[6] as dynamic,
    )..avatar = fields[255] as String?;
  }

  @override
  void write(BinaryWriter writer, Job obj) {
    writer
      ..writeByte(13)
      ..writeByte(7)
      ..write(obj.occupation)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.jobStatus)
      ..writeByte(10)
      ..write(obj.totalApplicant)
      ..writeByte(11)
      ..write(obj.expiredDate)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uri)
      ..writeByte(2)
      ..write(obj.typeName)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.fullName)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(255)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobApplicationAdapter extends TypeAdapter<JobApplication> {
  @override
  final int typeId = 8;

  @override
  JobApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobApplication(
      fields[0] as Job,
      fields[1] as ApplyStatus,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JobApplication obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.job)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.applyDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobApplicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class JobStatusAdapter extends TypeAdapter<JobStatus> {
  @override
  final int typeId = 9;

  @override
  JobStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return JobStatus.open;
      case 1:
        return JobStatus.expired;
      default:
        return JobStatus.open;
    }
  }

  @override
  void write(BinaryWriter writer, JobStatus obj) {
    switch (obj) {
      case JobStatus.open:
        writer.writeByte(0);
        break;
      case JobStatus.expired:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApplyStatusAdapter extends TypeAdapter<ApplyStatus> {
  @override
  final int typeId = 10;

  @override
  ApplyStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ApplyStatus.sent;
      case 1:
        return ApplyStatus.review;
      case 2:
        return ApplyStatus.rejected;
      case 3:
        return ApplyStatus.accepted;
      default:
        return ApplyStatus.sent;
    }
  }

  @override
  void write(BinaryWriter writer, ApplyStatus obj) {
    switch (obj) {
      case ApplyStatus.sent:
        writer.writeByte(0);
        break;
      case ApplyStatus.review:
        writer.writeByte(1);
        break;
      case ApplyStatus.rejected:
        writer.writeByte(2);
        break;
      case ApplyStatus.accepted:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplyStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
