import 'package:mobile_sev2/data/payload/contracts/push_notification_request_interface.dart';

class DeletePushNotificationsDBRequest extends DeletePushNotificationsRequestInterface {
  String? conpherencePHID;

  DeletePushNotificationsDBRequest(this.conpherencePHID);
}