import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';

class GiveReactionApiRequest
    implements GiveReactionRequestInterface, ApiRequestInterface {
  String reactionId;
  String objectId;

  GiveReactionApiRequest(this.reactionId, this.objectId);

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['tokenPHID'] = reactionId;
    req['objectPHID'] = objectId;
    return req;
  }
}
