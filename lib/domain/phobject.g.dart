// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phobject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhObjectAdapter extends TypeAdapter<PhObject> {
  @override
  final int typeId = 12;

  @override
  PhObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhObject(
      fields[0] as String,
      uri: fields[1] as String?,
      typeName: fields[2] as String?,
      type: fields[3] as String?,
      name: fields[4] as String?,
      fullName: fields[5] as String?,
      status: fields[6] as String?,
      avatar: fields[255] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PhObject obj) {
    writer
      ..writeByte(8)
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
      other is PhObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
