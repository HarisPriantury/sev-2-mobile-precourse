// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 2;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat(
      fields[0] as dynamic,
      fields[8] as DateTime,
      fields[9] as String,
      fields[10] as bool,
      fields[11] as String,
      sender: fields[7] as User?,
      attachments: (fields[12] as List?)?.cast<File>(),
      reactions: (fields[13] as List?)?.cast<Reaction>(),
      quotedChat: fields[14] as QuotedChat?,
      uri: fields[1] as dynamic,
      typeName: fields[2] as dynamic,
      type: fields[3] as dynamic,
      name: fields[4] as dynamic,
      fullName: fields[5] as dynamic,
      status: fields[6] as dynamic,
      avatar: fields[255] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(16)
      ..writeByte(7)
      ..write(obj.sender)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.message)
      ..writeByte(10)
      ..write(obj.isFromSystem)
      ..writeByte(11)
      ..write(obj.roomId)
      ..writeByte(12)
      ..write(obj.attachments)
      ..writeByte(13)
      ..write(obj.reactions)
      ..writeByte(14)
      ..write(obj.quotedChat)
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
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuotedChatAdapter extends TypeAdapter<QuotedChat> {
  @override
  final int typeId = 3;

  @override
  QuotedChat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuotedChat(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuotedChat obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuotedChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
