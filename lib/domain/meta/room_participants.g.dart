// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_participants.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomParticipantsAdapter extends TypeAdapter<RoomParticipants> {
  @override
  final int typeId = 35;

  @override
  RoomParticipants read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomParticipants(
      fields[0] as String,
      (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RoomParticipants obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.roomId)
      ..writeByte(1)
      ..write(obj.userIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomParticipantsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
