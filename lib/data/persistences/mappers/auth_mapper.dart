import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class AuthMapper {
  DateUtilInterface _dateUtil;

  AuthMapper(this._dateUtil);

  BaseApiResponse convertGetTokenApiResponse(Map<String, dynamic> response) {
    return BaseApiResponse(response['conduit_token']);
  }

  BaseApiResponse convertLoginApiResponse(Map<String, dynamic> response) {
    try {
      return BaseApiResponse(response['result']['data']['token']);
    } catch (e) {
      return BaseApiResponse(
        response['result']['message'],
        errorResult: response['result']['message'],
        errorCode: response['result']['error'].toString(),
      );
    }
  }

  BaseApiResponse convertRegisterApiResponse(Map<String, dynamic> response) {
    return BaseApiResponse(
      response['result']['message'],
      errorCode: response['error_code'],
      errorResult: response['error_info'],
    );
  }

  List<Workspace> convertGetWorkspaceApiResponse(List response) {
    var workspaces = List<Workspace>.empty(growable: true);
    for (var data in response) {
      Workspace workspace = Workspace(
        data['name'],
        '',
        intId: data['id'],
        category: data['category'],
        created: _dateUtil.fromSeconds(data['created_epoch']),
        description: data['description'],
        name: data['name'],
        subscriptionId: data['subscription_id'],
        updated: _dateUtil.fromSeconds(data['updated_epoch']),
        userId: data['user_id'],
      );
      workspaces.add(workspace);
    }
    return workspaces;
  }

  List<Workspace> convertGetBelongedWorkspaceApiResponse(List response) {
    var workspaces = List<Workspace>.empty(growable: true);
    for (var data in response) {
      Workspace workspace = Workspace(
        data['name'],
        '',
        intId: data['id'],
        category: data['category'],
        created: _dateUtil.fromSeconds(data['created_epoch']),
        description: data['description'],
        name: data['name'],
        status: data['status'],
        type: data['type'],
      );
      workspaces.add(workspace);
    }
    return workspaces;
  }
}
