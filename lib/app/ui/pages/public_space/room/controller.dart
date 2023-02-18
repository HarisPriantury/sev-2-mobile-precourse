import 'dart:async';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/events/reporting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/args.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/view.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/send_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/get_flags_api_request.dart';
import 'package:mobile_sev2/data/payload/api/public_space/get_messages_public_space_api_request.dart';
import 'package:mobile_sev2/data/payload/api/topic/subscribe_topic_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/db/topic/SubscribeListDBRequest.dart';
import 'package:mobile_sev2/data/payload/db/topic/subscribe_topic_db_request.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/flag.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/workspace.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class PublicSpaceRoomController extends BaseController {
  EventBus _eventBus;
  PublicSpaceRoomArgs? _data;
  DateUtilInterface _dateUtil;
  PublicSpaceRoomPresenter _presenter;

  UserData _userData;

  late Workspace _workspace;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  StreamController<String> _streamController = StreamController();
  TextEditingController _textEditingController = TextEditingController();
  bool _isHasSubscribed = false;
  Map<String, PreviewData> mapData = Map();
  List<Chat> _chats = [];
  List<Chat> _newChats = [];
  List<Topic> _subscribedTopics = [];
  int _limit = 20;
  int _offset = 0;
  bool _isSendingMessage = false;
  bool _isSelectedChat = false;
  List<String> _recentlyReportedIds = [];

  RefreshController get refreshController => _refreshController;

  Workspace get workspace => _workspace;

  StreamController<String> get streamController => _streamController;

  TextEditingController get textEditingController => _textEditingController;

  bool get isHasSubscribe => _isHasSubscribed;

  bool get isSendingMessage => _isSendingMessage;

  List<Chat> get chats => _chats;

  List<String> get recentlyReportedIds => _recentlyReportedIds;

  DateUtil get dateUtil => _dateUtil as DateUtil;

  PublicSpaceRoomController(
    this._dateUtil,
    this._userData,
    this._eventBus,
    this._presenter,
  ) {
    _userData.loadData();
  }

  bool isLogin() {
    return _userData.isLoggedIn();
  }

  void setIsHasSubscribe() {
    Topic topic = Topic(
      _workspace.workspaceId,
      _workspace.publicSpace!.id,
    );
    if (_isHasSubscribed) {
      _presenter.onUnsubscribe(SubscribeTopicApiRequest(topic));
      _presenter.onUnsubscribe(SubscribeTopicDBRequest(topic));
    } else {
      _presenter.onSubscribe(SubscribeTopicApiRequest(topic));
      _presenter.onSubscribe(SubscribeTopicDBRequest(topic));
    }
    _isHasSubscribed = !_isHasSubscribed;
    refreshUI();
  }

  String formatChatGroupDate(DateTime dt) {
    return _dateUtil.format("d MMMM y", dt);
  }

  String formatChatTime(DateTime dt) {
    return _dateUtil.basicTimeFormat(dt);
  }

  void onGetPreviewData(String id, PreviewData data) {
    mapData[id] = data;
    refreshUI();
  }

  loginNow() {
    Navigator.pushNamed(context, Pages.login,
        arguments: LoginArgs(
          type: LoginType.idp,
          workspaceName: 'refactory',
        ));
    // Navigator.pushNamedAndRemoveUntil(context, Pages.workspaceList, (_) => false);
  }

  void _getMessages() {
    // _presenter.onGetMessagesPublicSpace(
    //   GetMessagesPublicSpaceApiRequest(
    //     workspaceId: _data!.workspace.intId!,
    //     limit: _limit,
    //     offset: _offset,
    //   ),
    // );
    if (_userData.isLoggedIn()) {
      _presenter.onGetMessages(GetMessagesApiRequest(
        limit: _limit,
        offset: _offset,
        roomId: _workspace.publicSpace?.id,
      ));
    } else {
      _presenter.onGetMessagesPublicSpace(
        GetMessagesPublicSpaceApiRequest(
          workspaceId: _data!.workspace.intId!,
          limit: _limit,
          offset: _offset,
        ),
      );
    }
  }

  String getUsernameByRegex(String? htmlMessage) {
    if (htmlMessage != null) {
      List<String> messages = htmlMessage.split('/');
      if (messages.length > 2) {
        return messages[2];
      } else
        return '';
    } else
      return '';
  }

  void sendMessage() {
    // if txt is empty, then ignore it
    if (_textEditingController.text.trim().isEmpty) return;
    // _isSendingMessage = true;
    _chats.insert(
      0,
      Chat(
        Chat.SEND_MESSAGE_ID,
        _dateUtil.now(),
        _textEditingController.text,
        false,
        _workspace.publicSpace!.id,
        sender: _userData.toUser(),
      ),
    );
    _presenter.onSendMessage(
      SendMessageApiRequest(
        _workspace.publicSpace!.id,
        _textEditingController.text,
      ),
    );
    refreshUI();
    _textEditingController.clear();
    _isSendingMessage = false;
  }

  void removeReportedChatPHID(String objectPHID) {
    _recentlyReportedIds.removeWhere((it) => it == objectPHID);
    refreshUI();
  }

  void _getReportedMessages() {
    _presenter.onGetFlags(
      GetFlagsApiRequest(
        types: ['XACT'],
      ),
    );
  }

  @override
  void load() {
    _presenter.onGetSubscribeList(SubscribeListDBRequest());
    this.setScrollListener(() {
      _offset += _limit;
      _getMessages();
    });
    _getMessages();

    _getReportedMessages();
  }

  @override
  void initListeners() {
    _eventBus.on<ReportingSuccess>().listen((event) async {
      _recentlyReportedIds.add(event.objectPHID);
      _recentlyReportedIds.toSet();

      refreshUI();
    });

    _presenter.getMessagesPublicSpaceOnNext = (List<Chat> chats) {
      print("get messages public space success");
      if (_offset == 0) {
        _chats.clear();
      }
      _chats.addAll(chats);
    };

    _presenter.getMessagesPublicSpaceOnComplete = () {
      print("get messages public space completed");
      refreshUI();
      loading(false);
      _refreshController.refreshCompleted();
    };

    _presenter.getMessagesPublicSpaceOnError = (e) {
      print("get messages public space error: $e");
      loading(false);
      _refreshController.refreshFailed();
    };

    _presenter.getMessagesOnNext = (List<Chat> chats, PersistenceType type) {
      print("public space: success getMessages");
      bool _isNewMessage = false;
      List<Chat> _chatsResponse = [];
      _chatsResponse.addAll(chats);
      if (_chats.isNotEmpty) {
        String lastChatId =
            _chats.firstWhere((element) => element.isIdValid()).id;
        int idx =
            _chatsResponse.indexWhere((element) => element.id == lastChatId);
        if (idx > 0) {
          _chatsResponse = _chatsResponse.sublist(0, idx);
          _isNewMessage = true;
        }
      }
      _newChats.clear();
      _newChats.addAll(_chatsResponse);

      if (_offset == 0 && !_isNewMessage) {
        _chats.clear();
      }
      if (_isNewMessage) {
        _chats.removeWhere((element) {
          if (!element.isIdValid()) {
            print("deleted: ${element.message}");
            return true;
          }
          return false;
        });
        _chats.insertAll(0, _newChats);
      } else
        _chats.addAll(_newChats);

      _presenter.onGetUsers(
        GetUsersApiRequest(
          ids: _newChats.map((e) => e.sender!.id).toList(),
        ),
        "chat",
        isNewMessage: _isNewMessage,
      );
    };

    _presenter.getMessagesOnComplete = (PersistenceType type) {
      print("public space: completed getMessages");
      // refreshUI();
      // loading(false);
    };

    _presenter.getMessagesOnError = (e, PersistenceType type) {
      print("chat: error getMessages $e");
      loading(false);
      _refreshController.refreshFailed();
    };

    // get users
    _presenter.getUsersOnNext = (
      List<User> users,
      PersistenceType type,
      String from,
      bool isNewMessage,
    ) {
      print("voice: success getUsers from $from ${users.length}");
      _chats.forEach((nc) {
        var idx = _chats.indexWhere((el) => el.id == nc.id);
        User? user = users.firstWhere((u) => u.id == _chats[idx].sender!.id);
        _chats[idx].sender = user;
      });
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("voice: completed getUsers ${_chats.first.sender?.name}");
      loading(false);
      _refreshController.refreshCompleted();
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      print("voice: error getUsers $e");
      loading(false);
      _refreshController.refreshFailed();
    };

    _presenter.sendMessageOnNext = (bool result, PersistenceType type) {
      print("chat: success sendMessage");
    };

    _presenter.sendMessageOnComplete = (PersistenceType type) {
      print("chat: completed sendMessage $type");
      if (type == PersistenceType.api) {
        // _textEditingController.clear();
        // _isSendingMessage = false;
        _refresh();
      }
    };

    _presenter.sendMessageOnError = (e, PersistenceType type) {
      print("chat: error sendMessage $e");
    };

    _presenter.getSubscribeListOnNext =
        (List<Topic> result, PersistenceType type) {
      print("main: success getSubscribeList $type length: ${result.length}");
      _subscribedTopics.clear();
      _subscribedTopics.addAll(result);
    };

    _presenter.getSubscribeListOnComplete = (PersistenceType type) {
      print("main: completed getSubscribeList $type");
      _isHasSubscribed = false;
      _subscribedTopics.forEach((topic) {
        if (topic.topicId == _workspace.publicSpace?.id) {
          _isHasSubscribed = true;
          return;
        }
      });
      refreshUI();
    };

    _presenter.getSubscribeListOnError = (e, PersistenceType type) {
      print("main: error getSubscribeList: $e $type");
    };

    _presenter.subscribeOnNext = (Topic? result, PersistenceType type) {
      print("main: success subscribe $type");
    };

    _presenter.subscribeOnComplete = (PersistenceType type) {
      print("main: completed subscribe $type");
      _presenter.onGetSubscribeList(SubscribeListDBRequest());
    };

    _presenter.subscribeOnError = (e, PersistenceType type) {
      print("main: error subscribe: $e $type");
    };

    _presenter.unsubscribeOnNext = (void result, PersistenceType type) {
      print("main: success unsubscribe $type");
    };

    _presenter.unsubscribeOnComplete = (PersistenceType type) {
      print("main: completed unsubscribe $type");
      _presenter.onGetSubscribeList(SubscribeListDBRequest());
    };

    _presenter.unsubscribeOnError = (e, PersistenceType type) {
      print("main: error unsubscribe: $e $type");
    };

    // get flags
    _presenter.getFlagsOnNext = (List<Flag> results, PersistenceType type) {
      print("public space: success getFlags $type");
      _recentlyReportedIds.addAll(results
          .where((it) => it.colorName == "Red")
          .toSet()
          .map((it) => it.objectPHID)
          .whereType());

      refreshUI();
    };

    _presenter.getFlagsOnComplete = (PersistenceType type) {
      print("public space: completed getFlags $type");
    };

    _presenter.getFlagsOnError = (e, PersistenceType type) {
      print("public space: error getFlags $e $type");
    };
  }

  @override
  void disposing() {
    _streamController.close();
  }

  void _refresh() {
    _offset = 0;
    _getMessages();
  }

  void onRefresh() async {
    // monitor network fetch
    _refresh();
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as PublicSpaceRoomArgs;
      print(_data?.toPrint());
      _workspace = _data!.workspace;
      if (_userData.isLoggedIn()) {
        _userData.token = _workspace.token!;
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
        _userData.workspace = _workspace.workspaceId;
        // _userData.type = _workspace.type!;
        _userData.save();
      }
    }
  }

  Future<void> onOpen(String link) async {
    Uri uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }

  void onReportMessage(Chat chat) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments:
                ReportArgs(phId: chat.id, reportedType: "PUBLIC SPACE MESSAGE"),
          );
        });
  }
}
