// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkspaceAdapter extends TypeAdapter<Workspace> {
  @override
  final int typeId = 42;

  @override
  Workspace read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workspace(
      fields[0] as String,
      fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Workspace obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.workspaceId)
      ..writeByte(1)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkspaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
