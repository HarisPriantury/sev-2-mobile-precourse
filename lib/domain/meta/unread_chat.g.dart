// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnreadChatAdapter extends TypeAdapter<UnreadChat> {
  @override
  final int typeId = 40;

  @override
  UnreadChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnreadChat(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UnreadChat obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.roomId)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnreadChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
