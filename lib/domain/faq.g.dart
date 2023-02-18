// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FaqAdapter extends TypeAdapter<Faq> {
  @override
  final int typeId = 37;

  @override
  Faq read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Faq(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Faq obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionTitle)
      ..writeByte(2)
      ..write(obj.questionDescription)
      ..writeByte(3)
      ..write(obj.answers)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
