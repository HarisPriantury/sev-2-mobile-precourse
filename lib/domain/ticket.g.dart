// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TicketAdapter extends TypeAdapter<Ticket> {
  @override
  final int typeId = 20;

  @override
  Ticket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ticket(
      fields[0] as dynamic,
      code: fields[7] as String,
      description: fields[8] as String,
      priority: fields[9] as String,
      ticketStatus: fields[10] as TicketStatus,
      storyPoint: fields[11] as double,
      project: fields[12] as Project?,
      createdAt: fields[13] as DateTime?,
      subscriberInfo: fields[14] as TicketSubscriberInfo?,
      assignee: fields[15] as User?,
      author: fields[16] as User?,
      rawStatus: fields[17] as String?,
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
  void write(BinaryWriter writer, Ticket obj) {
    writer
      ..writeByte(19)
      ..writeByte(7)
      ..write(obj.code)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.priority)
      ..writeByte(10)
      ..write(obj.ticketStatus)
      ..writeByte(11)
      ..write(obj.storyPoint)
      ..writeByte(12)
      ..write(obj.project)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.subscriberInfo)
      ..writeByte(15)
      ..write(obj.assignee)
      ..writeByte(16)
      ..write(obj.author)
      ..writeByte(17)
      ..write(obj.rawStatus)
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
      other is TicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TicketSubscriberInfoAdapter extends TypeAdapter<TicketSubscriberInfo> {
  @override
  final int typeId = 21;

  @override
  TicketSubscriberInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketSubscriberInfo(
      (fields[0] as List).cast<String>(),
      fields[1] as int,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TicketSubscriberInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.subscriberIds)
      ..writeByte(1)
      ..write(obj.totalSubscriber)
      ..writeByte(2)
      ..write(obj.totalRSP);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketSubscriberInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TicketProjectInfoAdapter extends TypeAdapter<TicketProjectInfo> {
  @override
  final int typeId = 48;

  @override
  TicketProjectInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TicketProjectInfo(
      (fields[0] as List).cast<String>(),
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TicketProjectInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.projectIds)
      ..writeByte(1)
      ..write(obj.totalProject);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketProjectInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TicketStatusAdapter extends TypeAdapter<TicketStatus> {
  @override
  final int typeId = 22;

  @override
  TicketStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TicketStatus.open;
      case 1:
        return TicketStatus.resolved;
      default:
        return TicketStatus.open;
    }
  }

  @override
  void write(BinaryWriter writer, TicketStatus obj) {
    switch (obj) {
      case TicketStatus.open:
        writer.writeByte(0);
        break;
      case TicketStatus.resolved:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
