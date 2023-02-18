// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryAdapter extends TypeAdapter<SearchHistory> {
  @override
  final int typeId = 43;

  @override
  SearchHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHistory(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.keyword)
      ..writeByte(1)
      ..write(obj.filterType)
      ..writeByte(2)
      ..write(obj.workspace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
