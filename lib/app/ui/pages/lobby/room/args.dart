import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/room.dart';

class LobbyRoomArgs implements BaseArgs {
  Room room;
  String? from;
  RoomType type;

  LobbyRoomArgs(this.room, {this.type = RoomType.voice, this.from});

  @override
  String toPrint() {
    return "LobbyRoomArgs data: room ${room.id}";
  }
}

enum RoomType {
  voice,
  chat,
}
