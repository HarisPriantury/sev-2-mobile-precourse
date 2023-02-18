// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReactionAdapter extends TypeAdapter<Reaction> {
  @override
  final int typeId = 16;

  @override
  Reaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reaction(
      fields[0] as String,
      name: fields[1] as String?,
      emoticon: fields[2] as String?,
      color: fields[3] as Color?,
    );
  }

  @override
  void write(BinaryWriter writer, Reaction obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.emoticon)
      ..writeByte(3)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
