import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';

class GetPushNotificationsDBRequest extends GetPushNotificationsRequestInterface {
  String conpherencePHID;

  GetPushNotificationsDBRequest(this.conpherencePHID);
}