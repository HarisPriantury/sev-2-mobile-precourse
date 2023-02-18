import 'dart:developer';

import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

class ProjectMapper {
  DateUtilInterface _dateUtil;

  ProjectMapper(this._dateUtil);

  List<Project> convertGetProjectsApiResponse(Map<String, dynamic> response) {
    var projects = List<Project>.empty(growable: true);

    var data = response['result']['data'];
    for (var project in data) {
      var members = List<User>.empty(growable: true);
      project['attachments']['members']['members'].forEach((member) {
        members.add(User(
          member['phid'],
        ));
      });
      projects.add(
        Project(
          project['phid'],
          project['fields']['imageUrl'],
          [],
          name: project['fields']['name'],
          fullName: project['fields']['name'],
          isGroup: project['fields']['icon']['key'] == 'group',
          description: project['fields']['description'] ?? "",
          isForRsp: project['fields']['isForRsp'],
          isForDev: project['fields']['isForDev'],
          isArchived: project['fields']['isArchived'],
          isMilestone:
              project['fields']['icon']['key'] == 'milestone' ? true : false,
          members: members,
          intId: project['id'],
          depth: project['fields']['depth'],
          viewPolicy: project['fields']['policy']['view'],
          editPolicy: project['fields']['policy']['edit'],
          startDate: project['fields']['startDate'] != null
              ? _dateUtil
                  .fromMilliseconds(project['fields']['startDate'] * 1000)
              : null,
          endDate: project['fields']['endDate'] != null
              ? _dateUtil.fromMilliseconds(project['fields']['endDate'] * 1000)
              : null,
        ),
      );
    }
    return projects;
  }

  List<ProjectColumn> convertGetProjectColumnsApiResponse(
      Map<String, dynamic> response) {
    var columns = List<ProjectColumn>.empty(growable: true);

    var data = response['result']['data'];
    for (var col in data) {
      columns.add(ProjectColumn(col['phid'], col['fields']['name']));
    }
    return columns;
  }

  List<ProjectColumn> convertGetProjectColumnTicketApiResponse(
      Map<String, dynamic> response) {
    var columns = List<ProjectColumn>.empty(growable: true);

    var data = response['result']['data'];
    for (var col in data) {
      var tasks = List<Ticket>.empty(growable: true);
      if (col['tasks'].length != 0) {
        for (var task in col['tasks']) {
          tasks.add(Ticket(
            task['phid'],
            code: 'T${task["id"]}',
            name: task['title'],
            description: task['description'],
            priority: task['priority']['name'],
            storyPoint:
                task['points'] == null ? 0 : double.parse(task['points']),
            intId: int.parse(task['id']),
            ticketStatus: task['status']['value'] == "open"
                ? TicketStatus.open
                : TicketStatus.resolved,
            rawStatus: task['status']['name'],
            assignee: task['ownerPHID'] != null
                ? User(task['ownerPHID'], name: task['assigned'])
                : null,
            author: User(task['authorPHID']),
            avatar: task['assignedProfileImageURI'],
          ));
        }
      }
      columns.add(ProjectColumn(
        col['phid'],
        col['name'],
        type: col['type'],
        isMilestone: col['isMilestone'],
        visibility: col['visibility'],
        sequence: int.parse(col['sequence']),
        properties: col['properties'] == null
            ? null
            : Map<String, dynamic>.from(col['properties']),
        dateCreated: _dateUtil.fromSeconds(int.parse(col['dateCreated'])),
        dateModified: _dateUtil.fromSeconds(int.parse(col['dateModified'])),
        tasks: tasks,
      ));
    }
    return columns;
  }

  List<BaseApiResponse> convertMoveTicketResponse(
      Map<String, dynamic> response) {
    var objects = List<BaseApiResponse>.empty(growable: true);
    var data = response['result']['message'];
    if (data != null) {
      data.forEach((value) {
        objects.add(BaseApiResponse(value.toString()));
      });
    }
    return objects;
  }

  BaseApiResponse convertEditColumnResponse(Map<String, dynamic> response) {
    return BaseApiResponse(
      response['result']['message'],
    );
  }

  BaseApiResponse convertReorderColumnResponse(Map<String, dynamic> response) {
    return BaseApiResponse(
      response['result']['message'],
    );
  }

  BaseApiResponse convertCreateColumnResponse(Map<String, dynamic> response) {
    return BaseApiResponse(
      response['result']['message'],
    );
  }

  BaseApiResponse convertCreateProjectApiResponse(
      Map<String, dynamic> response) {
    var data = response['result']['object'];
    return BaseApiResponse(data['phid']);
  }

  BaseApiResponse convertSetProjectStatusResponse(
      Map<String, dynamic> response) {
    return BaseApiResponse(
      response['result']['message'],
    );
  }

  BaseApiResponse convertCreateMilestoneResponse(
      Map<String, dynamic> response) {
    return BaseApiResponse(
      response['result'] != null
          ? response['result']['message'] ?? ''
          : response['error_info'],
      errorCode: response['error_code'],
      errorResult: response['error_info'],
    );
  }
}
