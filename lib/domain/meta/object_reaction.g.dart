// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_reaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ObjectReactionsAdapter extends TypeAdapter<ObjectReactions> {
  @override
  final int typeId = 33;

  @override
  ObjectReactions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ObjectReactions(
      fields[0] as String,
      fields[1] as User?,
      fields[2] as Reaction,
    );
  }

  @override
  void write(BinaryWriter writer, ObjectReactions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.objectId)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.reaction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectReactionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReactionDataAdapter extends TypeAdapter<ReactionData> {
  @override
  final int typeId = 34;

  @override
  ReactionData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReactionData(
      fields[3] as User?,
      fields[4] as PhObject?,
      fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ReactionData obj) {
    writer
      ..writeByte(3)
      ..writeByte(3)
      ..write(obj.reactor)
      ..writeByte(4)
      ..write(obj.obj)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReactionDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
