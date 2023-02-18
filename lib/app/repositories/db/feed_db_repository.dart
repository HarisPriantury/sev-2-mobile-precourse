import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/feed_repository_interface.dart';
import 'package:mobile_sev2/domain/feed.dart';

class FeedDBRepository implements FeedRepository {
  Box<Feed> _box;

  FeedDBRepository(this._box);

  @override
  Future<List<Feed>> findAll(GetFeedsRequestInterface params) {
    var feeds = _box.values.toList();
    return Future.value(feeds);
  }
}
