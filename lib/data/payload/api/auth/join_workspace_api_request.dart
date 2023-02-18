import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';

class JoinWorkspaceApiRequest implements JoinWorkspaceRequestInterface {
  String workspaceName;
  int userId;
  String accessToken;

  JoinWorkspaceApiRequest({
    required this.workspaceName,
    required this.userId,
    required this.accessToken,
  });
}
