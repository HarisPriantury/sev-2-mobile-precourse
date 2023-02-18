import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class CreateMilestoneApiRequest
    implements CreateMilestoneRequestInterface, ApiRequestInterface {
  String projectId;
  String name;
  String? description;
  String? hashtag;
  int? start;
  int? end;

  CreateMilestoneApiRequest({
    required this.projectId,
    required this.name,
    this.description,
    this.hashtag,
    this.start,
    this.end,
  });

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    req['projectPHID'] = this.projectId;
    req['name'] = this.name;

    if (description != null) req['description'] = this.description;
    if (hashtag != null) req['hashtags'] = this.hashtag;
    if (start != null) req['start'] = this.start;
    if (end != null) req['end'] = this.end;

    return req;
  }
}
