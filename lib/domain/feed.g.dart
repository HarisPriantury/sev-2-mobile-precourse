// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedAdapter extends TypeAdapter<Feed> {
  @override
  final int typeId = 4;

  @override
  Feed read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Feed(
      fields[0] as dynamic,
      fields[7] as User,
      fields[8] as String,
      fields[9] as DateTime,
      tags: (fields[10] as List?)?.cast<String>(),
      chronoKey: fields[11] as String,
      isRead: fields[12] as bool,
      uri: fields[1] as dynamic,
      typeName: fields[2] as dynamic,
      type: fields[3] as dynamic,
      name: fields[4] as dynamic,
      fullName: fields[5] as dynamic,
      status: fields[6] as dynamic,
    )..avatar = fields[255] as String?;
  }

  @override
  void write(BinaryWriter writer, Feed obj) {
    writer
      ..writeByte(14)
      ..writeByte(7)
      ..write(obj.user)
      ..writeByte(8)
      ..write(obj.content)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.chronoKey)
      ..writeByte(12)
      ..write(obj.isRead)
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
      other is FeedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
