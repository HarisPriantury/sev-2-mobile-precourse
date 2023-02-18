// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  final int typeId = 18;

  @override
  Setting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setting(
      currentTask: fields[1] as String?,
      bookmarkedRooms: (fields[2] as List?)?.cast<String>(),
      hasUnopenedNotification: fields[3] as bool?,
      hasUnreadChats: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.currentTask)
      ..writeByte(2)
      ..write(obj.bookmarkedRooms)
      ..writeByte(3)
      ..write(obj.hasUnopenedNotification)
      ..writeByte(4)
      ..write(obj.hasUnreadChats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PhoneAdapter extends TypeAdapter<Phone> {
  @override
  final int typeId = 38;

  @override
  Phone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Phone(
      fields[0] as String,
      fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Phone obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.phone)
      ..writeByte(1)
      ..write(obj.isPrimary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmailAdapter extends TypeAdapter<Email> {
  @override
  final int typeId = 39;

  @override
  Email read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Email(
      fields[0] as String,
      fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Email obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.isPrimary);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
