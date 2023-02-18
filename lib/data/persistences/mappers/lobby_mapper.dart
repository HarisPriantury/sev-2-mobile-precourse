import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

class LobbyMapper with DataUtil {
  DateUtilInterface _dateUtil;
  String _workspace;

  LobbyMapper(
    this._dateUtil,
    this._workspace,
  );

  List<User> convertGetLobbyParticipantsApiResponse(
      Map<String, dynamic> response) {
    var users = List<User>.empty(growable: true);
    var data = response['result']['data'];
    for (var user in data) {
      String completeName = user['fields']['owner']['username'];
      List<String> names = completeName.split('(');
      names.last = names.last.split(')').first;
      users.add(User(
        user['fields']['ownerPHID'],
        intId: user['id'],
        isWorking: user['fields']['isWorking'],
        name: names.first.removeLast(),
        fullName: names.last,
        // name: user['fields']['owner']['username'],
        // fullName: user['fields']['owner']['username'],
        avatar: user['fields']['owner']['profile_image_uri'],
        device: user['fields']['device'],
        status: user['fields']['status'],
        userStatus: user['fields']['status_text'],
        currentChannel: user['fields']['channel'],
        currentTask: user['fields']['state'] != null
            ? user['fields']['state']['currentTask']
            : "",
      ));
    }

    return users;
  }

  List<Room> convertGetLobbyRoomsApiResponse(Map<String, dynamic> response) {
    var rooms = List<Room>.empty(growable: true);

    var data = response['result'];
    if (data != null) {
      data.forEach((key, value) {
        rooms.add(_convertLobbyRoom(value));
      });
    }

    return rooms;
  }

  Room convertGetRoomHQApiResponse(Map<String, dynamic> response) {
    var rooms = List<Room>.empty(growable: true);

    var data = response['result'];
    if (data != null) {
      data.forEach((key, value) {
        rooms.add(_convertLobbyRoom(value));
      });
    }

    return rooms.first;
  }

  Room _convertLobbyRoom(Map<String, dynamic> value) {
    List<User> members = List<User>.empty(growable: true);
    var room = Room(
      value['conpherencePHID'],
      name: value['conpherenceTitle'],
      url: value['conpherenceURI'],
      isGroup: this.isGroup(value['memberCount']),
      description: value['channelTopic'],
      memberCount: value['memberCount'],
      isFavorite: value['isFavorite'],
      isOwner: value['isOwner'],
      isDeleted: value['isDeleted'] == 1 ? true : false,
      isJoinable: value['isJoinable'],
      workspaceId: _workspace,
    );

    value['members'].forEach((m) {
      members.add(User(
        m['userPHID'],
        fullName: m['fullname'],
        name: m['username'],
        currentTask: m['currentTask'],
        status: m['status'],
        avatar: m['profileImageURI'],
        device: m['device'],
        userStatus: m['currentTask'] != null ? m['currentTask'] : m['status'],
      ));
    });

    room.participants = members;
    return room;
  }

  List<File> convertGetFilesApiResponse(Map<String, dynamic> response) {
    var files = List<File>.empty(growable: true);

    var data = response['result']['data'];
    for (var file in data) {
      files.add(File(
        "",
        idInt: 0,
        title: file['name'],
        name: file['name'],
        fullName: file['name'],
        fileType: getFileType(file['mimeType']),
        url: file['dataURI'],
        createdAt: _dateUtil.fromSeconds(int.parse(file['createdAt'])),
        size: file['size'],
        author: User(
          file['author']['phid'],
          name: file['author']['username'],
          fullName: file['author']['fullname'],
          avatar: file['author']['profileImageURI'],
        ),
      ));
    }
    return files;
  }

  List<Stickit> convertGetStickitsApiResponse(Map<String, dynamic> response) {
    var stickits = List<Stickit>.empty(growable: true);

    var data = response['result']['data'];
    for (var st in data) {
      var stickit = Stickit(
        st['phid'],
        User(
          st['owner']['phid'],
          name: st['owner']['username'],
          fullName: st['owner']['fullname'],
          avatar: st['owner']['profileImageURI'],
        ),
        st['type'],
        st['content'],
        st['htmlContent'],
        st['seenCount'],
        _dateUtil.fromSeconds(int.parse(st['dateCreated'])),
        name: st['title'],
      );

      var spectators = List<User>.empty(growable: true);
      st['seenProfile'].forEach((p) {
        spectators.add(User(p['phid'],
            name: p['username'],
            fullName: p['fullname'],
            avatar: p['profileImageURI']));
      });

      stickit.spectators = spectators;
      stickits.add(stickit);
    }
    return stickits;
  }

  List<Ticket> convertGetTicketsApiResponse(Map<String, dynamic> response) {
    var tickets = List<Ticket>.empty(growable: true);

    var data = response['result']['data'];
    for (var ticket in data) {
      var t = Ticket(
        ticket['phid'],
        code: 'T${ticket["id"]}',
        description: ticket['description'],
        priority: ticket['priority']['name'],
        storyPoint:
            ticket['points'] == null ? 0 : double.parse(ticket['points']),
        createdAt: ticket['dateCreated'] != null
            ? _dateUtil.fromSeconds(ticket['dateCreated'])
            : _dateUtil.now(),
        name: ticket['title'],
        intId: int.parse(ticket['id']),
        ticketStatus: ticket['status']['value'] == "open"
            ? TicketStatus.open
            : TicketStatus.resolved,
        rawStatus: ticket['status']['name'],
        assignee: ticket['ownerPHID'] != null
            ? User(ticket['ownerPHID'], name: ticket['assigned'])
            : null,
        author:
            ticket['authorPHID'] != null ? User(ticket['authorPHID']) : null,
        position: ticket['position'],
      );

      if (ticket['project'] != null) {
        t.project = Project(
          ticket['project']['phid'],
          ticket['project']['profileImageURI'],
          [],
          name: ticket['project']['name'],
          fullName: ticket['project']['name'],
        );
      }

      tickets.add(t);
    }
    return tickets;
  }

  List<LobbyStatus> convertGetLobbyStatusesApiResponse(
      Map<String, dynamic> response) {
    var statuses = List<LobbyStatus>.empty(growable: true);

    var data = response['result']['data'];
    for (var st in data) {
      statuses.add(LobbyStatus(
        st['id'],
        st['status'],
        st['icon'],
      ));
    }
    return statuses;
  }

  bool isGroup(String mCount) {
    var counts = mCount.split("/");
    return int.parse(counts[1]) > 2;
  }
}
