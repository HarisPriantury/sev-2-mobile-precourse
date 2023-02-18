import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/db/auth/get_workspace_db_request.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class WorkspaceLoginController extends BaseController {
  late WorkspaceLoginArgs _data;
  DateUtilInterface _dateUtil;
  WorkspaceLoginPresenter _presenter;
  List<Workspace> _workspaces = [];
  Dio _dio;

  TextEditingController _workspaceTextController = new TextEditingController();
  bool _workspaceFound = true;
  bool _alreadyLoggedIn = false;

  WorkspaceLoginController(
    this._presenter,
    this._dateUtil,
    this._dio,
  ) : super();

  TextEditingController get workspaceTextController => _workspaceTextController;

  bool get workspaceFound => _workspaceFound;

  bool get alreadyLoggedIn => _alreadyLoggedIn;

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null)
      _data = args as WorkspaceLoginArgs;
    else
      _data = WorkspaceLoginArgs();
    print(_data.toPrint());
  }

  @override
  void initListeners() {
    _presenter.getWorkspaceOnNext = (workspaces) {
      print("get workspace success");
      _workspaces.clear();
      _workspaces.addAll(workspaces);
      refreshUI();
      loading(false);
    };

    _presenter.getWorkspaceOnComplete = () {
      print("get workspace completed");
    };

    _presenter.getWorkspaceOnError = (e) {
      print("get workspace error: $e");
      loading(false);
    };
  }

  @override
  void load() {
    _presenter.onGetWorkspace(GetWorkspaceDBRequest());
  }

  void refresh() {
    refreshUI();
  }

  bool hasOrigin() {
    return _data.origin != null;
  }

  void gotoLogin(LoginType type, String workspaceName) {
    Navigator.pushNamed(context, Pages.login,
        arguments: LoginArgs(type: type, workspaceName: workspaceName));
  }

  String getCurrentYear() {
    return _dateUtil.now().year.toString();
  }

  void workspaceLogin({LoginType loginType = LoginType.idp}) {
    var _baseUrl =
        "https://${_workspaceTextController.text}${dotenv.env['SUITE_BASE_URL']}";
    AppComponent.getInjector()
        .get<Dio>(dependencyName: "dio_api_request")
        .options
        .baseUrl = _baseUrl;
    final uri = Uri.parse(_baseUrl);
    AppComponent.getInjector()
        .get<Dio>(dependencyName: "dio_api_request")
        .options
        .headers["host"] = uri.host;
    AppComponent.getInjector()
            .get<WebSocketDashboardClient>(dependencyName: "dashboard_websocket")
            .url =
        "wss://${_workspaceTextController.text}${dotenv.env['SUITE_WEBRTC_BASE_URL']}";
    gotoLogin(loginType, _workspaceTextController.text);
  }

  void workSpaceNotFound() {
    showCustomAlertDialog(
      context: context,
      title: S.of(context).label_workspace_not_found,
      subtitle: S.of(context).label_check_the_writing,
      cancelButtonText: S.of(context).label_back.toUpperCase(),
      cancelButtonColor: ColorsItem.whiteF2F2F2,
      heightBoxDialog: MediaQuery.of(context).size.height / 4.0,
    );
  }

  void proceed() async {
    //TODO: Cleanup later
    loading(true);
    try {
      final result = await _dio
          .get("https://" + _workspaceTextController.text + ".sev-2.com");
      if (result.statusCode == 200) {
        _workspaceFound = true;
      } else {
        _workspaceFound = false;
        workSpaceNotFound();
      }
    } catch (e) {
      _workspaceFound = false;
      workSpaceNotFound();
    }
    if (_workspaceFound) {
      if (_workspaces
          .where(
              (element) => element.workspaceId == _workspaceTextController.text)
          .toList()
          .isNotEmpty) {
        _alreadyLoggedIn = true;
      } else {
        workspaceLogin();
      }
    }
    loading(false);
  }
}
