import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';

class GetWorkspaceApiRequest implements GetWorkspaceRequestInterface {
  RequestType requestType;
  int? userId;
  String accessToken;

  GetWorkspaceApiRequest({
    required this.requestType,
    this.userId,
    required this.accessToken,
  });
}

enum RequestType {
  all,
  belonged,
}
