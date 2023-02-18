// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomAdapter extends TypeAdapter<Room> {
  @override
  final int typeId = 17;

  @override
  Room read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Room(
      fields[0] as dynamic,
      participants: (fields[17] as List?)?.cast<User>(),
      description: fields[7] as String,
      chats: (fields[18] as List?)?.cast<Chat>(),
      unreadChats: fields[11] as int,
      url: fields[12] as String,
      attachments: (fields[19] as List?)?.cast<File>(),
      isPinned: fields[9] as bool,
      isGroup: fields[10] as bool,
      lastMessageSender: fields[13] as User?,
      lastMessage: fields[14] as String?,
      lastMessageCreatedAt: fields[16] as DateTime?,
      memberCount: fields[20] as String?,
      isOwner: fields[21] as bool?,
      isFavorite: fields[22] as bool?,
      isDeleted: fields[23] as bool?,
      workspaceId: fields[24] as String?,
      uri: fields[1] as dynamic,
      typeName: fields[2] as dynamic,
      type: fields[3] as dynamic,
      name: fields[4] as dynamic,
      fullName: fields[5] as dynamic,
      status: fields[6] as dynamic,
      avatar: fields[255] as dynamic,
    )..lastMessageType = fields[15] as FileType?;
  }

  @override
  void write(BinaryWriter writer, Room obj) {
    writer
      ..writeByte(25)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.isPinned)
      ..writeByte(10)
      ..write(obj.isGroup)
      ..writeByte(11)
      ..write(obj.unreadChats)
      ..writeByte(12)
      ..write(obj.url)
      ..writeByte(13)
      ..write(obj.lastMessageSender)
      ..writeByte(14)
      ..write(obj.lastMessage)
      ..writeByte(15)
      ..write(obj.lastMessageType)
      ..writeByte(16)
      ..write(obj.lastMessageCreatedAt)
      ..writeByte(17)
      ..write(obj.participants)
      ..writeByte(18)
      ..write(obj.chats)
      ..writeByte(19)
      ..write(obj.attachments)
      ..writeByte(20)
      ..write(obj.memberCount)
      ..writeByte(21)
      ..write(obj.isOwner)
      ..writeByte(22)
      ..write(obj.isFavorite)
      ..writeByte(23)
      ..write(obj.isDeleted)
      ..writeByte(24)
      ..write(obj.workspaceId)
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
      other is RoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
