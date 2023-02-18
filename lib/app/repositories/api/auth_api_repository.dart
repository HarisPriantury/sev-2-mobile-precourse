import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/app/infrastructures/persistences/http_service.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_workspace_api_request.dart';
import 'package:mobile_sev2/data/payload/api/auth/join_workspace_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/auth_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/auth_repository_interface.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class AuthApiRepository implements AuthRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  AuthMapper _mapper;

  AuthApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<int> joinWorkspace(JoinWorkspaceRequestInterface request) async {
    if (request is JoinWorkspaceApiRequest) {
      var response = await http.post(
        HTTPService.getUrl(
            endpoint: 'api/account/${request.userId}/workspaces'),
        headers: HTTPService.getHeader(accessToken: request.accessToken),
        body: jsonEncode({'name': request.workspaceName}),
      );
      return response.statusCode;
    } else {
      return Future.value(404);
    }
  }

  @override
  Future<BaseApiResponse> getToken(GetTokenRequestInterface request) async {
    GetTokenApiRequest apiRequest = request as GetTokenApiRequest;
    var response = await http.post(
      HTTPService.getUrl(endpoint: 'auth/exchange-id-token'),
      headers: HTTPService.getHeader(),
      body: jsonEncode(
        {
          'email': apiRequest.email,
          'provider': apiRequest.provider,
          'sub': apiRequest.sub,
          'workspace': apiRequest.workspace
        },
      ),
    );
    print('request: ${jsonEncode(
      {
        'email': apiRequest.email,
        'provider': apiRequest.provider,
        'sub': apiRequest.sub,
        'workspace': apiRequest.workspace
      },
    )} response: ${response.body} code: ${response.statusCode}');
    if (response.statusCode != 200) {
      throw response.statusCode;
    }
    return _mapper.convertGetTokenApiResponse(jsonDecode(response.body));
  }

  @override
  Future<BaseApiResponse> login(LoginRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.login(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertLoginApiResponse(resp);
  }

  @override
  Future<BaseApiResponse> register(RegisterRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.register(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertRegisterApiResponse(resp);
  }

  @override
  Future<List<Workspace>> getWorkspace(
      GetWorkspaceRequestInterface request) async {
    GetWorkspaceApiRequest apiRequest = request as GetWorkspaceApiRequest;
    late var response;
    if (apiRequest.requestType == RequestType.all) {
      response = await http.get(
        HTTPService.getUrl(endpoint: 'api/workspaces'),
        headers: HTTPService.getHeader(),
      );
      return _mapper.convertGetWorkspaceApiResponse(jsonDecode(response.body));
    } else {
      response = await http.get(
        HTTPService.getUrl(
            endpoint: 'api/account/${apiRequest.userId}/workspaces'),
        headers: HTTPService.getHeader(accessToken: apiRequest.accessToken),
      );
      return _mapper
          .convertGetBelongedWorkspaceApiResponse(jsonDecode(response.body));
    }
  }

  @override
  Future<bool> updateWorkspace(UpdateWorkspaceRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteWorkspace(DeleteWorkspaceRequestInterface request) {
    throw UnimplementedError();
  }
}
