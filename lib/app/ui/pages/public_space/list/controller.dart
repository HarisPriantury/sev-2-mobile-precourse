import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/args.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/args.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_token_api_request.dart';
import 'package:mobile_sev2/data/payload/api/auth/get_workspace_api_request.dart';
import 'package:mobile_sev2/data/payload/api/auth/join_workspace_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/public_space/get_public_space_api_request.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:showcaseview/showcaseview.dart';

class PublicSpaceController extends BaseController {
  PublicSpaceArgs? _data;
  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _streamController = StreamController();
  final FocusNode _focusNodeSearch = FocusNode();
  PublicSpacePresenter _presenter;

  // late BuildContext dialogContext;

  UserData _userData;

  DateUtilInterface _dateUtil;

  bool _isSearch = false;
  String _selectedSpaceType = "";

  List<Workspace> _workspaces = [];

  List<String> _filterType = [
    // 'Bisnis 1',
    // 'Bisnis 2',
    // 'Bisnis 3',
    // 'Bisnis 4',
  ];

  TextEditingController get searchController => _searchController;

  StreamController<String> get streamController => _streamController;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  bool get isSearch => _isSearch;

  List<String> get filterType => _filterType;

  List<Workspace> get workspaces => _workspaces;

  UserData get userData => _userData;

  PublicSpaceController(
    this._dateUtil,
    this._userData,
    this._presenter,
  ) {
    _userData.loadData();
  }

  void filter(String typeFilter) {
    _selectedSpaceType = typeFilter;
    refreshUI();
  }

  bool isLogin() {
    return _userData.isLoggedIn();
  }

  String formatChatTime(DateTime? dt) {
    final now = _dateUtil.now();
    final today = DateTime(now.year, now.month, now.day);
    if (dt == null) dt = now;
    final dateToCheck = DateTime(dt.year, dt.month, dt.day);
    if (dateToCheck.isBefore(today)) {
      return _dateUtil.format("d MMM", dt);
    }
    return _dateUtil.basicTimeFormat(dt);
  }

  loginNow() {
    Navigator.pushNamed(
      context,
      Pages.login,
      arguments: LoginArgs(
        type: LoginType.idp,
        workspaceName: 'refactory',
      ),
    );
    // Navigator.pushNamedAndRemoveUntil(context, Pages.workspaceList, (_) => false);
  }

  joinRoom(Workspace workspace) {
    if (_userData.isLoggedIn()) {
      // dialogContext = context;
      showOnLoading(context, "Menghubungkan ke public space");
      _presenter.onGetToken(
        GetTokenApiRequest(
          _userData.email,
          _userData.sub,
          workspace.workspaceId,
          _userData.authProvider,
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        Pages.publicSpaceRoom,
        arguments: PublicSpaceRoomArgs(workspace),
      );
    }
  }

  void goToWorkspaceList() {
    if (isLogin()) {
      Navigator.pushReplacementNamed(context, Pages.workspaceList);
    } else {
      showCustomAlertDialog(
        context: context,
        title: "Log In",
        subtitle: "Log in dulu untuk melanjutkan.",
        cancelButtonText: S.of(context).label_back.toUpperCase(),
        confirmButtonText: "Log In".toUpperCase(),
        confirmButtonColor: ColorsItem.orangeFB9600,
        confirmButtonTextColor: ColorsItem.black1F2329,
        onConfirm: loginNow,
      );
    }
  }

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowCaseWidget.of(context).startShowCase(_getShowcaseKey());
    });
  }

  List<GlobalKey> _getShowcaseKey() {
    List<GlobalKey> _showcaseKey = [];
    if (!_userData.workspaceTooltipFinished) _showcaseKey.add(eight);
    return _showcaseKey;
  }

  @override
  void load() {
    _presenter.onGetWorkspace(
      GetWorkspaceApiRequest(
        requestType: RequestType.all,
        accessToken: _userData.accessToken,
        // requestType: RequestType.belonged,
        // userId: _userData.intId,
      ),
    );

    // _presenter.onGetPublicSpace(GetPublicSpaceApiRequest(channelId: 1));
  }

  @override
  void initListeners() {
    _presenter.getWorkspaceOnNext = (List<Workspace> workspaces) {
      print("get workspace success ${workspaces.length}");
      _workspaces.clear();
      _workspaces.addAll(workspaces);
      _workspaces.forEach((workspace) {
        if (workspace.intId != null) {
          _presenter.onGetPublicSpace(
              GetPublicSpaceApiRequest(workspaceId: workspace.intId!),
              workspace.intId!);
        }
      });
    };

    _presenter.getWorkspaceOnComplete = () {
      print("get workspace completed");
    };

    _presenter.getWorkspaceOnError = (e) {
      print("get workspace error: $e");
      loading(false);
    };

    _presenter.getTokenOnNext = (BaseApiResponse response, String workspace) {
      print("get token success");
      Workspace _workspace =
          _workspaces.firstWhere((space) => space.workspaceId == workspace);
      _workspace.token = response.result;
      _userData.token = response.result;
      _userData.save();
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        Pages.publicSpaceRoom,
        arguments: PublicSpaceRoomArgs(_workspace),
      );
    };

    _presenter.getTokenOnComplete = () {
      print("get token completed");
    };

    _presenter.getTokenOnError = (e, String workspace) {
      print("get token error: $e");
      loading(false);
      Navigator.pop(context);
      if (e == 404) {
        _presenter.onJoinWorkspace(JoinWorkspaceApiRequest(
          workspaceName: workspace,
          userId: _userData.intId,
          accessToken: _userData.accessToken,
        ));
      } else {
        loading(false);
      }
    };

    _presenter.getPublicSpaceOnNext = (Room room, int id) {
      print("get public space success $room $id");
      int idx = _workspaces.indexWhere((workspace) => workspace.intId == id);
      _workspaces[idx].publicSpace = Room(
        room.id,
        memberCount: room.memberCount,
        lastMessage: room.lastMessage != null
            ? room.lastMessage!.replaceAll("\n", " ")
            : "",
        lastMessageCreatedAt: room.lastMessageCreatedAt,
        workspaceId: _userData.workspace,
      );
      refreshUI();
      loading(false);
    };

    _presenter.getPublicSpaceOnComplete = () {
      print("get public space completed");
      if (!_userData.workspaceTooltipFinished) startShowCase();
    };

    _presenter.getPublicSpaceOnError = (e) {
      print("get public space error: $e");
    };

    _presenter.joinWorkspaceOnNext = (int response, String workspaceName) {
      print("join workspace success $response");
      if (response == 201) {
        Workspace _workspace = _workspaces
            .firstWhere((space) => space.workspaceId == workspaceName);
        joinRoom(_workspace);
      } else {
        loading(false);
      }
    };

    _presenter.joinWorkspaceOnComplete = () {
      print("join workspace completed");
    };

    _presenter.joinWorkspaceOnError = (e) {
      print("join workspace error: $e");
      loading(false);
    };
  }

  @override
  void disposing() {
    _streamController.close();
  }

  @override
  void getArgs() {
    if (args != null) _data = args as PublicSpaceArgs;
    print(_data?.toPrint());
  }
}
