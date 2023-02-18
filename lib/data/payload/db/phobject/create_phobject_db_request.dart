import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class CreatePhObjectDBRequest implements CreateObjectRequestInterface {
  PhObject obj;

  CreatePhObjectDBRequest(this.obj);
}
