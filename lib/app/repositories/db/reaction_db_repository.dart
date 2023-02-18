import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/reaction/get_object_reactions_db_request.dart';
import 'package:mobile_sev2/data/payload/db/reaction/give_reaction_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/reaction_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/user.dart';

class ReactionDBRepository implements ReactionRepository {
  Box<Reaction> _box;
  Box<ObjectReactions> _rdBox;

  ReactionDBRepository(this._box, this._rdBox);

  @override
  Future<List<Reaction>> findAll(GetReactionsRequestInterface params) {
    var reactions = _box.values.toList(growable: true);
    return Future.value(reactions);
  }

  @override
  Future<List<ObjectReactions>> findObjectReactions(GetObjectReactionsRequestInterface params) {
    var request = params as GetObjectReactionsDBRequest;
    var data = _rdBox.get(request.objectId);
    List<ObjectReactions> result = [];
    if (data != null) result.add(data);

    return Future.value(result);
  }

  @override
  Future<bool> give(GiveReactionRequestInterface request) {
    var params = request as GiveReactionDBRequest;
    var objReaction = _rdBox.get(params.objectId);

    if (objReaction == null) {
      objReaction = ObjectReactions(
        params.objectId,
        User(params.authorId),
        Reaction(params.reactionId),
      );
    }

    // objReaction.reactionData.add(ReactionData(User(params.authorId), PhObject(params.objectId), params.createdAt));

    _rdBox.put(params.objectId, objReaction);
    return Future.value(true);
  }
}
