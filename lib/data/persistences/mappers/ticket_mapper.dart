import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

class TicketMapper {
  DateUtilInterface _dateUtil;

  TicketMapper(this._dateUtil);

  List<Ticket> convertGetTicketsApiResponse(Map<String, dynamic> response) {
    var tickets = List<Ticket>.empty(growable: true);

    if (response['result'] == null) return tickets;

    var data = response['result']['data'];
    for (var ticket in data) {
      var field = ticket['fields'];
      var t = Ticket(
        ticket['phid'],
        code: 'T${ticket["id"]}',
        name: field['name'],
        description: field['description']['raw'],
        htmlDescription: field['htmlDescription'],
        priority: field['priority']['name'],
        storyPoint: field['points'] == null ? 0 : double.parse(field['points']),
        createdAt: _dateUtil.fromSeconds(field['dateCreated']),
        intId: ticket['id'],
        ticketStatus: field['status']['value'] == "open"
            ? TicketStatus.open
            : TicketStatus.resolved,
        rawStatus: field['status']['name'],
        assignee: field['ownerPHID'] != null
            ? User(field['ownerPHID'], name: field['assigned'])
            : null,
        author: User(field['authorPHID']),
        subtype: field['subtype'],
      );

      var subtasks = List<Ticket>.empty(growable: true);
      for (var subtask in field['subTasks']) {
        subtasks.add(Ticket(subtask['phid'],
            code: 'T${subtask["id"]}',
            name: subtask['title'],
            author: User(subtask['authorPHID']),
            assignee: subtask['ownerPHID'] != null
                ? User(subtask['ownerPHID'], name: subtask['assigned'])
                : null,
            status: subtask['status']['name'],
            priority: subtask['priority']['name']));
      }
      t.subTasks = subtasks;
      var parentasks = List<Ticket>.empty(growable: true);
      for (var parentask in field['parents']) {
        parentasks.add(Ticket(parentask['phid'],
            code: 'T${parentask["id"]}',
            name: parentask['title'],
            author: User(parentask['authorPHID']),
            assignee: parentask['ownerPHID'] != null
                ? User(parentask['ownerPHID'], name: parentask['assigned'])
                : null,
            status: parentask['status']['name'],
            priority: parentask['priority']['name']));
      }
      t.parentTask = parentasks;
      var project = ticket['attachments']['projects'];
      if (project != null) {
        if (project != null && (project['projectPHIDs'] as List).isNotEmpty) {
          var p = Project(
            project['projectPHIDs'][0],
            project['profileImageUri'],
            [],
            name: project['name'],
            fullName: project['name'],
          );

          t.project = p;
        }

        var projects = List<Project>.empty(growable: true);
        for (var a in project['projectPHIDs']) {
          projects.add(Project(
            a,
            project['profileImageUri'],
            [],
            name: project['name'],
            fullName: project['name'],
          ));
        }
        t.projectList = projects;
      }
      tickets.add(t);
    }

    return tickets;
  }

  TicketSubscriberInfo convertGetTicketInfoApiResponse(
      Map<String, dynamic> response) {
    List<String> subsId = List.empty(growable: true);
    for (var id in response['result']['ccPHIDs']) {
      subsId.add(id);
    }
    return TicketSubscriberInfo(subsId, subsId.length, 0);
  }

  TicketProjectInfo convertGetTicketProjectInfoApiResponse(
      Map<String, dynamic> response) {
    List<String> projectsId = List.empty(growable: true);
    for (var id in response['result']['projectPHIDs']) {
      projectsId.add(id);
    }
    return TicketProjectInfo(projectsId, projectsId.length);
  }
}
