import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

class RoomMapper {
  String _workspace;

  RoomMapper(this._workspace);

  List<Room> convertGetRoomsApiResponse(Map<String, dynamic> response) {
    var rooms = List<Room>.empty(growable: true);

    var data = response['result'];
    if (data != null) {
      data.forEach(
        (key, value) {
          rooms.add(
            Room(
              value['conpherencePHID'],
              name: value['conpherenceTitle'],
              url: value['conpherenceURI'],
              avatar: value['conpherenceImageURI'],
              isDeleted: value['isDeleted'] == 1 ? true : false,
              workspaceId: _workspace,
              isJoinable: value['isJoinable'],
              participantCount: value['memberCount'],
            ),
          );
        },
      );
    }

    return rooms;
  }

  List<User> convertGetParticipantsApiResponse(Map<String, dynamic> response) {
    var users = List<User>.empty(growable: true);
    var data = response['result']['data'];
    for (var user in data) {
      users.add(
        User(
          user['phid'],
          name: user['username'],
          fullName: user['fullname'],
          avatar: user['profileImageURI'],
        ),
      );
    }

    return users;
  }

  BaseApiResponse convertCreateRoomApiResponse(Map<String, dynamic> response) {
    var data = response['result']['object'];
    return BaseApiResponse(data['phid']);
  }
}
