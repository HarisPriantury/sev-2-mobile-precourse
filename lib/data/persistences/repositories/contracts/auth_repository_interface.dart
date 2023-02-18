import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/domain/workspace.dart';

abstract class AuthRepository {
  Future<BaseApiResponse> getToken(GetTokenRequestInterface request);

  Future<BaseApiResponse> login(LoginRequestInterface request);

  Future<BaseApiResponse> register(RegisterRequestInterface request);

  Future<bool> updateWorkspace(UpdateWorkspaceRequestInterface request);

  Future<List<Workspace>> getWorkspace(GetWorkspaceRequestInterface request);

  Future<bool> deleteWorkspace(DeleteWorkspaceRequestInterface request);

  Future<int> joinWorkspace(JoinWorkspaceRequestInterface request);
}
