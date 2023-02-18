import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/reaction.dart';

abstract class ReactionRepository {
  Future<bool> give(GiveReactionRequestInterface request);
  Future<List<Reaction>> findAll(GetReactionsRequestInterface params);
  Future<List<ObjectReactions>> findObjectReactions(
      GetObjectReactionsRequestInterface params);
}
