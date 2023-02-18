import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';

class GetPublicSpaceApiRequest implements GetPublicSpaceRequestInterface {
  int workspaceId;

  GetPublicSpaceApiRequest({
    required this.workspaceId,
  });
}
