import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';

class SubscribeTopicApiRequest extends SubscribeTopicRequestInterface {
  Topic topic;

  SubscribeTopicApiRequest(this.topic);
}
