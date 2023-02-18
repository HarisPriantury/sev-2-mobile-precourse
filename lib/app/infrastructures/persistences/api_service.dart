import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';

class ApiService extends ApiServiceInterface {
  Dio dio;
  String token;

  ApiService(
    this.dio,
    this.token,
  );

  // send http request
  Future<Map<String, dynamic>> invokeHttp(
    String url,
    ApiRequestInterface body, {
    Map<String, String>? headers,
  }) async {
    Response response;
    // set token
    var data = body.encode();
    data["api.token"] = token;

    try {
      response = await _invoke(
        url,
        data,
        headers: headers,
      );
    } catch (error) {
      rethrow;
    }

    return response.data;
  }

  // setup request type and configuration
  Future<Response> _invoke(
    String url,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    Response response;
    try {
      response = await dio.post(url,
          data: body,
          options: Options(
            headers: headers,
          ));
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
