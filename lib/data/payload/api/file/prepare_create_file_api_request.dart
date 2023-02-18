import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';

class PrepareCreateFileApiRequest
    implements PrepareCreateFileRequestInterface, ApiRequestInterface {
  String name;
  int contentLength;
  String? contentHash;
  String? viewPolicy;

  PrepareCreateFileApiRequest(this.name, this.contentLength,
      {this.contentHash, this.viewPolicy});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['name'] = this.name;
    req['contentLength'] = this.contentLength;

    if (this.contentHash != null) req['contentHash'] = this.contentHash;
    if (this.viewPolicy != null) req['viewPolicy'] = this.viewPolicy;

    return req;
  }
}
