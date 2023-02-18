// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarAdapter extends TypeAdapter<Calendar> {
  @override
  final int typeId = 1;

  @override
  Calendar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calendar(
      fields[0] as dynamic,
      fields[7] as String,
      fields[8] as User,
      fields[9] as bool,
      fields[10] as bool,
      fields[11] as DateTime,
      fields[12] as DateTime,
      fields[13] as bool,
      fields[14] as String,
      untilTime: fields[15] as DateTime?,
      frequency: fields[16] as String?,
      invitees: (fields[17] as List?)?.cast<User>(),
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
  void write(BinaryWriter writer, Calendar obj) {
    writer
      ..writeByte(19)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.host)
      ..writeByte(9)
      ..write(obj.isCancelled)
      ..writeByte(10)
      ..write(obj.isRecurring)
      ..writeByte(11)
      ..write(obj.startTime)
      ..writeByte(12)
      ..write(obj.endTime)
      ..writeByte(13)
      ..write(obj.isAllDay)
      ..writeByte(14)
      ..write(obj.label)
      ..writeByte(15)
      ..write(obj.untilTime)
      ..writeByte(16)
      ..write(obj.frequency)
      ..writeByte(17)
      ..write(obj.invitees)
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
      other is CalendarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
