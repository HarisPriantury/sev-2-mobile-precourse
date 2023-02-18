import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/project.dart';

class ProjectColumnSearchArgs implements BaseArgs {
  String objectType;
  String title;
  String placeholderText;
  String? projectId;
  ProjectColumnSearchType type;
  List<ProjectColumn> projectColumn;
  List<PhObject>? selectedBefore;
  List<String>? ticketIds;

  ProjectColumnSearchArgs(
    this.objectType, {
    required this.title,
    required this.placeholderText,
    this.type = ProjectColumnSearchType.moveTicketToProject,
    required this.projectColumn,
    this.selectedBefore,
    this.ticketIds,
    this.projectId,
  });

  @override
  String toPrint() {
    return "ProjectColumnSearchArgs data: $title, $placeholderText, $type, ${projectColumn.map((e) => e.name)}}";
  }
}

enum ProjectColumnSearchType {
  moveTicketToProject,
  moveTicketToColumn,
  moveOnWorkboard
}
