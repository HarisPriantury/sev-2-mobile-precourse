import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sev2/app/infrastructures/events/member.dart';
import 'package:mobile_sev2/app/infrastructures/events/notification.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/events/reporting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/peer.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/signaling.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/author_reaction_sheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/channel_setting/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/downloader_interface.dart';
import 'package:mobile_sev2/data/infrastructures/encoder_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/infrastructures/files_picker_interface.dart';
import 'package:mobile_sev2/data/infrastructures/ringtone_player_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/delete_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/send_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/file/create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/prepare_create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/get_flags_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_calendar_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_stickits_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_tasks_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/add_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/delete_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/db/chat/send_message_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_list_user_db_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart' as FileDomain;
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/flag.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/meta/unread_chat.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:url_launcher/url_launcher.dart';

class LobbyRoomController extends BaseController {
  LobbyRoomArgs? _data;
  LobbyRoomPresenter _presenter;
  DownloaderInterface _downloader;
  FilesPickerInterface _filePicker;
  EncoderInterface _encoder;
  RingtonePlayerInterface _ringtone;
  EventBus _eventBus;
  Signaling _signaling;
  UserData _userData;
  DateUtilInterface _dateUtil;
  Box<UnreadChat> _ucBox;
  List<Reaction> _reactions;

  // WebSocketDashboardClient _socket;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final PageController _pageController = PageController(initialPage: 0);

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _streamController = StreamController();
  final FocusNode _focusNodeMsg = FocusNode();
  final FocusNode _focusNodeSearch = FocusNode();

  final GlobalKey messageKey = GlobalKey();

  int _currentPage = 0;
  int _limit = 20;
  int _offset = 0;
  bool _isUploading = false;
  bool _isSendingMessage = false;
  bool isUnRead = false;
  int limitParticipantsPerPage = 6;

  List<Suggestion> userSuggestion = [];
  List<User> _userList;
  List<Chat> _selectedChatId = [];
  List<ObjectReactions> _objectReactions = [];

  // sound controller
  bool _isMuted = true;
  bool _isSpeakerEnabled = true;
  bool _isTalking = false;
  bool _isRaisedHand = false;
  bool _isDeafen = false;

  bool _isSearch = false;
  bool _isSearchFinished = false;
  bool _isDeleteMultiple = false;
  bool _isAuthor = true;

  late double messageFieldSize;

  LobbyRoomController(
    this._presenter,
    this._downloader,
    this._eventBus,
    this._filePicker,
    this._encoder,
    this._signaling,
    this._ringtone,
    this._userData,
    this._dateUtil,
    this._ucBox,
    this._reactions,

    // this._socket,
    this._userList,
  );

  List<Chat> _chats = [];
  List<Chat> _fChats = [];
  List<Chat> _newChats = [];
  List<Chat> _chatsTmp = [];
  List<FileDomain.File> _files = [];
  List<FileDomain.File> _uploadedFiles = [];
  List<int> _filesTmp = [];
  List<PhObject> _searchResults = [];
  List<PhObject> _searchedData = [];
  Map<String, PreviewData> mapData = Map();

  List<User> _participants = []; // voice participants
  List<User> _members = []; // members of room
  List<String> _recentlyReportedIds = [];

  List<Widget> pageViewChildren = [];
  int _pageViewChildrenCount = 0;

  late Room _room;

  // eventbus
  StreamSubscription? _refreshEvent;
  StreamSubscription? _uploadEvent;
  StreamSubscription? _downloadEvent;
  StreamSubscription? _addMemberEvent;

  // getter
  RefreshController get refreshController => _refreshController;

  TextEditingController get textEditingController => _textEditingController;

  TextEditingController get searchController => _searchController;

  FocusNode get focusNodeMsg => _focusNodeMsg;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  PageController get pageController => _pageController;

  List<User> get participants => _participants;

  List<User> get members => _members;

  List<String> get recentlyReportedIds => _recentlyReportedIds;

  List<Chat> get chats => _chats;

  List<FileDomain.File> get files => _files;

  List<FileDomain.File> get uploadedFiles => _uploadedFiles;

  List<Chat> get selectedChatId => _selectedChatId;

  List<ObjectReactions> get objectReactions => _objectReactions;

  DownloaderInterface get downloader => _downloader;

  UserData get userData => _userData;

  int get currentPage => _currentPage;

  Room get room => _room;

  bool get isMuted => _isMuted;

  bool get isSpeakerEnabled => _isSpeakerEnabled;

  bool get isTalking => _isTalking;

  bool get isRaisedHand => _isRaisedHand;

  bool get isDeafen => _isDeafen;

  bool get isUploading => _isUploading;

  bool get isSendingMessage => _isSendingMessage;

  List<PeerData> get peers => _signaling.peers;

  int get pageViewChildrenCount => _pageViewChildrenCount;

  bool get isSearch => _isSearch;

  List<PhObject> get searchResults => _searchResults;

  List<PhObject> get searchedData => _searchedData;

  bool get isSearchFinished => _isSearchFinished;

  bool get isDeleteMultiple => _isDeleteMultiple;

  bool get isAuthor => _isAuthor;

  StreamController<String> get streamController => _streamController;

  DateUtil get dateUtil => _dateUtil as DateUtil;

  List<Reaction> get reactions => _reactions;

  @override
  void getArgs() {
    if (args != null) _data = args as LobbyRoomArgs;
    _room = _data!.room;
    print(_data?.toPrint());
  }

  @override
  void load() {
    if (_data?.type == RoomType.chat) {
      _presenter.onGetListUserFromDb(GetListUserDBRequest());

      if (_reactions.isEmpty) {
        _presenter.onGetReactions(GetReactionsApiRequest());
      }
      this.setScrollListener(() {
        _offset += _limit;
        _getMessages();
      });
      _mapUserListToSuggestion();
      _getMessages();
      _getReportedMessages();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => updateMessageFieldSize());
    } else {
      initCall();
      _presenter.onGetLobbyRooms(GetLobbyRoomsApiRequest());
      _presenter.onGetParticipants(GetParticipantsApiRequest(_room.id));
      _presenter
          .onGetLobbyRoomCalendar(GetLobbyRoomCalendarApiRequest(_room.id));
      _presenter.onGetLobbyRoomTickets(GetLobbyRoomTasksApiRequest(_room.id));
      _presenter.onGetLobbyRoomFiles(GetLobbyRoomFilesApiRequest(_room.id));
      _presenter
          .onGetLobbyRoomStickits(GetLobbyRoomStickitsApiRequest(_room.id));
    }

    _initStream();
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

  void _mapUserListToSuggestion() {
    userSuggestion.clear();
    if (_userList.isNotEmpty) {
      _userList.forEach((user) {
        userSuggestion.add(
          Suggestion(
            imageURL: user.avatar!,
            subtitle: user.name!,
            title: user.fullName!,
          ),
        );
      });
    } else {
      _presenter.onGetListUserFromDb(GetListUserDBRequest());
    }
  }

  List<Suggestion> filterUserSuggestion(String query) {
    return userSuggestion
        .where((user) => user.subtitle.toLowerCase().contains(query))
        .toList();
  }

  void _getMessages() {
    _presenter.onGetMessages(GetMessagesApiRequest(
        roomId: _room.id, limit: _limit, offset: _offset));
  }

  void initCall() {
    _signaling.connect(_room.id);
    delay(() {
      loading(false);
    });
  }

  void backPage() {
    if (_data!.from != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Pages.main, (Route<dynamic> route) => false,
          arguments: MainArgs(Pages.splash));
    } else {
      Navigator.pop(context);
    }
  }

  void onRefresh() async {
    // monitor network fetch
    _refresh();
    await Future.delayed(Duration(milliseconds: 1000));
  }

  @override
  void initListeners() {
    _eventBus.on<ReportingSuccess>().listen((event) async {
      _recentlyReportedIds.add(event.objectPHID);
      _recentlyReportedIds.toSet();

      refreshUI();
    });

    // _socket.streamController?.stream.listen((message) {
    //   print("dashboardwebsocket onMessage: $message");
    //   var msg = jsonDecode(message);
    //
    //   switch (msg['type']) {
    //     case MESSAGE_TYPE:
    //       if (msg["threadPHID"] == _room.id && _data?.type == RoomType.chat) {
    //         delayMillis(() => _refresh(), milliseconds: 500);
    //         // _refresh();
    //       }
    //       break;
    //     default:
    //       break;
    //   }
    // });
    _eventBus.on<NotificationEvent>().listen((event) {
      if (event.type == NotificationType.chat && _data?.type == RoomType.chat) {
        if (event.objectId == _data?.room.id &&
            event.authorId != _userData.id) {
          print("NotificationEvent called");
          _refresh();
        }
      }
    });

    // _eventBus.on<RefreshUserList>().listen((event) {
    //   List<User> userList = [];
    //   userList.addAll(AppComponent.getInjector().get<List<User>>(dependencyName: 'user_list'));
    //   _userList.clear();
    //   _userList.addAll(userList);
    //   _mapUserListToSuggestion();
    //   refreshUI();
    // });

    _presenter.getMessagesOnNext = (List<Chat> chats, PersistenceType type) {
      print("chat: success getMessages");
      bool _isNewMessage = false;
      List<Chat> _chatsResponse = [];
      _chatsResponse.addAll(chats);
      if (_chats.isNotEmpty) {
        String lastChatId =
            _fChats.firstWhere((element) => element.isIdValid()).id;
        int idx =
            _chatsResponse.indexWhere((element) => element.id == lastChatId);
        if (idx > 0) {
          _chatsResponse = _chatsResponse.sublist(0, idx);
          _isNewMessage = true;
        }
      }
      _newChats.clear();
      _newChats.addAll(_chatsResponse);

      _filesTmp.clear();

      _presenter.onGetUsers(
        GetUsersApiRequest(
          ids: _newChats.map((e) => e.sender!.id).toList(),
        ),
        "chat",
        isNewMessage: _isNewMessage,
      );
      refreshUI();
      loading(false);
    };

    _presenter.getMessagesOnComplete = (PersistenceType type) {
      print("chat: completed getMessages");

      _ucBox.put(_room.id, UnreadChat(_room.id, 0));
      _eventBus.fire(RefreshUnreadChat());
      refreshUI();
      loading(false);
    };

    _presenter.getMessagesOnError = (e, PersistenceType type) {
      print("chat: error getMessages $e");
      loading(false);
      _refreshController.refreshFailed();
      refreshUI();
    };

    // send message
    _presenter.sendMessageOnNext = (bool result, PersistenceType type) {
      print("chat: success sendMessage");
      if (type == PersistenceType.api) {
        if (_uploadedFiles.isNotEmpty) {
          // loading(true);
          // // delay(_refresh, period: 2);
          // _refresh();
        }
      }
    };

    _presenter.sendMessageOnComplete = (PersistenceType type) {
      print("chat: completed sendMessage");
      if (type == PersistenceType.api) {
        // _textEditingController.clear();
        // _uploadedFiles.clear();
        // _isSendingMessage = false;
        _refresh();
      }
    };

    _presenter.sendMessageOnError = (e, PersistenceType type) {
      print("chat: error sendMessage $e");
    };

    _presenter.deleteMessageOnNext = (bool result, PersistenceType type) {
      print("room: success deleteMessage $type");
    };

    _presenter.deleteMessageOnComplete = (PersistenceType type) {
      print("room: completed deleteMessage $type");
      _selectedChatId.clear();
      _isDeleteMultiple = false;
      loading(true);
      _getMessages();
      refreshUI();
    };

    _presenter.deleteMessageOnError = (e, PersistenceType type) {
      _selectedChatId.clear();
      _isDeleteMultiple = false;
      print("room: error deleteMessage $e");
    };

    // leave room
    _presenter.deleteRoomOnNext = (bool result, PersistenceType type) {
      print("chat: success deleteRoom");
    };

    _presenter.deleteRoomOnComplete = (PersistenceType type) {
      print("chat: completed deleteRoom");

      // need to refresh room list
      _eventBus.fire(RefreshList());
      Navigator.pop(context);
    };

    _presenter.deleteRoomOnError = (e, PersistenceType type) {
      print("chat: error deleteRoom $e");
    };

    // get object reactions
    _presenter.getObjectReactionOnNext = (
      List<ObjectReactions> result,
      bool isNewMessage,
    ) {
      print("voice: success getObjectReactions ${result.length}");

      if (_offset == 0 && !isNewMessage) {
        _chats.forEach((chat) {
          chat.reactions = [];
        });
        _objectReactions.clear();
        _objectReactions.addAll(result);
      } else {
        _objectReactions.addAll(result);
      }

      result.forEach((reaction) {
        int idx = _chats.indexWhere((chat) => chat.id == reaction.objectId);
        if (idx > -1) {
          if (_chats[idx].reactions != null)
            _chats[idx].reactions?.add(reaction.reaction);
          else
            _chats[idx].reactions = [reaction.reaction];
        }
      });
      refreshUI();
    };

    _presenter.getObjectReactionOnComplete = () {
      print("voice: completed getObjectReactions");
    };

    _presenter.getObjectReactionOnError = (e) {
      print("voice: error getObjectReactions $e");
    };

    // get  reactions
    _presenter.getReactionsOnNext =
        (List<Reaction> result, PersistenceType type) {
      print("voice: success getReactions ${result.length}");
      _reactions.clear();
      _reactions.addAll(result);
      refreshUI();
    };

    _presenter.getReactionsOnComplete = (PersistenceType type) {
      print("voice: completed getReactions");
    };

    _presenter.getReactionsOnError = (e, PersistenceType type) {
      print("voice: error getReactions $e");
    };

    // get files
    _presenter.getFilesOnNext =
        (List<FileDomain.File> files, PersistenceType ptype, String type) {
      print("chat: success getFiles");

      if (type == "upload") {
        files.forEach((f) {
          _textEditingController.text =
              "${_textEditingController.text} {F${f.idInt}}";
        });

        _uploadedFiles.addAll(files);
      }

      if (type == "parsing") {
        // _files.addAll(files);
        files.forEach((f) {
          List<int> ids = [];
          for (var i = 0; i < _chatsTmp.length; i++) {
            var ct = _chatsTmp[i];
            if (ct.attachments != null &&
                ct.attachments!.first.idInt == f.idInt) {
              ids.add(i);
            }
            ids.forEach((idx) {
              _chatsTmp[idx].attachments!.first = f;
            });
          }
        });

        _fChats.addAll(_chatsTmp);
        _chats = _fChats;
        if (ptype == PersistenceType.api && _offset == 0) {
          _presenter.onSendMessage(SendMessageDBRequest(_chats.first));
        }
        _presenter.onGetObjectReactions(GetObjectReactionsApiRequest(
            objectIds: _newChats.map((e) => e.id).toList()));
        loading(false);
        _refreshController.refreshCompleted();
      }
    };

    _presenter.getFilesOnComplete = (PersistenceType type) {
      print("chat: completed getFiles");
      refreshUI();
    };

    _presenter.getFilesOnError = (e, PersistenceType type) {
      print("chat: error getFiles $e");
    };

    _presenter.getLobbyRoomsOnNext = (List<Room> rooms, PersistenceType type) {
      print("voice: success getLobbyRooms $type");
      if (rooms.isEmpty) return;

      if (rooms.where((r) => r.id == _room.id).isNotEmpty) {
        _room = rooms.where((r) => r.id == _room.id).first;
      }

      // _participants.clear();
      // _participants = _room.participants!;

      // recalculate member count
      _recalculateMemberCount();
    };

    _presenter.getLobbyRoomsOnComplete = (PersistenceType type) {
      print("voice: completed getLobbyRooms $type");
      // loading(false);
      refreshUI();
      if (!_userData.voiceTooltipFinished) startShowCase();
    };

    _presenter.getLobbyRoomsOnError = (e, PersistenceType type) {
      print("voice: error getLobbyRooms $e $type");
      loading(false);
      _refreshController.refreshFailed();
      refreshUI();
      if (!_userData.voiceTooltipFinished) startShowCase();
    };

    // upload file
    _presenter.uploadFileOnNext =
        (BaseApiResponse result, PersistenceType type) {
      print("voice: success uploadFile");
      _presenter.onGetFiles(
          GetFilesApiRequest(phids: [result.result]), "upload");
    };

    _presenter.uploadFileOnComplete = (PersistenceType type) {
      print("voice: complete uploadFile");
    };

    _presenter.uploadFileOnError = (e, PersistenceType type) {
      print("voice: error uploadFile");
      _isUploading = false;
      refreshUI();

      if (e is DioError) {
        if (e.response?.statusCode == 413) {
          this.showNotif(
            context,
            S.of(context).chat_upload_failed_too_large,
            period: 6,
            backgroundColor: ColorsItem.redB43600,
            textAlign: TextAlign.center,
          );
        } else {
          this.showNotif(
            context,
            S.of(context).label_something_wrong,
            period: 6,
            backgroundColor: ColorsItem.redB43600,
            textAlign: TextAlign.center,
          );
        }
      }
    };

    // prepare upload file
    _presenter.prepareFileUploadOnNext = (bool result, PersistenceType type) {
      print("voice: success prepareFileUpload");
      //
    };

    _presenter.prepareFileUploadOnComplete = (PersistenceType type) {
      print("voice: completed prepareFileUpload");
      _isUploading = false;
    };

    _presenter.prepareFileUploadOnError = (e, PersistenceType type) {
      print("voice: error prepareFileUpload $e");
    };

    // get users
    _presenter.getUsersOnNext = (
      List<User> users,
      PersistenceType type,
      String from,
      bool isNewMessage,
    ) {
      print("voice: success getUsers from $from $isNewMessage");
      if (from == "chat") {
        // set sender
        _chatsTmp.clear();
        _chatsTmp.addAll(_newChats);
        _newChats.forEach((nc) {
          var idx = _chatsTmp.indexWhere((el) => el.id == nc.id);

          _chatsTmp[idx].sender =
              users.firstWhere((u) => u.id == _chatsTmp[idx].sender!.id);
        });

        // parse chats
        _newChats.forEach((c) {
          _parseChat(c);
        });

        // get files details
        if (_filesTmp.isNotEmpty) {
          _presenter.onGetFiles(GetFilesApiRequest(ids: _filesTmp), "parsing");
        } else {
          if (isNewMessage) {
            _fChats.removeWhere((element) => !element.isIdValid());
            _fChats.insertAll(0, _chatsTmp);
          } else {
            _fChats.addAll(_chatsTmp);
          }
          _presenter.onGetObjectReactions(
            GetObjectReactionsApiRequest(
                objectIds: _chatsTmp.map((e) => e.id).toList()),
            isNewMessage: isNewMessage,
          );
          _chats = _fChats;
          if (type == PersistenceType.api && _offset == 0) {
            _presenter.onSendMessage(SendMessageDBRequest(_chats.first));
          }
          loading(false);
          _refreshController.refreshCompleted();
        }
      } else {
        users.forEach((user) {
          if (_participants.indexWhere((element) => element.id == user.id) ==
              -1) {
            _participants.add(user);
          }
          _recalculateMemberCount();
        });
        setPageViewChildrenCount();
      }
      refreshUI();
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("voice: completed getUsers");
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      print("voice: error getUsers $e");
    };

    // get participants
    _presenter.getParticipantsOnNext =
        (List<User> users, PersistenceType type) {
      print("voice: success getParticipants");

      _members.clear();
      _members.addAll(users);
    };

    _presenter.getParticipantsOnComplete = (PersistenceType type) {
      print("voice: completed getParticipants");
      refreshUI();
    };

    _presenter.getParticipantsOnError = (e, PersistenceType type) {
      print("voice: error getParticipants $e");
    };

    //
    _presenter.addParticipantsOnNext = (bool, PersistenceType type) {
      print("voice: success addParticipants");
    };

    _presenter.addParticipantsOnComplete = (PersistenceType type) {
      print("voice: completed addParticipants");
      refreshUI();
      _refresh();
    };

    _presenter.addParticipantsOnError = (e, PersistenceType type) {
      print("voice: error addParticipants $e");
    };

    // get tickets lobby
    _presenter.getLobbyRoomTicketsOnNext =
        (List<Ticket> tickets, PersistenceType type) {
      print("voice search: success getTickets $type");
      _searchedData.addAll(tickets);
      if (searchController.text.isNullOrBlank())
        _searchResults.addAll(tickets);
      else {
        _searchResults = _searchedData
            .where((u) => u.name!
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      }

      refreshUI();
    };

    _presenter.getLobbyRoomTicketsOnComplete = (PersistenceType type) {
      print("voice search: completed getTickets $type");
    };

    _presenter.getLobbyRoomTicketsOnError = (e, PersistenceType type) {
      print("voice search: error getTickets $e $type");
    };

    // get events lobby
    _presenter.getLobbyRoomCalendarOnNext =
        (List<Calendar> events, PersistenceType type) {
      print("voice search: success getEvents $type");
      _searchedData.addAll(events);
      if (searchController.text.isNullOrBlank())
        _searchResults.addAll(events);
      else {
        _searchResults = _searchedData
            .where((u) => u.name!
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      }

      refreshUI();
    };

    _presenter.getLobbyRoomCalendarOnComplete = (PersistenceType type) {
      print("voice search: completed getEvents $type");
    };

    _presenter.getLobbyRoomCalendarOnError = (e, PersistenceType type) {
      print("voice search: error getEvents $e $type");
    };

    // get files lobby
    _presenter.getLobbyRoomFilesOnNext =
        (List<File> files, PersistenceType type) {
      print("voice search: success getFiles $type");
      _searchedData.addAll(files);
      if (searchController.text.isNullOrBlank())
        _searchResults.addAll(files);
      else {
        _searchResults = _searchedData
            .where((u) => u.name!
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      }

      refreshUI();
    };

    _presenter.getLobbyRoomFilesOnComplete = (PersistenceType type) {
      print("voice search: completed getFiles $type");
    };

    _presenter.getLobbyRoomFilesOnError = (e, PersistenceType type) {
      print("voice search: error getFiles $e $type");
    };

    // get stickits lobby
    _presenter.getLobbyRoomStickitsOnNext =
        (List<Stickit> stickits, PersistenceType type) {
      print("voice search: success getStickits $type");
      _searchedData.addAll(stickits);
      if (searchController.text.isNullOrBlank())
        _searchResults.addAll(stickits);
      else {
        _searchResults = _searchedData
            .where((u) => u.name!
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      }
      stickits.forEach((element) {
        element.spectators!.forEach((spectator) {
          if (spectator.id == _userData.id) {
            isUnRead = true;
          }
        });
      });
      refreshUI();
    };

    _presenter.getLobbyRoomStickitsOnComplete = (PersistenceType type) {
      print("voice search: completed getStickits $type");
    };

    _presenter.getLobbyRoomStickitsOnError = (e, PersistenceType type) {
      print("voice search: error getStickits $e $type");
    };

    _refreshEvent?.cancel();
    _refreshEvent = _eventBus.on<Refresh>().listen((event) {
      _refresh();
    });

    _addMemberEvent?.cancel();
    _addMemberEvent = _eventBus.on<AddMember>().listen((event) async {
      var result = await Navigator.pushNamed(context, Pages.objectSearch,
          arguments: ObjectSearchArgs("user",
              title: S.of(context).create_form_search_user_label,
              placeholderText: S.of(context).create_form_search_user_select));
      var selectedUsers = result as List<PhObject>;
      selectedUsers.forEach((se) {
        var idx = _members.indexWhere((e) => e.id == se.id);
        if (idx < 0) {
          _members.add(User(se.id,
              name: se.name, fullName: se.fullName, avatar: se.avatar));
        }
      });

      _presenter.onAddParticipants(AddParticipantsApiRequest(
          _room.id, selectedUsers.map((e) => e.id).toList()));
    });

    // webrtc
    _signaling.onEventCallback = (String event, dynamic data) {
      print("onEventCallback: $event $data");

      switch (event) {
        case JOINED_EVENT:
          var id = data['id'];
          if (_signaling.peers
                  .indexWhere((element) => element.peerPHID == id) !=
              -1) {
            _presenter.onGetUsers(GetUsersApiRequest(ids: [id]), "voice");
            _ringtone.play();
          }
          break;
        case LEFT_EVENT:
          if (data['id'] != _userData.id) {
            _participants.removeWhere((p) => p.id == data['id']);
            _recalculateMemberCount();
            _ringtone.play();
          }
          refreshUI();
          break;
        case AUTHENTICATED_EVENT:
          _presenter.onGetUsers(
              GetUsersApiRequest(ids: [_userData.id]), "voice");
          break;
        default:
          break;
      }
    };

    _signaling.onConnectionStateChange = (RTCIceConnectionState state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateConnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateClosed ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        loading(false);
      }

      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected) {
        this.showNotif(context, "Disconnected");
        _ringtone.play();
      }
    };

    _signaling.onDataChannelMessage =
        (RTCDataChannel dc, RTCDataChannelMessage data) {
      var text = jsonDecode(data.text);
      if (text['type'] == "ehlo") {
        List<String> ids = [_userData.id];
        _signaling.peers.forEach((element) {
          ids.add(element.peerPHID);
        });
        _presenter.onGetUsers(GetUsersApiRequest(ids: ids), "voice");
      }
      refreshUI();
    };

    _signaling.onLocalStream = ((stream) {
      // _localRenderer.srcObject = stream;
      print("onAddLocalStream ${stream.id}");
    });

    _signaling.onAddRemoteStream = ((stream) {
      print("onAddRemoteStream ${stream.id}");
    });

    _signaling.onRemoveRemoteStream = ((stream) {
      print("onRemoveRemoteStream $stream");
    });

    // send reaction
    _presenter.sendReactionOnNext = (bool result, PersistenceType type) {
      print("lobby room: success sendReaction");
    };

    _presenter.sendReactionOnComplete = (PersistenceType type) {
      print("lobby room: completed sendReaction");
      _refresh();
    };

    _presenter.sendReactionOnError = (e, PersistenceType type) {
      print("lobby room: error sendReaction $e");
    };
    _presenter.getListUserFromDbOnNext =
        (List<User> users, PersistenceType type) {
      print("lobby: on Next get List User ${users.map((e) => e.name)}");
      _userList.clear();
      _userList.addAll(users);
      userSuggestion.clear();
      users.forEach((e) {
        userSuggestion.add(
          Suggestion(
            imageURL: e.avatar!,
            subtitle: e.name!,
            title: e.fullName!,
          ),
        );
      });
    };
    _presenter.getListUserFromDbOnComplete = (PersistenceType type) {
      print("lobby: completed get List User $type");
    };
    _presenter.getListUserFromDbOnError = (e, PersistenceType type) {
      print("lobby: on Error get List User $e $type");
    };

    _presenter.getTicketsOnNext = (List<Ticket> tickets, PersistenceType type) {
      print("notification: success getTickets ${tickets.length} $type");
      if (tickets.isNotEmpty && tickets.length == 1) {
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          Pages.detail,
          arguments: DetailArgs(tickets.first),
        );
      } else {
        Navigator.pop(context);
        showNotif(context, S.of(context).label_search_empty);
      }
    };

    _presenter.getTicketsOnComplete = (PersistenceType type) {
      print("notification: completed getTickets $type");
    };

    _presenter.getTicketsOnError = (e, PersistenceType type) {
      print("notification: error getTickets $e $type");
      Navigator.pop(context);
      showNotif(context, "Something went wrong...");
    };

    _presenter.getEventsOnNext = (List<Calendar> calendars) {
      print("profile: success getEvents");
      if (calendars.isNotEmpty && calendars.length == 1) {
        Navigator.pop(context);
        // Navigator.pushNamed(
        //   context,
        //   Pages.detail,
        //   arguments: DetailArgs(calendars.first),
        // );
        Navigator.pushNamed(
          context,
          Pages.eventDetail,
          arguments: DetailEventArgs(phid: calendars.first.id),
        );
      } else {
        Navigator.pop(context);
        showNotif(context, S.of(context).label_search_empty);
      }
    };

    _presenter.getEventsOnComplete = () {
      print("profile: completed getEvents");
      loading(false);
    };

    _presenter.getEventsOnError = (e) {
      print("profile: error getEvents $e");
      Navigator.pop(context);
      showNotif(context, "Something went wrong...");
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
  }

  startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ShowCaseWidget.of(context).startShowCase([six]);
    });
  }

  void _initStream() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _searchResults = searchedData
          .where((u) => u.name!.toLowerCase().contains(s.toLowerCase()))
          .toList();

      _isSearchFinished = false;

      if (_searchResults
          .where((u) => u.name!.toLowerCase().contains(s.toLowerCase()))
          .isNotEmpty) {
        _isSearchFinished = true;
      } else if (_searchResults
          .where((u) => u.name!.toLowerCase().contains(s.toLowerCase()))
          .isEmpty) {
        _isSearchFinished = true;
      }

      refreshUI();
    });
  }

  void onPageChanged(int page) {
    _currentPage = page;
    refreshUI();
  }

  void setPageViewChildrenCount() {
    if (_participants.length <= limitParticipantsPerPage) {
      _pageViewChildrenCount = 1;
    }
    if (_participants.length % limitParticipantsPerPage == 0) {
      _pageViewChildrenCount = _participants.length ~/ limitParticipantsPerPage;
    } else if (_participants.length > limitParticipantsPerPage) {
      _pageViewChildrenCount =
          _participants.length ~/ limitParticipantsPerPage + 1;
    }
  }

  void onGetPreviewData(String id, PreviewData data) {
    mapData[id] = data;
    refreshUI();
  }

  void showAuthorsReaction(String chatId,
      Map<String, List<Reaction>> reactionMapList, String reactionId) {
    List<ObjectReactions> listAllReactions = [];

    listAllReactions
        .addAll(_objectReactions.where((object) => object.objectId == chatId));

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return AuthorReactionSheet(
            reactionMapList: reactionMapList,
            listAllReactions: listAllReactions,
            reactionId: reactionId,
            userList: _userList,
          );
        });
  }

  void _recalculateMemberCount() {
    var counts = _room.memberCount?.split("/");
    if (!counts.isNullOrEmpty()) {
      counts![0] = _participants.length.toString();
      _room.memberCount = counts.join("/");
    }
    refreshUI();
  }

  void setMute() {
    _isMuted = !_isMuted;
    _signaling.muteMic(_isMuted);
    refreshUI();
  }

  void setSpeaker() {
    _isSpeakerEnabled = !_isSpeakerEnabled;
    _signaling.enableSpeaker(_isSpeakerEnabled);
    refreshUI();
  }

  bool checkIsMuted(String? id) {
    if (id == _signaling.localData?.peerPHID) {
      return _signaling.localData!.muted;
    }
    var target = _signaling.peers.where((t) => t.peerPHID == id);
    if (target.isNotEmpty) {
      return target.first.muted;
    }
    print("checkIsMuted: $id ");
    return true;
  }

  void _parseChat(Chat chatMsg) {
    var msg = chatMsg.message;
    List<String?> fileMsg = DataUtil.getFiles(msg);
    if (fileMsg.isNotEmpty) {
      var prefix = "";
      var suffix = "";
      var existingIdx = _chatsTmp.indexWhere((ei) => ei.id == chatMsg.id);

      if (fileMsg.isNotEmpty) {
        _chatsTmp.removeAt(existingIdx);
      }

      fileMsg.forEach((m) {
        if (!m.isNullOrEmpty()) {
          var parts = msg.split(m!);
          prefix = parts[0].trim();
          suffix = parts.sublist(1).join(m).trim();

          var ch = Chat(chatMsg.id, chatMsg.createdAt, chatMsg.message,
              chatMsg.isFromSystem, chatMsg.roomId,
              sender: chatMsg.sender);
          var mInt = int.parse(m.replaceAll(RegExp(r"{F|}"), ""));
          ch.message = "Berisi file $mInt"; // set empty message
          ch.attachments = [FileDomain.File("", idInt: mInt, createdAt: null)];

          _chatsTmp.insert(existingIdx, ch);

          msg = suffix;
          _filesTmp.add(mInt);

          if (prefix.isNotEmpty && !DataUtil.isFile(prefix)) {
            _chatsTmp.insert(
                existingIdx + 1,
                (Chat(
                  chatMsg.id,
                  chatMsg.createdAt,
                  prefix,
                  chatMsg.isFromSystem,
                  chatMsg.roomId,
                  sender: chatMsg.sender,
                )));
          }
        }

        if (suffix.isNotEmpty && !DataUtil.isFile(suffix)) {
          _chatsTmp.insert(
              existingIdx - 1 < 0 ? 0 : existingIdx,
              (Chat(
                chatMsg.id,
                chatMsg.createdAt,
                suffix,
                chatMsg.isFromSystem,
                chatMsg.roomId,
                sender: chatMsg.sender,
              )));
        }
      });
    }
  }

  void downloadOrOpenFile(String url) {
    showNotif(context, S.of(context).chat_on_download_label);
    _downloader.startDownloadOrOpen(url, context);
  }

  void goToRoomChat() {
    Navigator.pushNamed(context, Pages.roomChat,
        arguments: LobbyRoomArgs(_room, type: RoomType.chat));
  }

  void gotToChannelSetting() {
    Navigator.pushNamed(context, Pages.channelSetting,
        arguments: ChannelSettingArgs(_room));
  }

  void goToDetail(PhObject object) {
    Navigator.pushNamed(context, Pages.detail, arguments: DetailArgs(object));
  }

  void goToTicketDetail(Ticket ticket) {
    Navigator.pushNamed(
      context,
      Pages.ticketDetail,
      arguments: DetailTicketArgs(
        phid: ticket.id,
        id: ticket.intId,
      ),
    );
  }

  void goToEventDetail(PhObject object) {
    Navigator.pushNamed(
      context,
      Pages.eventDetail,
      arguments: DetailEventArgs(phid: object.id),
    );
  }

  void goToProfile(User user) {
    Navigator.pushNamed(context, Pages.profile,
        arguments: ProfileArgs(user: user));
  }

  Future<void> upload(FileDomain.FileType type) async {
    FilePickerResult? result = await _filePicker.pick(type);

    if (result != null) {
      _isUploading = true;
      refreshUI();
      result.files.forEach((el) {
        // prepare file allocate
        _presenter.onPrepareUploadFile(PrepareCreateFileApiRequest(
            el.name, _encoder.encodeBytes(el.bytes!).length));

        // upload
        _presenter.onUploadFile(
            CreateFileApiRequest(el.name, _encoder.encodeBytes(el.bytes!)));
      });
    } else {
      // canceled
    }
  }

  String formatChatGroupDate(DateTime dt) {
    return _dateUtil.format("d MMMM y", dt);
  }

  String formatChatTime(DateTime dt) {
    return _dateUtil.basicTimeFormat(dt);
  }

  Future<void> onOpen(String link) async {
    if (link[0] == '@') {
      var username = link.split('@').last;
      int index = _userList.indexWhere((element) => element.name == username);
      if (index > 0) goToProfile(_userList[index]);
    } else if (link[0] == 'T') {
      showOnLoading(context, "Loading ...");
      int? id = int.tryParse(link.split('T').last);
      _presenter.onGetTickets(
        GetTicketsApiRequest(
          queryKey: GetTicketsApiRequest.QUERY_ALL,
          ids: [id ?? 0],
          limit: 1,
        ),
      );
    } else if (link[0] == 'E') {
      showOnLoading(context, "Loading ...");
      int? id = int.tryParse(link.split('E').last);
      _presenter.onGetCalendars(
        GetEventsApiRequest(
          ids: [id ?? 0],
          limit: 1,
        ),
      );
    } else {
      if (await canLaunch(link)) {
        await launch(link);
      } else {
        throw 'Could not launch $link';
      }
    }
  }

  void goToMediaDetail(MediaType type, String url, String title) {
    Navigator.pushNamed(context, Pages.mediaDetail,
        arguments: MediaArgs(
          type: type,
          url: url,
          title: title,
        ));
  }

  void selectNavbar(String pages) {
    Navigator.pushNamedAndRemoveUntil(context, Pages.main, (_) => false,
        arguments: MainArgs(Pages.lobbyRoom, to: pages));
  }

  void backToMainPage(String pages) async {
    await callDispose();
    Navigator.pop(context, pages);
  }

  void cancelUpload(FileDomain.File file) {
    var txt = _textEditingController.text;
    txt = txt.replaceAll("{F${file.idInt}}", "").trim();
    _uploadedFiles.remove(file);
    _textEditingController.text = txt;
    refreshUI();
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
        room.id,
        sender: _userData.toUser(),
        reactions: [],
      ),
    );
    _presenter.onSendMessage(
      SendMessageApiRequest(
        room.id,
        _textEditingController.text,
      ),
    );
    refreshUI();
    _textEditingController.clear();
    _uploadedFiles.clear();
    _isSendingMessage = false;
  }

  void deleteMessage() {
    _presenter.onDeleteMessage(
        DeleteMessageApiRequest(_selectedChatId.map((e) => e.id).toList()));
  }

  void onReportMessage() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments: ReportArgs(
                phId: _selectedChatId.first.id, reportedType: "MESSAGE ROOM"),
          );
        });
  }

  void deleteRoomChat() {
    _presenter.onDeleteRoom(DeleteRoomApiRequest(_room.id));
  }

  void sendReaction(reactionId, objectId) {
    _presenter.onSendReaction(GiveReactionApiRequest(reactionId, objectId));
  }

  _refresh() {
    _offset = 0;
    // _chats.clear();
    // _fChats.clear();
    // _chats.forEach((chat) {
    //   chat.reactions = [];
    // });
    _newChats.clear();
    _chatsTmp.clear();
    _files.clear();
    _uploadedFiles.clear();
    _filesTmp.clear();
    _getMessages();
  }

  Future<void> callDispose() async {
    await _signaling.close();
  }

  void onSearch(bool isSearching) {
    _isSearch = isSearching;

    if (_isSearch) {
      _focusNodeSearch.requestFocus();
    } else {
      _focusNodeSearch.unfocus();
      _searchController.clear();
    }
    refreshUI();
  }

  void cancelSearch() {
    onSearch(false);
    refreshUI();
  }

  void onFocusChange() {
    if (_focusNodeMsg.hasFocus) {
      // Hide sticker when keyboard appear
    }

    if (_focusNodeSearch.hasFocus) {
      // Hide sticker when keyboard appear
    }
  }

  updateMessageFieldSize() {
    BuildContext? context = messageKey.currentContext;
    if (context != null) {
      RenderBox box = context.findRenderObject() as RenderBox;
      messageFieldSize = box.size.height;
    } else {
      messageFieldSize = MediaQuery.of(this.context).size.height / 10;
    }
    print("height: $messageFieldSize");
    refreshUI();
  }

  void onCancelSelectedChat() {
    _isDeleteMultiple = false;
    _selectedChatId.clear();
    refreshUI();
  }

  void onLongPress(Chat chat) {
    _isDeleteMultiple = _isDeleteMultiple == false ? true : false;
    if (_selectedChatId.contains(chat)) {
      _selectedChatId.remove(chat);
    } else {
      _selectedChatId.add(chat);
    }
    print("onLongPress :${_selectedChatId.map((e) => e.message)}");
    refreshUI();
  }

  void onSelectedItems(Chat chat) {
    bool author = chat.sender?.id == userData.id;
    author == true ? _isAuthor = true : _isAuthor = false;
    if (_selectedChatId.contains(chat)) {
      _selectedChatId.remove(chat);
    } else {
      _selectedChatId.add(chat);
    }
    print("onSelectedItems :${_selectedChatId.map((e) => e.message)}");
    refreshUI();
  }

  @override
  void disposing() {
    _presenter.dispose();
    _downloadEvent?.cancel();
    _uploadEvent?.cancel();
    _refreshEvent?.cancel();
    _addMemberEvent?.cancel();
    _streamController.close();
  }
}
