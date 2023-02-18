import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/domain/meta/notif_stream.dart';

class CreateNotifStreamDBRequest implements CreateNotifStreamRequestInterface {
  NotifStream stream;

  CreateNotifStreamDBRequest(this.stream);
}
