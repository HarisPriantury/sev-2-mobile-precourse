import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';

abstract class TopicRepository {
  Future<void> subscribe(SubscribeTopicRequestInterface request);

  Future<void> unsubscribe(SubscribeTopicRequestInterface request);

  Future<List<Topic>> subscribeList(SubscribeListRequestInterface request);
}
