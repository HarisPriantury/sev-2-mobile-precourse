import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';

abstract class ApiServiceInterface {
  Future<Map<String, dynamic>> invokeHttp(String url, ApiRequestInterface body,
      {Map<String, String> headers});
}
