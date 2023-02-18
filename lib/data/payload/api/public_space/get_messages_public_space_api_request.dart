import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';

class GetMessagesPublicSpaceApiRequest implements GetMessagesPublicSpaceRequestInterface {
  int workspaceId;
  int limit;
  int offset;

  GetMessagesPublicSpaceApiRequest({
    required this.workspaceId,
    required this.limit,
    required this.offset,
  });
}
