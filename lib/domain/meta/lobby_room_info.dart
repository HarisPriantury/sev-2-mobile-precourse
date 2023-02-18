import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';

part 'lobby_room_info.g.dart';

@HiveType(typeId: 31)
class LobbyRoomInfo extends BaseDomain {
  @HiveField(0)
  Room room;

  @HiveField(1)
  List<Calendar>? calendars = [];

  @HiveField(2)
  List<File>? files = [];

  @HiveField(3)
  List<Stickit>? stickits = [];

  @HiveField(4)
  List<Ticket>? tickets = [];

  LobbyRoomInfo(
    this.room, {
    this.calendars,
    this.files,
    this.stickits,
    this.tickets,
  });

  @override
  LobbyRoomInfo clone() {
    return LobbyRoomInfo(
      room,
      calendars: calendars,
      files: files,
      stickits: stickits,
      tickets: tickets,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'room': jsonEncode(room),
        'calendars': jsonEncode(calendars),
        'files': jsonEncode(files),
        'tickets': jsonEncode(tickets),
      };

  factory LobbyRoomInfo.fromJson(Map<String, dynamic> json) {
    return LobbyRoomInfo(
      json['id'],
      calendars: (jsonDecode(json['calendars']) as List)
          .map((e) => Calendar.fromJson(e))
          .toList(),
      files: (jsonDecode(json['calendars']) as List)
          .map((e) => File.fromJson(e))
          .toList(),
      tickets: (jsonDecode(json['calendars']) as List)
          .map((e) => Ticket.fromJson(e))
          .toList(),
    );
  }

  static String getName() {
    return 'lobby_room_info';
  }
}
