// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mention.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MentionAdapter extends TypeAdapter<Mention> {
  @override
  final int typeId = 47;

  @override
  Mention read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mention(
      fields[0] as dynamic,
      fields[7] as User,
      fields[8] as String,
      fields[9] as DateTime,
      mentionedUsers: (fields[10] as List).cast<User>(),
      object: fields[11] as PhObject?,
      uri: fields[1] as dynamic,
      typeName: fields[2] as dynamic,
      type: fields[3] as dynamic,
      name: fields[4] as dynamic,
      fullName: fields[5] as dynamic,
      status: fields[6] as dynamic,
    )..avatar = fields[255] as String?;
  }

  @override
  void write(BinaryWriter writer, Mention obj) {
    writer
      ..writeByte(13)
      ..writeByte(7)
      ..write(obj.author)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.mentionedUsers)
      ..writeByte(11)
      ..write(obj.object)
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
      other is MentionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
