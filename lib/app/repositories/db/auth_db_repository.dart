import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/infrastructures/encrypter_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/auth_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/auth/delete_workspace_db_request.dart';
import 'package:mobile_sev2/data/payload/db/auth/update_workspace_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/auth_repository_interface.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class AuthDBRepository implements AuthRepository {
  Box<Workspace> _box;
  EncrypterInterface _encrypter;

  AuthDBRepository(this._box, this._encrypter);

  @override
  Future<List<Workspace>> getWorkspace(GetWorkspaceRequestInterface request) {
    List<Workspace> workspaces = List.empty(growable: true);
    for (Workspace workspace in _box.values) {
      workspaces.add(Workspace(workspace.workspaceId, _encrypter.decrypt(workspace.token!)));
    }
    return Future.value(workspaces);
  }

  @override
  Future<bool> updateWorkspace(UpdateWorkspaceRequestInterface request) {
    var param = request as UpdateWorkspaceDBRequest;
    _box.put(param.workspace.workspaceId, Workspace(param.workspace.workspaceId, _encrypter.encrypt(param.workspace.token ?? "")));
    return Future.value(true);
  }

  @override
  Future<BaseApiResponse> getToken(GetTokenRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<BaseApiResponse> login(LoginRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteWorkspace(DeleteWorkspaceRequestInterface request) {
    var param = request as DeleteWorkspaceDBRequest;
    _box.delete(param.workspace.workspaceId);
    return Future.value(true);
  }

  @override
  Future<BaseApiResponse> register(RegisterRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<int> joinWorkspace(JoinWorkspaceRequestInterface request) {
    // TODO: implement joinWorkspace
    throw UnimplementedError();
  }
}
