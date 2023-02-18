import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class UpdateWorkspaceDBRequest implements UpdateWorkspaceRequestInterface {
  Workspace workspace;

  UpdateWorkspaceDBRequest(this.workspace);
}