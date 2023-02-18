import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';

class GiveReactionDBRequest implements GiveReactionRequestInterface {
  String objectId;
  String authorId;
  String reactionId;
  DateTime createdAt;

  GiveReactionDBRequest(
    this.objectId,
    this.authorId,
    this.reactionId,
    this.createdAt,
  );
}
