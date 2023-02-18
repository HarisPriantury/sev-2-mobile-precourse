// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatusHistoryAdapter extends TypeAdapter<StatusHistory> {
  @override
  final int typeId = 36;

  @override
  StatusHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatusHistory(
      fields[0] as String,
      fields[1] as String,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StatusHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.action)
      ..writeByte(1)
      ..write(obj.target)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
