import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/events/after_login.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/list/args.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/args.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/args.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_workspace_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/public_space/get_public_space_api_request.dart';
import 'package:mobile_sev2/data/payload/api/topic/subscribe_topic_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/auth/delete_workspace_db_request.dart';
import 'package:mobile_sev2/data/payload/db/topic/SubscribeListDBRequest.dart';
import 'package:mobile_sev2/data/payload/db/topic/subscribe_topic_db_request.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class WorkspaceListController extends BaseController {
  List<Workspace> _workspaces = [];

  WorkspaceListPresenter _presenter;

  WorkspaceListArgs? _data;

  UserData _userData;

  EventBus _eventBus;

  List<Topic> _subscribedTopics = [];

  bool _isSelectedWorkspaceDeleted = false;

  bool _isGotoPublicSpaceList = false;

  int _unsubscribeCounter = -1;

  late String _selectedWorkspace;

  WorkspaceListController(
    this._presenter,
    this._eventBus,
    this._userData,
  ) : super() {
    _userData.loadData();
    _selectedWorkspace = _userData.workspace;
  }

  List<Workspace> get workspaces => _workspaces;

  WorkspaceListArgs? get data => _data;

  bool get isSelectedWorkspaceDeleted => _isSelectedWorkspaceDeleted;

  Workspace getCurrentWorkspace() {
    return Workspace(_userData.workspace, _userData.token);
  }

  void goToPublicSpaceList() {
    _isGotoPublicSpaceList = true;
    Navigator.pushReplacementNamed(
      context,
      Pages.publicSpace,
      arguments: PublicSpaceArgs(true),
    );
  }

  void selectWorkspace(Workspace workspace) {
    _userData.token = workspace.token!;
    _userData.workspace = workspace.workspaceId;
    _userData.type = workspace.type!;
    _userData.save();
    String _baseUrl =
        "https://${workspace.workspaceId}${dotenv.env['SUITE_BASE_URL']}";
    AppComponent.getInjector()
        .get<Dio>(dependencyName: "dio_api_request")
        .options
        .baseUrl = _baseUrl;
    final uri = Uri.parse(_baseUrl);
    AppComponent.getInjector()
        .get<Dio>(dependencyName: "dio_api_request")
        .options
        .headers["host"] = uri.host;
    Navigator.pop(context);

    String _webRTCUrl =
        "wss://${workspace.workspaceId}${dotenv.env['SUITE_WEBRTC_BASE_URL']}";
    AppComponent.getInjector()
        .get<WebSocketDashboardClient>(dependencyName: "dashboard_websocket")
        .url = _webRTCUrl;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Pages.main,
      (_) => false,
      arguments: MainArgs(Pages.login),
    );

    _eventBus.fire(AfterLoginEvent());
    // if (workspace.type?.toLowerCase() == 'guest') {
    //   Navigator.pushNamed(
    //     context,
    //     Pages.publicSpaceRoom,
    //     arguments: PublicSpaceRoomArgs(workspace),
    //   );
    // } else {
    //
    // }
  }

  void deleteWorkspace(Workspace workspace, int index) {
    if (_workspaces.length > 1) {
      // _eventBus.fire(UnsubscribeAllEvent());
      if (isSelected(workspace)) {
        if (index == 0) {
          _userData.workspace = _workspaces[1].workspaceId;
          _userData.token = _workspaces[1].token!;
        } else if (index == _workspaces.length - 1) {
          _userData.workspace = _workspaces.first.workspaceId;
          _userData.token = _workspaces.first.token!;
        }
        _userData.save();
      }
    } else {
      logout();
    }
    _presenter.onDeleteWorkspace(DeleteWorkspaceDBRequest(workspace));
  }

  void goToWorkspaceLogin() {
    Navigator.pushNamed(context, Pages.workspace,
        arguments: WorkspaceLoginArgs(origin: Pages.workspaceList));
  }

  void joinWorkspace(Workspace workspace) {
    if (workspace.workspaceId == _userData.workspace &&
        _data?.origin != Pages.errorPage &&
        !_isGotoPublicSpaceList) {
      Navigator.pop(context);
    } else {
      showOnLoading(context, "Menghubungkan ke workspace");
      _presenter.onGetToken(
        GetTokenApiRequest(
          _userData.email,
          _userData.sub,
          workspace.workspaceId,
          _userData.authProvider,
        ),
      );
    }
  }

  void logout() async {
    Navigator.pop(context);
    showOnLoading(context, "Log out...");
    await DataUtil.clearDb();
    await _userData.clear();
    if (_subscribedTopics.isEmpty) {
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        Pages.publicSpace,
        (_) => false,
      );
    } else {
      _subscribedTopics.forEach((element) {
        _presenter.onUnsubscribe(SubscribeTopicApiRequest(element));
        _presenter.onUnsubscribe(SubscribeTopicDBRequest(element));
      });
    }
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as WorkspaceListArgs;
      print(_data?.toPrint());
    }
  }

  @override
  void initListeners() {
    // _presenter.getWorkspaceOnNext = (workspaces) {
    //   print("get workspace success");
    //   _workspaces.clear();
    //   _workspaces.addAll(workspaces);
    //   refreshUI();
    //   loading(false);
    // };

    _presenter.getWorkspaceOnNext = (List<Workspace> workspaces) {
      print("get workspace success ${workspaces.length}");

      _workspaces.clear();
      _workspaces.addAll(workspaces);

      // _workspaces.forEach((workspace) {
      //   if (workspace.type?.toLowerCase() == 'guest') {
      //     _presenter.onGetPublicSpace(
      //       GetPublicSpaceApiRequest(workspaceId: workspace.intId!),
      //     );
      //   }
      // });
      loading(false);
    };

    _presenter.getWorkspaceOnComplete = () {
      print("get workspace completed");
    };

    _presenter.getWorkspaceOnError = (e) {
      print("get workspace error: $e");
      loading(false);
    };

    _presenter.getPublicSpaceOnNext = (Room room, int id) {
      print("get public space success $room $id");
      int idx = _workspaces.indexWhere((workspace) => workspace.intId == id);
      _workspaces[idx].publicSpace = room;
      refreshUI();
    };

    _presenter.getPublicSpaceOnComplete = () {
      print("get public space completed");
    };

    _presenter.getPublicSpaceOnError = (e) {
      loading(false);
      print("get public space error: $e");
    };

    _presenter.getTokenOnNext = (BaseApiResponse response, String workspace) {
      print("get token success");
      Workspace _workspace =
          _workspaces.firstWhere((space) => space.workspaceId == workspace);
      _workspace.token = response.result;
      selectWorkspace(_workspace);
    };

    _presenter.getTokenOnComplete = () {
      print("get token completed");
    };

    _presenter.getTokenOnError = (e) {
      print("get token error: $e");
      loading(false);
      Navigator.pop(context);
    };

    _presenter.deleteWorkspaceOnNext = (state) {
      print("delete workspace success");
    };

    _presenter.deleteWorkspaceOnComplete = () {
      print("delete workspace complete");
      _isSelectedWorkspaceDeleted = true;
      // _presenter.onGetWorkspace(GetWorkspaceDBRequest());
      load();
    };

    _presenter.deleteWorkspaceOnError = (e) {
      loading(false);
      print("delete workspace error $e");
    };

    _presenter.getSubscribeListOnNext =
        (List<Topic> result, PersistenceType type) {
      print(
          "workspaceList: success getSubscribeList $type length: ${result.length}");
      _subscribedTopics.clear();
      _subscribedTopics.addAll(result);
    };

    _presenter.getSubscribeListOnComplete = (PersistenceType type) {
      print("workspaceList: completed getSubscribeList $type");
      _unsubscribeCounter = _subscribedTopics.length;
    };

    _presenter.getSubscribeListOnError = (e, PersistenceType type) {
      loading(false);
      print("workspaceList: error getSubscribeList: $e $type");
    };

    _presenter.unsubscribeOnNext = (void result, PersistenceType type,
        SubscribeTopicRequestInterface request) {
      if (request is SubscribeTopicApiRequest) {
        _unsubscribeCounter--;
        print(
            "workspaceList: success unsubscribe $type ${request.topic.topicId} $_unsubscribeCounter");
        // _presenter.onUnsubscribe(
        //   SubscribeTopicDBRequest(
        //     Topic(_userData.workspace, request.topic.topicId),
        //   ),
        // );
      } else {
        print(
            "workspaceList: success unsubscribe $type ${(request as SubscribeTopicDBRequest).topic.topicId}");
      }
    };

    _presenter.unsubscribeOnComplete = (PersistenceType type) {
      print("workspaceList: completed unsubscribe $type $_unsubscribeCounter");
      if (_unsubscribeCounter == 0) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Pages.publicSpace,
          (_) => false,
        );
      }
    };

    _presenter.unsubscribeOnError = (e, PersistenceType type) {
      loading(false);
      print("workspaceList: error unsubscribe: $e $type");
    };
  }

  @override
  void load() {
    // _presenter.onGetWorkspace(GetWorkspaceDBRequest());
    _presenter.onGetSubscribeList(SubscribeListDBRequest());
    _presenter.onGetWorkspace(
      GetWorkspaceApiRequest(
        // requestType: RequestType.all,
        requestType: RequestType.belonged,
        userId: _userData.intId,
        accessToken: _userData.accessToken,
      ),
    );
  }

  bool isSelected(Workspace workspace) {
    return _selectedWorkspace == workspace.workspaceId;
  }
}
