// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationAdapter extends TypeAdapter<Notification> {
  @override
  final int typeId = 11;

  @override
  Notification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notification(
      fields[0] as dynamic,
      title: fields[7] as String,
      description: fields[8] as String,
      createdAt: fields[13] as DateTime?,
      isRead: fields[9] as bool,
      url: fields[10] as String,
      icon: fields[11] as String,
      chronoKey: fields[12] as String,
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
  void write(BinaryWriter writer, Notification obj) {
    writer
      ..writeByte(15)
      ..writeByte(7)
      ..write(obj.title)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.isRead)
      ..writeByte(10)
      ..write(obj.url)
      ..writeByte(11)
      ..write(obj.icon)
      ..writeByte(12)
      ..write(obj.chronoKey)
      ..writeByte(13)
      ..write(obj.createdAt)
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
      other is NotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
