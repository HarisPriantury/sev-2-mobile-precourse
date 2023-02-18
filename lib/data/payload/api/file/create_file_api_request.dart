import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';

class CreateFileApiRequest
    implements CreateFileRequestInterface, ApiRequestInterface {
  String content; // base64 encoded
  String name;
  String? viewPolicy;
  bool? canCDN;
  String? roomId;

  CreateFileApiRequest(this.name, this.content,
      {this.viewPolicy, this.canCDN, this.roomId});

  @override
  Map<dynamic, dynamic> encode() {
    var req = new Map<dynamic, dynamic>();

    req['data_base64'] = this.content;
    req['name'] = this.name;

    if (this.viewPolicy != null) req['viewPolicy'] = this.viewPolicy;
    if (this.canCDN != null) req['canCDN'] = this.canCDN;
    if (this.roomId != null) req['conpherencePHID'] = this.roomId;

    return req;
  }
}
