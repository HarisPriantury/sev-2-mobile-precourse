import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/persistences/mappers/room_mapper.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

import '../../../response/response.dart';

void main() {
  group("RoomMapper test", () {
    late RoomMapper roomMapper;

    setUp(() {
      roomMapper = RoomMapper('refactory');
    });

    test("convertGetRoomsApiResponse test", () {
      List<Room> rooms = roomMapper.convertGetRoomsApiResponse(jsonDecode(roomResponse));
      expect(rooms, TypeMatcher<List<Room>>());
      expect(rooms.length > 0, true);
      expect(rooms.first.id, "PHID-CONP-2c6ri7vqzn2vgg6eqzor");
      expect(rooms.first.isDeleted, false);
    });

    test("convertGetParticipantsApiResponse test", () {
      List<User> participants = roomMapper.convertGetParticipantsApiResponse(jsonDecode(roomParticipantResponse));
      expect(participants, TypeMatcher<List<User>>());
      expect(participants.length > 0, true);
      expect(participants.first.id, "PHID-USER-qc6hgswzgg4dknemwxk3");
      expect(participants.first.name, "dedi");
    });
  });
}