// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_room_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LobbyRoomInfoAdapter extends TypeAdapter<LobbyRoomInfo> {
  @override
  final int typeId = 31;

  @override
  LobbyRoomInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LobbyRoomInfo(
      fields[0] as Room,
      calendars: (fields[1] as List?)?.cast<Calendar>(),
      files: (fields[2] as List?)?.cast<File>(),
      stickits: (fields[3] as List?)?.cast<Stickit>(),
      tickets: (fields[4] as List?)?.cast<Ticket>(),
    );
  }

  @override
  void write(BinaryWriter writer, LobbyRoomInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.room)
      ..writeByte(1)
      ..write(obj.calendars)
      ..writeByte(2)
      ..write(obj.files)
      ..writeByte(3)
      ..write(obj.stickits)
      ..writeByte(4)
      ..write(obj.tickets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LobbyRoomInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
