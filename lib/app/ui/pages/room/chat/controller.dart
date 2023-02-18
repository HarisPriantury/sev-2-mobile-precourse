import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sev2/app/infrastructures/events/download.dart';
import 'package:mobile_sev2/app/infrastructures/events/notification.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/signaling.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/downloader_interface.dart';
import 'package:mobile_sev2/data/infrastructures/encoder_interface.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/infrastructures/files_picker_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/delete_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/send_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/file/create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/prepare_create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/delete_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/db/chat/send_message_db_request.dart';
import 'package:mobile_sev2/data/payload/db/lobby/get_list_user_db_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart' as FileDomain;
import 'package:mobile_sev2/domain/meta/unread_chat.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatController extends SheetController {
  ChatArgs? _data;
  Signaling _signaling;

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNodeMsg = FocusNode();
  final FocusNode _focusNodeSearch = FocusNode();
  late final AnimationController animationController;
  StreamController<String> _streamController = StreamController();
  ItemScrollController _itemScrollController = ItemScrollController();
  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  final GlobalKey messageKey = GlobalKey();

  // properties
  ChatPresenter _presenter;
  UserData _userData;
  DateUtilInterface _dateUtil;
  FilesPickerInterface _filePicker;
  EncoderInterface _encoder;
  EventBus _eventBus;
  DownloaderInterface _downloader;
  Box<UnreadChat> _ucBox;

  bool _hasMoreData = false;
  bool _isScroll = false;

  // WebSocketDashboardClient _socket;

  bool _isVoice = false;
  bool _isMuted = true;
  bool _isSpeakerEnabled = true;
  bool _isSearch = false;
  bool _isReplay = false;
  bool _isUploading = false;
  bool _isSendingMessage = false;
  int _limit = 20;
  int _offset = 0;
  int _focusedIndex = 0;
  bool _onRequestCompleted = true;
  bool _isDeleteMultiple = false;
  bool _isActiveReply = false;
  bool _isAuthor = true;
  late Room? _room;
  late double messageFieldSize;
  int? _progress = 0;
  DownloadTaskStatus? _status;
  String? _taskId;
  String _senderRepliedMessage = "";
  String get senderRepliedMessage => _senderRepliedMessage;
  String _repliedMessage = "";
  String get repliedMessage => _repliedMessage;

  List<Chat> _chats = [];
  List<Chat> _fChats = [];
  List<int> _searchedIndexList = [];
  List<Chat> _newChats = [];
  List<Chat> _chatsTmp = [];
  List<FileDomain.File> _files = [];
  List<FileDomain.File> _uploadedFiles = [];
  List<FileDomain.File> _cFiles = [];
  List<int> _filesTmp = [];
  List<User> _userList;
  List<Suggestion> userSuggestion = [];
  Map<String, PreviewData> linkPreviewData = Map();
  Map<String, DownloaderEvent> linkDownloadData = Map();
  List<Chat> _selectedChatId = [];

  // for DMs
  late String _dmName;
  late String _dmAvatar;

  // getter
  List<Chat> get chats => _chats;

  List<Chat> get selectedChatId => _selectedChatId;

  List<int> get searchedIndex => _searchedIndexList;

  List<FileDomain.File> get uploadedFiles => _uploadedFiles;

  UserData get userData => _userData;

  bool get isScroll => _isScroll;

  TextEditingController get textEditingController => _textEditingController;

  TextEditingController get searchController => _searchController;

  StreamController<String> get streamController => _streamController;

  ItemScrollController get itemScrollController => _itemScrollController;

  ItemPositionsListener get itemPositionListener => _itemPositionsListener;

  FocusNode get focusNodeMsg => _focusNodeMsg;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  DownloaderInterface get downloader => _downloader;

  Room? get room => _room;

  bool get isVoice => _isVoice;

  bool get isMuted => _isMuted;

  bool get isSpeakerEnabled => _isSpeakerEnabled;

  bool get isSearch => _isSearch;

  bool get isReplay => _isReplay;

  bool get isUploading => _isUploading;

  bool get isSendingMessage => _isSendingMessage;

  bool get isDeleteMultiple => _isDeleteMultiple;

  bool get isActiveReply => _isActiveReply;

  bool get isAuthor => _isAuthor;

  int get limit => _limit;

  int get offset => _offset;

  int get focusedIndex => _focusedIndex;

  int? get progress => _progress;

  DownloadTaskStatus? get status => _status;

  String? get taskId => _taskId;

  // lobby data

  List<FileDomain.File> get files => _files;

  List<FileDomain.File> get cFiles => _cFiles;

  // for DMs
  String get roomName => _dmName;

  String get roomAvatar => _dmAvatar;

  // eventbus
  StreamSubscription? _refreshEvent;
  StreamSubscription? _uploadEvent;

  ChatController(
    this._presenter,
    this._userData,
    this._dateUtil,
    this._filePicker,
    this._encoder,
    this._eventBus,
    this._downloader,
    this._ucBox,
    this._signaling,
    // this._socket,
    this._userList,
  );

  void setVoiceMode(bool value) {
    _isVoice = value;
    refreshUI();
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

  void backPage() {
    if (_data!.from == Pages.splash) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Pages.main, (Route<dynamic> route) => false,
          arguments: MainArgs(Pages.splash));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void load() {
    _mapUserListToSuggestion();
    _focusNodeMsg.addListener(onFocusChange);
    _focusNodeSearch.addListener(onFocusChange);
    _itemPositionsListener.itemPositions.addListener(() {
      final value = _itemPositionsListener.itemPositions.value;

      int count = _chats.length;
      ItemPosition last = value.last;

      bool isAtLastIndex = last.index == count - 1;

      // load data from the next page if at the bottom
      if (_hasMoreData) {
        if (isAtLastIndex && _onRequestCompleted) {
          _offset += _limit;
          _getMessages();
          _onRequestCompleted = false;
          _isScroll = true;
        }
      }
    });

    _initStream();
    _getMessages();
    initCall();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateMessageFieldSize());
  }

  void _getMessages() {
    loading(true);
    _presenter.onGetMessages(GetMessagesApiRequest(
        roomId: _room?.id, limit: _limit, offset: _offset));
  }

  void downloadFile(String msg, String chatId) async {
    showNotif(context, S.of(context).chat_on_download_label);
    String? taskId = await _downloader.startDownloadOrOpen(msg, context);
    if (taskId != null)
      linkDownloadData[chatId] =
          DownloaderEvent(taskId, DownloadTaskStatus.enqueued, 0);
  }

  User getOtherMember() {
    return room!.participants!
        .firstWhere((element) => element.id != _userData.id);
  }

  void onGetPreviewData(String id, PreviewData data) {
    linkPreviewData[id] = data;
    refreshUI();
  }

  // this is primiarily used when user do search
  // it will only do search when there is a pause on key press
  void _initStream() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      // _chats = _fChats.where((u) => u.message.toLowerCase().contains(s.toLowerCase())).toList();
      _searchedIndexList.clear();
      _fChats.forEach((chat) {
        if (chat.message.toLowerCase().contains(s.toLowerCase())) {
          _searchedIndexList.add(_fChats.indexOf(chat));
        }
      });
      _focusedIndex = -1;
      scrollNext();
      refreshUI();
    });
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as ChatArgs;
      _room = _data?.room?.clone();
      _dmName = getOtherMember().getFullName() ?? "";
      _dmAvatar = getOtherMember().avatar!;
    }
  }

  _refresh() {
    _offset = 0;
    // _chats.clear();
    // _fChats.clear();
    _newChats.clear();
    _chatsTmp.clear();
    _files.clear();
    _uploadedFiles.clear();
    _filesTmp.clear();
    _getMessages();
  }

  void setReplay(bool replay) {
    _isReplay = replay;
    refreshUI();
  }

  int searchedFocusedIndex() {
    if (_searchedIndexList.isNotEmpty) {
      return _searchedIndexList[focusedIndex];
    } else
      return -1;
  }

  void scrollNext() {
    if (_searchedIndexList.isNotEmpty) {
      if (_focusedIndex < _searchedIndexList.length) _focusedIndex++;
      _itemScrollController.scrollTo(
          index: _searchedIndexList[focusedIndex],
          duration: Duration(microseconds: 300));
      refreshUI();
    }
  }

  void scrollPrevious() {
    if (_searchedIndexList.isNotEmpty) {
      if (_focusedIndex > 0) _focusedIndex--;
      _itemScrollController.scrollTo(
          index: _searchedIndexList[focusedIndex],
          duration: Duration(microseconds: 300));
      refreshUI();
    }
  }

  void onFocusChange() {
    if (_focusNodeMsg.hasFocus) {
      // Hide sticker when keyboard appear
    }

    if (_focusNodeSearch.hasFocus) {
      // Hide sticker when keyboard appear
    }
  }

  void initCall() {
    if (_room != null) _signaling.connect(_room!.id);
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

  bool checkIsMuted() {
    var target =
        _signaling.peers.where((t) => t.peerPHID == getOtherMember().id);
    if (target.isNotEmpty) {
      return target.first.muted;
    }
    print("checkIsMuted: ${getOtherMember().id}");
    return true;
  }

  void deleteRoomChat() {
    _presenter.onDeleteRoom(DeleteRoomApiRequest(_room!.id));
  }

  void openDocument() {
    Navigator.pushNamed(context, Pages.roomDetail,
        arguments: RoomDetailArgs(_room!, _files));
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
        room!.id,
        sender: _userData.toUser(),
        quotedChat: QuotedChat("", _repliedMessage),
      ),
    );
    _presenter.onSendMessage(
      SendMessageApiRequest(
        room!.id,
        _repliedMessage != ""
            ? "$_senderRepliedMessage\n>$_repliedMessage\n${_textEditingController.text}"
            : "${_textEditingController.text}",
      ),
    );
    refreshUI();
    _textEditingController.clear();
    _uploadedFiles.clear();
    _isSendingMessage = false;
    _repliedMessage = "";
    _isActiveReply = false;
  }

  void deleteMessage() {
    Navigator.pop(context);
    showOnLoading(context, "Loading...");
    var messageToRemove = [];
    _chats.forEach((element) {
      for (var i = 0; i < _selectedChatId.length; i++) {
        if (_selectedChatId[i].id == element.id) {
          messageToRemove.add(element.id);
        }
      }
    });
    _chats.removeWhere((e) => messageToRemove.contains(e.id));
    refreshUI();
    _presenter.onDeleteMessage(
        DeleteMessageApiRequest(_selectedChatId.map((e) => e.id).toList()));
  }

  void deleteSelectedMessage(Chat chat) {
    Navigator.pop(context);
    showOnLoading(context, "Loading...");
    _presenter.onDeleteMessage(DeleteMessageApiRequest([chat.id]));
    _chats.removeWhere((element) => element.id == chat.id);
  }

  void sendReaction(reactionId, objectId) {
    _presenter.onSendReaction(GiveReactionApiRequest(reactionId, objectId));
  }

  String formatChatGroupDate(DateTime dt) {
    return _dateUtil.format("d MMMM y", dt);
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
        delay(() => _presenter.onUploadFile(
            CreateFileApiRequest(el.name, _encoder.encodeBytes(el.bytes!)),
            from: 'chat'));
      });
    } else {
      // canceled
    }
  }

  Future<void> uploadRoomFile() async {
    FilePickerResult? result = await _filePicker.pickAllTypes();

    if (result != null) {
      result.files.forEach((el) {
        // prepare file allocate
        _presenter.onPrepareUploadFile(PrepareCreateFileApiRequest(
            el.name, _encoder.encodeBytes(el.bytes!).length));

        // upload
        delay(
          () => _presenter.onUploadFile(
              CreateFileApiRequest(el.name, _encoder.encodeBytes(el.bytes!),
                  roomId: _room?.id),
              from: 'lobby'),
        );
      });
    } else {
      // canceled
    }
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

  String formatChatTime(DateTime dt) {
    return _dateUtil.basicTimeFormat(dt);
  }

  void cancelUpload(FileDomain.File file) {
    var txt = _textEditingController.text;
    txt = txt.replaceAll("{F${file.idInt}}", "").trim();
    _uploadedFiles.remove(file);
    _textEditingController.text = txt;
    refreshUI();
  }

  @override
  void initListeners() {
    // _socket.streamController?.stream.listen((message) {
    //   print("dashboardwebsocket onMessage: $message");
    //   var msg = jsonDecode(message);
    //
    //   switch (msg['type']) {
    //     case MESSAGE_TYPE:
    //       if (msg["threadPHID"] == _room?.id) {
    //         _refresh();
    //       }
    //       break;
    //     default:
    //       break;
    //   }
    // });
    _eventBus.on<NotificationEvent>().listen((event) {
      if (event.type == NotificationType.chat) {
        if (event.objectId == _data?.room?.id &&
            event.authorId != _userData.id) {
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

    // get messages
    _presenter.getMessagesOnNext = (List<Chat> chats, PersistenceType type) {
      print("chat: success getMessages");
      if (chats.length >= _limit) {
        _hasMoreData = true;
      } else {
        _hasMoreData = false;
      }

      bool _isNewMessage = false;
      List<Chat> _chatsResponse = [];
      _chatsResponse.addAll(chats);
      if (_chats.isNotEmpty || !_onRequestCompleted) {
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
      if (_offset != 0) _onRequestCompleted = true;

      _presenter.onGetUsers(
        GetUsersApiRequest(
          ids: _newChats.map((e) => e.sender!.id).toList(),
        ),
        isNewMessage: _isNewMessage,
      );
    };

    _presenter.getMessagesOnComplete = (PersistenceType type) {
      print("chat: completed getMessages");

      _ucBox.put(_room?.id, UnreadChat(_room!.id, 0));
      _eventBus.fire(RefreshUnreadChat());
      loading(false);
    };

    _presenter.getMessagesOnError = (e, PersistenceType type) {
      print("chat: error getMessages $e");
    };

    _presenter.deleteMessageOnNext = (bool result, PersistenceType type) {
      print("chat: success deleteMessage $result");
    };

    _presenter.deleteMessageOnComplete = (PersistenceType type) {
      showNotif(context, "Pesan Berhasil dihapus");
      print("chat: completed deleteMessage $type");
      _selectedChatId.clear();
      _isDeleteMultiple = false;
      _refresh();
      Navigator.pop(context);
    };

    _presenter.deleteMessageOnError = (e, PersistenceType type) {
      print("chat: error deleteMessage $e");
      _selectedChatId.clear();
      _isDeleteMultiple = false;
      _refresh();
    };

    // send message
    _presenter.sendMessageOnNext = (bool result, PersistenceType type) {
      print("chat: success sendMessage $type");
      if (type == PersistenceType.api) {
        if (_uploadedFiles.isNotEmpty) {
          loading(true);
          delay(_refresh, period: 2);
        }
      }
    };

    _presenter.sendMessageOnComplete = (PersistenceType type) {
      print("chat: completed sendMessage $type");
      if (type == PersistenceType.api) {
        // _textEditingController.clear();
        // _uploadedFiles.clear();
        // _isSendingMessage = false;
        _refresh();
      }
    };

    _presenter.sendMessageOnError = (e, PersistenceType type) {
      print("chat: error sendMessage $e $type");
    };

    // send reaction
    _presenter.sendReactionOnNext = (bool result, PersistenceType type) {
      print("chat: success sendReaction");
      //
    };

    _presenter.sendReactionOnComplete = (PersistenceType type) {
      print("chat: completed sendReaction");
    };

    _presenter.sendReactionOnError = (e, PersistenceType type) {
      print("chat: error sendReaction $e");
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
        _files.addAll(files);
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
        print("condition: ${ptype == PersistenceType.api && _offset == 0}");
        loading(false);
      }
    };

    _presenter.getFilesOnComplete = (PersistenceType type) {
      print("chat: completed getFiles");
      refreshUI();
    };

    _presenter.getFilesOnError = (e, PersistenceType type) {
      print("chat: error getFiles $e");
    };

    // upload file
    _presenter.uploadFileOnNext =
        (BaseApiResponse result, PersistenceType type, String from) {
      print("chat: success uploadFile $type $from");

      if (from == 'chat') {
        // got file phid, now get file detail
        _presenter.onGetFiles(
            GetFilesApiRequest(phids: [result.result]), "upload");
      }
    };

    _presenter.uploadFileOnComplete = (PersistenceType type, String from) {
      print("chat: complete uploadFile $type $from");
    };

    _presenter.uploadFileOnError = (e, PersistenceType type, String from) {
      print("chat: error uploadFile $type $from");

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
      print("chat: success prepareFileUpload");
      //
    };

    _presenter.prepareFileUploadOnComplete = (PersistenceType type) {
      print("chat: completed prepareFileUpload");
      _isUploading = false;
    };

    _presenter.prepareFileUploadOnError = (e, PersistenceType type) {
      print("chat: error prepareFileUpload $e");
    };

    // get users
    _presenter.getUsersOnNext = (
      List<User> users,
      PersistenceType type,
      bool isNewMessage,
    ) {
      print("chat: success getUsers, isNewMessage: $isNewMessage");

      // set sender
      _chatsTmp.clear();
      _chatsTmp.addAll(_newChats);
      _newChats.forEach((nc) {
        var idx = _chatsTmp.indexWhere((el) => el.id == nc.id);
        _chatsTmp[idx].sender =
            users.firstWhere((u) => u.id == _chatsTmp[idx].sender?.id);
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
          _fChats.removeWhere((element) {
            if (!element.isIdValid()) {
              print("deleted: ${element.message}");
              return true;
            }
            return false;
          });
          _fChats.insertAll(0, _chatsTmp);
        } else {
          _fChats.addAll(_chatsTmp);
        }
        _chats = _fChats;
        if (type == PersistenceType.api && _offset == 0) {
          _presenter.onSendMessage(SendMessageDBRequest(_chats.first));
        }
        loading(false);
      }

      _presenter.getTicketsOnNext =
          (List<Ticket> tickets, PersistenceType type) {
        print("notification: success getTickets ${tickets.length} $type");
        if (tickets.isNotEmpty && tickets.length == 1) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            Pages.ticketDetail,
            arguments: DetailTicketArgs(
              phid: tickets.first.id,
              id: tickets.first.intId,
            ),
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
    };

    _presenter.getUsersOnComplete = (
      PersistenceType type,
      bool isNewMessage,
    ) {
      print("chat: completed getUsers");
    };

    _presenter.getUsersOnError = (
      e,
      PersistenceType type,
      bool isNewMessage,
    ) {
      print("chat: error getUsers $e");
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

    _signaling.onEventCallback = (String event, dynamic data) {
      print("onEventCallback: $event $data");

      switch (event) {
        case LEFT_EVENT:
          if (data['id'] != _userData.id) {
            this.showNotif(
                context, "${getOtherMember().name} has left the call");
          }
          refreshUI();
          break;
        default:
          break;
      }
    };

    _signaling.onConnectionStateChange = (RTCIceConnectionState state) {
      if (state == RTCIceConnectionState.RTCIceConnectionStateConnected) {
        this.showNotif(context, "Connected to call");
      }

      if (state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateClosed ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        this.showNotif(context, "Disconnected from call");
      }
    };

    _signaling.onDataChannelMessage =
        (RTCDataChannel dc, RTCDataChannelMessage data) {
      var text = jsonDecode(data.text);
      print("onDataChannelMessage: $text");
      refreshUI();
    };

    _eventBus.on<DownloaderEvent>().listen((event) {
      String taskId = "";
      linkDownloadData.forEach((key, value) {
        if (value.id == event.id) {
          taskId = key;
          return;
        }
      });
      linkDownloadData[taskId] = event;
      print("Download event: ${event.id}, ${event.status}, ${event.progress}");
      refreshUI();
    });

    _presenter.getListUserFromDbOnNext =
        (List<User> users, PersistenceType type) {
      print("chat: on Next get List User ${users.map((e) => e.name)}");
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
      print("chat: completed get List User $type");
    };
    _presenter.getListUserFromDbOnError = (e, PersistenceType type) {
      print("chat: on Error get List User $e $type");
    };

    _presenter.getEventsOnNext = (List<Calendar> calendars) {
      print("profile: success getEvents");
      if (calendars.isNotEmpty && calendars.length == 1) {
        Navigator.pop(context);
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

    // get links
    List<String?> links = DataUtil.getLinks(msg);
    if (links.isEmpty) {
      links = DataUtil.getRawLinks(msg);
    }
    links.forEach((l) {
      if (!l.isNullOrEmpty()) {
        var linkData = l!.split("|").map((e) => e.trim());
        _files.add(
          FileDomain.File(
            chatMsg.id,
            idInt: 1,
            createdAt: chatMsg.createdAt,
            title: linkData.first,
            url: linkData.last,
            fileType: FileDomain.FileType.link,
          ),
        );
      }
    });
  }

  void goToDetail(PhObject object) {
    Navigator.pushNamed(context, Pages.detail, arguments: DetailArgs(object));
  }

  void goToProfile(User user) {
    Navigator.pushNamed(context, Pages.profile,
        arguments: ProfileArgs(user: user));
  }

  void goToMediaDetail(MediaType type, String url, String title) {
    print("goToMediaDetail Url: $url");
    Navigator.pushNamed(context, Pages.mediaDetail,
        arguments: MediaArgs(
          type: type,
          url: url,
          title: title,
        ));
  }

  Future<void> callDispose() async {
    await _signaling.close();
  }

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
    _refreshEvent?.cancel();
    _uploadEvent?.cancel();
    _signaling.close();
  }

  void clearSearch() {
    _searchController.text = "";
    onSearch(false);
  }

  void onSearch(bool isSearching) {
    _isSearch = isSearching;

    if (_isSearch) {
      _focusNodeSearch.requestFocus();
    } else {
      _chats = _fChats;
      _searchedIndexList.clear();
      _focusedIndex = -1;
    }
    refreshUI();
  }

  void onDeleteMultipleChat() {
    _isDeleteMultiple = _isDeleteMultiple == false ? true : false;
    // if (_selectedChatId.contains(chat)) {
    //   _selectedChatId.remove(chat);
    // } else {
    //   _selectedChatId.add(chat);
    // }
    refreshUI();
  }

  void onCancelSelectedChat() {
    _isDeleteMultiple = false;
    _selectedChatId.clear();
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
    refreshUI();
  }

  updateMessageFieldSize() {
    BuildContext? context = messageKey.currentContext;
    if (context != null) {
      RenderBox box = context.findRenderObject() as RenderBox;
      messageFieldSize = box.size.height;
    } else {
      messageFieldSize = MediaQuery.of(this.context).size.height / 10;
    }
    refreshUI();
  }

  setActiveReply(Chat chat) {
    _senderRepliedMessage = "${chat.sender?.fullName}";
    _selectedChatId = [chat];
    setIsActiveReply();
    List<String> chats = _selectedChatId.first.message.split("\n");

    final List<String> messages = _selectedChatId.first.message.split("\n");

    if (messages.first.contains(RegExp(">|> "))) {
      _repliedMessage = messages.last;
    } else if (chats.length > 1) {
      _repliedMessage = chats.last;
    } else {
      _repliedMessage = _selectedChatId.first.message;
    }
    refreshUI();
  }

  setIsActiveReply() {
    _repliedMessage = "";
    _isActiveReply = _isActiveReply == false ? true : false;
    refreshUI();
  }

  String? getRepliedMessage(Chat chat) {
    if (chat.quotedChat != null) {
      if (chat.quotedChat!.message.isNotEmpty) {
        return chat.quotedChat!.message;
      }
    }

    String? result;
    if (chat.message.contains('>') && !chat.message.contains('<a')) {
      result = chat.message.split('>').last;
      result = result.split('\n').first;
    }

    return result;
  }
}
