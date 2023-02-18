import 'package:mobile_sev2/data/payload/contracts/lobby_request_interface.dart';
import 'package:mobile_sev2/domain/reaction.dart';

class StoreUserReactionToDbRequest implements StoreListReactionToDbRequestInterface {
  Map<String, Reaction> reactions = {};

  StoreUserReactionToDbRequest(this.reactions);
}
