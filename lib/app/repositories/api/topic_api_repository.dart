import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile_sev2/data/payload/api/topic/subscribe_topic_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/topic_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';

class TopicApiRepository implements TopicRepository {
  FirebaseMessaging _firebaseMessaging;

  TopicApiRepository(this._firebaseMessaging);

  @override
  Future<void> subscribe(SubscribeTopicRequestInterface request) async {
    return await _firebaseMessaging.subscribeToTopic((request as SubscribeTopicApiRequest).topic.topicId);
  }

  @override
  Future<void> unsubscribe(SubscribeTopicRequestInterface request) async {
    return await _firebaseMessaging.unsubscribeFromTopic((request as SubscribeTopicApiRequest).topic.topicId);
  }

  @override
  Future<List<Topic>> subscribeList(SubscribeListRequestInterface request) {
    return Future.value([]);
  }
}
