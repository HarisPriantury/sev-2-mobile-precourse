import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class DeleteWorkspaceDBRequest implements DeleteWorkspaceRequestInterface {
  Workspace workspace;

  DeleteWorkspaceDBRequest(this.workspace);
}