// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PushNotificationAdapter extends TypeAdapter<PushNotification> {
  @override
  final int typeId = 46;

  @override
  PushNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PushNotification(
      conpherencePHID: fields[0] as String,
      authorPHID: fields[1] as String,
      title: fields[2] as String,
      body: fields[3] as String,
      workspace: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PushNotification obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.conpherencePHID)
      ..writeByte(1)
      ..write(obj.authorPHID)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.workspace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
