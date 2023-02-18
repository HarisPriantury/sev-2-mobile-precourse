import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';
import 'package:mobile_sev2/domain/feed.dart';

abstract class FeedRepository {
  Future<List<Feed>> findAll(GetFeedsRequestInterface params);
}
