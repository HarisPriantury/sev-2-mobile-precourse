import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';

class GetTokenApiRequest implements GetTokenRequestInterface {
  String email;
  String sub;
  String workspace;
  String provider;

  GetTokenApiRequest(
    this.email,
    this.sub,
    this.workspace,
    this.provider,
  );
}
