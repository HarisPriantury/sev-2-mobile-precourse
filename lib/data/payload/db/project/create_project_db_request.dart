import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';

class CreateProjectDBRequest implements CreateProjectRequestInterface {
  Project project;

  CreateProjectDBRequest(this.project);
}
