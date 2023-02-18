// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LobbyStatusAdapter extends TypeAdapter<LobbyStatus> {
  @override
  final int typeId = 32;

  @override
  LobbyStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LobbyStatus(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LobbyStatus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LobbyStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
