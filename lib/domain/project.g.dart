// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 15;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      fields[0] as dynamic,
      fields[7] as String,
      (fields[12] as List).cast<Ticket>(),
      totalTickets: fields[8] as int,
      totalStoryPoints: fields[9] as double,
      totalFinishedStoryPoints: fields[10] as double,
      totalRSP: fields[11] as int,
      uri: fields[1] as dynamic,
      typeName: fields[2] as dynamic,
      type: fields[3] as dynamic,
      name: fields[4] as dynamic,
      fullName: fields[5] as dynamic,
      status: fields[6] as dynamic,
      avatar: fields[255] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(14)
      ..writeByte(7)
      ..write(obj.image)
      ..writeByte(8)
      ..write(obj.totalTickets)
      ..writeByte(9)
      ..write(obj.totalStoryPoints)
      ..writeByte(10)
      ..write(obj.totalFinishedStoryPoints)
      ..writeByte(11)
      ..write(obj.totalRSP)
      ..writeByte(12)
      ..write(obj.tickets)
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
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
