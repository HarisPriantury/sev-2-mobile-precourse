// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notif_stream.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotifStreamAdapter extends TypeAdapter<NotifStream> {
  @override
  final int typeId = 41;

  @override
  NotifStream read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotifStream(
      fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      target: fields[3] as PhObject?,
      createdAt: fields[6] as DateTime?,
      isRead: fields[4] as bool,
      icon: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotifStream obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.target)
      ..writeByte(4)
      ..write(obj.isRead)
      ..writeByte(5)
      ..write(obj.icon)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotifStreamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
