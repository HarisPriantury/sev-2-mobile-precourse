// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueryAdapter extends TypeAdapter<Query> {
  @override
  final int typeId = 44;

  @override
  Query read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Query(
      fields[0] as String,
      fields[1] as String,
      (fields[2] as List).cast<PhObject>(),
      (fields[3] as List).cast<PhObject>(),
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Query obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.queryName)
      ..writeByte(1)
      ..write(obj.keyword)
      ..writeByte(2)
      ..write(obj.authoredBy)
      ..writeByte(3)
      ..write(obj.subscribedBy)
      ..writeByte(4)
      ..write(obj.documentType)
      ..writeByte(5)
      ..write(obj.documentStatus)
      ..writeByte(6)
      ..write(obj.workspace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
