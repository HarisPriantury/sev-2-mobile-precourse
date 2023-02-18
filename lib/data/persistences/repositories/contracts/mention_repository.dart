import 'package:mobile_sev2/data/payload/contracts/mention_request_interface.dart';
import 'package:mobile_sev2/domain/mention.dart';

abstract class MentionRepository {
  Future<List<Mention>> findAll(GetMentionsRequestInterface params);
}
