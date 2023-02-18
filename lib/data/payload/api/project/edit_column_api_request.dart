import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';

class EditColumnApiRequest implements EditColumnRequestInterface, ApiRequestInterface {
  String columnId;
  String columnName;

  EditColumnApiRequest(this.columnId, this.columnName);

  @override
  Map encode() {
    var req = new Map<dynamic, dynamic>();
    req['columnPHID'] = this.columnId;
    req['name'] = this.columnName;

    return req;
  }
}
