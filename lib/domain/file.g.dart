// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FileAdapter extends TypeAdapter<File> {
  @override
  final int typeId = 5;

  @override
  File read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return File(
      fields[0] as dynamic,
      idInt: fields[7] as int,
      fileType: fields[8] as FileType,
      url: fields[11] as String,
      title: fields[10] as String,
      size: fields[12] as int,
      mimeType: fields[9] as String,
      createdAt: fields[13] as DateTime?,
      author: fields[14] as User?,
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
  void write(BinaryWriter writer, File obj) {
    writer
      ..writeByte(16)
      ..writeByte(7)
      ..write(obj.idInt)
      ..writeByte(8)
      ..write(obj.fileType)
      ..writeByte(9)
      ..write(obj.mimeType)
      ..writeByte(10)
      ..write(obj.title)
      ..writeByte(11)
      ..write(obj.url)
      ..writeByte(12)
      ..write(obj.size)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.author)
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
      other is FileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FileTypeAdapter extends TypeAdapter<FileType> {
  @override
  final int typeId = 6;

  @override
  FileType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FileType.image;
      case 1:
        return FileType.video;
      case 2:
        return FileType.document;
      case 4:
        return FileType.link;
      default:
        return FileType.image;
    }
  }

  @override
  void write(BinaryWriter writer, FileType obj) {
    switch (obj) {
      case FileType.image:
        writer.writeByte(0);
        break;
      case FileType.video:
        writer.writeByte(1);
        break;
      case FileType.document:
        writer.writeByte(2);
        break;
      case FileType.link:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FileTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
