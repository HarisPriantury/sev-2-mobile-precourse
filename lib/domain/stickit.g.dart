// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stickit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StickitAdapter extends TypeAdapter<Stickit> {
  @override
  final int typeId = 19;

  @override
  Stickit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stickit(
      fields[0] as dynamic,
      fields[7] as User,
      fields[8] as String,
      fields[9] as String,
      fields[10] as String,
      fields[11] as int,
      fields[12] as DateTime,
      spectators: (fields[13] as List?)?.cast<User>(),
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
  void write(BinaryWriter writer, Stickit obj) {
    writer
      ..writeByte(15)
      ..writeByte(7)
      ..write(obj.author)
      ..writeByte(8)
      ..write(obj.stickitType)
      ..writeByte(9)
      ..write(obj.plainContent)
      ..writeByte(10)
      ..write(obj.htmlContent)
      ..writeByte(11)
      ..write(obj.seenCount)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.spectators)
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
      other is StickitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
