// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phtransaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhTransactionAdapter extends TypeAdapter<PhTransaction> {
  @override
  final int typeId = 13;

  @override
  PhTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhTransaction(
      fields[0] as String,
      fields[1] as int,
      fields[3] as String,
      fields[4] as String,
      fields[5] as PhObject,
      fields[6] as PhObject,
      fields[7] as String,
      fields[8] as DateTime,
      fields[9] as DateTime,
      type: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PhTransaction obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.idInt)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.phobjectId)
      ..writeByte(4)
      ..write(obj.groupId)
      ..writeByte(5)
      ..write(obj.actor)
      ..writeByte(6)
      ..write(obj.target)
      ..writeByte(7)
      ..write(obj.action)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
