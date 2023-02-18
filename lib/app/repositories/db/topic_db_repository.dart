import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/topic/SubscribeListDBRequest.dart';
import 'package:mobile_sev2/data/payload/db/topic/subscribe_topic_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/topic_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';

class TopicDBRepository implements TopicRepository {
  Box<Topic> _box;

  TopicDBRepository(this._box);

  @override
  Future<void> subscribe(SubscribeTopicRequestInterface request) async {
    var param = request as SubscribeTopicDBRequest;
    return await _box.put(param.topic.topicId, param.topic);
  }

  @override
  Future<void> unsubscribe(SubscribeTopicRequestInterface request) async {
    var param = request as SubscribeTopicDBRequest;
    return await _box.delete(param.topic.topicId);
  }

  @override
  Future<List<Topic>> subscribeList(SubscribeListRequestInterface request) {
    List<Topic> topics = List.empty(growable: true);
    for (Topic topic in _box.values) {
      topics.add(topic);
    }
    return Future.value(topics);
  }
}
