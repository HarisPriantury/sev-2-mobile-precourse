import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/domain/file.dart';

class CreateFileDBRequest implements CreateFileRequestInterface {
  File file;

  CreateFileDBRequest(this.file);
}
