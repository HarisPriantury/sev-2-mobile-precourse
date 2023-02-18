import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/events/notification.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/events/setting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/user_list/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/list/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/shop/checkout/args.dart';
import 'package:mobile_sev2/data/infrastructures/data_util.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/db/chat/get_messages_db_request.dart';
import 'package:mobile_sev2/data/payload/db/chat/send_message_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/create_room_db_request.dart';
import 'package:mobile_sev2/data/payload/db/room/get_rooms_db_request.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/meta/unread_chat.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:stream_transform/stream_transform.dart';

// There are much happening here, not only fetch room list
// 1. Fetch room list
// 2. Fetch last message in each rooms
// 3. Fetch senders of last message of each rooms
// 4. Check if the last messages is an attachment or not
class RoomsController extends BaseController {
  RoomsArgs? _data;

  final ScrollController _listScrollController = ScrollController();

  // properties
  RoomsPresenter _presenter;
  UserData _userData;
  DateUtilInterface _dateUtil;
  EventBus _eventBus;
  Box<UnreadChat> _ucBox;

  // WebSocketDashboardClient _socket;
  List<Room> _rooms = [];
  List<Room> _fRooms = [];
  List<Room> _searchedRooms = [];
  List<int> _fileIds = [];
  List<UnreadChat> _unreadChats = [];
  bool _isSearch = false;
  final FocusNode _focusNodeSearch = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _streamController = StreamController();

  // for pagination
  int _limit = 10;
  int _offset = 0;

  int _loadedRoom = 0;
  int _loadedMessage = 0;
  int _roomInitialLength = -1;

  // getter
  List<Room> get searchedRooms => _searchedRooms;

  UserData get userData => _userData;

  bool get isSearch => _isSearch;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  ScrollController get listScrollController => _listScrollController;

  TextEditingController get searchController => _searchController;

  StreamController<String> get streamController => _streamController;

  int get limit => _limit;

  int get offset => _offset;

  RoomsController(
    this._presenter,
    this._userData,
    this._dateUtil,
    this._eventBus,
    this._ucBox,
    // this._socket,
  ) {
    _userData.loadData();
  }

  void joinRoom(Room room) {
    Navigator.pushNamed(
      context,
      Pages.chat,
      arguments:
          ChatArgs(_rooms.firstWhere((element) => element.id == room.id)),
    ).then((value) {
      _loadedMessage--;
      _presenter.onGetMessages(GetMessagesDBRequest(room.id));
      _presenter
          .onGetMessages(GetMessagesApiRequest(roomId: room.id, limit: 6));
    });
    // _presenter.onJoinLobbyChannel(JoinLobbyChannelApiRequest(room.id), room);
  }

  void gotoUserList() {
    Navigator.pushNamed(context, Pages.createRoomUserList,
            arguments: UserListArgs(_rooms))
        .then((value) {
      if (value != null) {
        loading(true);
        _loadedRoom = 0;
        _loadedMessage = 0;
        _getRooms();
      }
    });
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

  void clearSearch() {
    _searchController.text = "";
    refreshUI();
  }

  List<Room> getRooms() {
    return _rooms;
  }

  void onSearch(bool value) {
    _isSearch = value;

    if (_isSearch) {
      _focusNodeSearch.requestFocus();
    } else {
      _focusNodeSearch.unfocus();
      _searchController.clear();
      _searchedRooms.clear();
    }
    refreshUI();
  }

  @override
  void load() {
    _unreadChats = _ucBox.values.toList();

    // first, on load, get all rooms
    loading(true);
    _presenter.onGetRooms(GetRoomsDBRequest(_userData.workspace));
    _getRooms();
    // _listScrollController.addListener(_scrollListener);
  }

  void _getRooms() {
    // _presenter.onGetRooms(GetRoomsApiRequest(limit: _limit, offset: _offset));
    _presenter.onGetRooms(GetRoomsApiRequest());
  }

  void _getParticipants(String roomId) {
    _presenter.onGetRoomParticipants(GetParticipantsApiRequest(roomId));
  }

  @override
  void getArgs() {
    if (args != null) _data = args as RoomsArgs;
    print(_data?.toPrint());
  }

  @override
  void initListeners() {
    // _socket.streamController?.stream.listen((message) {
    //   print("dashboardwebsocket onMessage: $message");
    //   var msg = jsonDecode(message);
    //
    //   switch (msg['type']) {
    //     case MESSAGE_TYPE:
    //       if (_rooms.indexWhere((element) => element.id == msg["threadPHID"]) > -1) {
    //         _loadedMessage--;
    //         _presenter.onGetMessages(GetMessagesApiRequest(roomId: msg["threadPHID"], limit: 6));
    //       }
    //       break;
    //     default:
    //       break;
    //   }
    // });

    _eventBus.on<NotificationEvent>().listen((event) {
      if (event.type == NotificationType.chat) {
        if (_rooms.indexWhere((element) => element.id == event.objectId) > -1) {
          _loadedMessage--;
          _presenter.onGetMessages(
              GetMessagesApiRequest(roomId: event.objectId, limit: 6));
        }
      }
    });

    _eventBus.on<RefreshUserList>().listen((event) {
      refreshUI();
    });

    // get rooms
    _presenter.getRoomsOnNext = (List<Room> rooms, PersistenceType type) {
      if (type == PersistenceType.api) {
        print("room list: success getRooms $type");
        _fileIds.clear();
        if (_fRooms.isEmpty)
          _fRooms.addAll(rooms);
        else if (_roomInitialLength != rooms.length) {
          _fRooms.clear();
          _fRooms.addAll(rooms);
        }
        // get last messages
        if (_fRooms.isNotEmpty) {
          _roomInitialLength = rooms.length;
          rooms.forEach(
            (e) {
              if (e.participantCount != null) {
                if (!(e.participantCount! > 2))
                  _getParticipants(e.id);
                else
                  _loadedRoom++;
              } else
                _loadedRoom++;
            },
          );
        } else {
          // _setUnreadChats();
          loading(false);
          reloading(false);
        }
      } else {
        print("room list: success getRooms $type ${rooms.length}");
        _rooms.clear();
        _rooms = rooms
            .where((element) =>
                element.participants?.length == 2 &&
                element.lastMessageCreatedAt != null)
            .toList();
        _rooms.sort((a, b) {
          return (b.lastMessageCreatedAt ?? DateTime.now())
              .compareTo(a.lastMessageCreatedAt ?? DateTime.now());
        });
        if (_rooms.isNotEmpty) {
          loading(false);
        }
      }
    };

    _presenter.getRoomsOnComplete = (PersistenceType type) {
      print("room list: completed getRooms $type");
      loading(false);
    };

    _presenter.getRoomsOnError = (e, PersistenceType type) {
      print("room list: error getRooms $e $type");
      loading(false);
    };

    // get participants
    _presenter.getParticipantsOnNext = (List<User>? users, String roomId) {
      print("room list: success getParticipants");
      // if (users != null) {
      //   if (users.length == 2 &&
      //       users.indexWhere((element) => element.id == _userData.id) != -1) {
      //     var idx = _fRooms.indexWhere((element) => element.id == roomId);
      //     _fRooms[idx].participants = users;
      //   }
      // }
      var idx = _fRooms.indexWhere((element) => element.id == roomId);
      _fRooms[idx].participants = users;
      _loadedRoom++;
      if (_loadedRoom == _roomInitialLength) {
        // _rooms.sort((a, b) => b.lastMessageCreatedAt!.compareTo(a.lastMessageCreatedAt!));
        _fRooms = _fRooms
            .where((element) => element.participants?.length == 2)
            .toList();
        if (_fRooms.isNotEmpty) {
          _fRooms.forEach((element) {
            _presenter.onGetMessages(GetMessagesDBRequest(element.id));
            _presenter.onGetMessages(
                GetMessagesApiRequest(roomId: element.id, limit: 6));
          });
        } else {
          loading(false);
          reloading(false);
        }
      }
    };

    _presenter.getParticipantsOnComplete = () {
      print("room list: completed getParticipants");
      loading(false);
    };

    _presenter.getParticipantsOnError = (e, roomId) {
      print("room list: error getParticipants $e $roomId");
      loading(false);
    };

    // get messages
    _presenter.getMessagesOnNext =
        (List<Chat>? messages, PersistenceType type) {
      if (messages != null) {
        print("room list: success getMessages $type");
        if (type == PersistenceType.db) {
          if (messages.isNotEmpty) {
            var idx = _fRooms.indexWhere((e) => e.id == messages.first.roomId);
            _fRooms[idx].chats = messages;
            refreshUI();
          }
        } else {
          var idx = _fRooms.indexWhere((e) => e.id == messages.first.roomId);
          if (_fRooms[idx].chats != null) {
            var chatIdx = messages
                .indexWhere((chat) => chat.id == _fRooms[idx].chats?.first.id);
            _fRooms[idx].unreadChats = chatIdx < 0 ? 6 : chatIdx;
          } else {
            _presenter.onSendDBMessage(SendMessageDBRequest(messages.first));
          }
          _fRooms[idx].lastMessageCreatedAt = messages.first.createdAt;
          if (messages.first.sender?.id != _userData.id)
            _fRooms[idx].lastMessageSender = getOtherMember(_fRooms[idx]);
          else {
            var me = _userData.toUser();
            me.name = _userData.username;
            _fRooms[idx].lastMessageSender = me;
          }
          var lastMessage = messages.first.message;
          var sender = _fRooms[idx].lastMessageSender;

          // check if it contains {Fxx}, replace it with `uploaded a file`
          var cFiles = DataUtil.getFiles(lastMessage);
          if (cFiles.isNotEmpty) {
            var fileId = cFiles.last!.replaceAll(RegExp(r"{F|}"), "");
            lastMessage = "${sender?.name}: {{$fileId}}";
            _fileIds.add(int.parse(fileId));
          } else {
            if (DataUtil.isHTML(lastMessage)) {
              lastMessage = DataUtil.removeAllHtmlTags(lastMessage);
            } else {
              // check if there is a link
              var cLinks = DataUtil.getLinks(lastMessage);
              if (cLinks.isNotEmpty) {
                _fRooms[idx].lastMessageType = FileType.link;
                lastMessage = "";
              }

              lastMessage = "${sender?.name}: $lastMessage";
            }
          }

          _fRooms[idx].lastMessage = lastMessage;
          refreshUI();
        }
      }
    };

    _presenter.getMessagesOnComplete = (PersistenceType type) {
      print("room list: completed getMessages");
      if (type == PersistenceType.api) {
        _loadedMessage++;
        if (_fileIds.isEmpty) {
          // loading(false);
        } else {
          _presenter.onGetFiles(GetFilesApiRequest(ids: _fileIds));
        }
        if (_loadedMessage == _fRooms.length) {
          _rooms.clear();
          _rooms.addAll(_fRooms);
          _rooms.sort((a, b) {
            if (b.lastMessageCreatedAt != null &&
                a.lastMessageCreatedAt != null) {
              return b.lastMessageCreatedAt!.compareTo(a.lastMessageCreatedAt!);
            }
            return 0;
          });
          _checkHasUnreadChats();
          loading(false);
          reloading(false);
          // save to db
          _rooms.forEach((r) {
            _presenter.onCreateRoom(CreateRoomDBRequest(r));
          });
        }

        // _setUnreadChats();
      }
      loading(false);
    };

    _presenter.getMessagesOnError = (e, PersistenceType type) {
      print("room list: error getMessages $e $type");
      loading(false);
    };

    // send message
    _presenter.sendMessageOnNext = (bool result, PersistenceType type) {
      print("room list: success sendMessage $type");
    };

    _presenter.sendMessageOnComplete = (PersistenceType type) {
      print("room list: completed sendMessage $type");
      loading(false);
    };

    _presenter.sendMessageOnError = (e, PersistenceType type) {
      print("room list: error sendMessage $e $type");
      loading(false);
    };

    _presenter.getFilesOnNext = (List<File> files, PersistenceType type) {
      print("room list: success getFiles $type");

      files.forEach((f) {
        var idx = _rooms.indexWhere((r) =>
            r.lastMessage != null &&
            r.lastMessage!.contains("{{" + f.idInt.toString() + "}}"));
        if (idx >= 0) {
          _rooms[idx].lastMessageType = f.fileType;
          _rooms[idx].lastMessage = _rooms[idx]
              .lastMessage!
              .replaceAll("{{" + f.idInt.toString() + "}}", "");
        }
      });
    };

    _presenter.getFilesOnComplete = (PersistenceType type) {
      print("room list: completed getFiles $type");
      loading(false);
    };

    _presenter.getFilesOnError = (e, PersistenceType type) {
      print("room list: error getFiles $e $type");
      loading(false);
    };

    _presenter.createRoomOnNext = (BaseApiResponse resp, PersistenceType type) {
      print("room list: success createRoom $type");
      loading(false);
    };

    _presenter.createRoomOnComplete = (PersistenceType type) {
      print("room list: completed createRoom $type");
      loading(false);
    };

    _presenter.createRoomOnError = (e, PersistenceType type) {
      print("room list: error createRoom $e $type");
      loading(false);
    };

    _presenter.joinLobbyChannelOnNext = (bool result, PersistenceType type) {
      print("room list: success joinLobbyChannel $type");
      // refreshUI();
      loading(false);
    };

    _presenter.joinLobbyChannelOnComplete = (PersistenceType type, Room room) {
      Navigator.pushNamed(
        context,
        Pages.chat,
        arguments:
            ChatArgs(_rooms.firstWhere((element) => element.id == room.id)),
      ).then((value) {
        _loadedMessage--;
        _presenter.onGetMessages(GetMessagesDBRequest(room.id));
        _presenter
            .onGetMessages(GetMessagesApiRequest(roomId: room.id, limit: 6));
      });
      loading(false);
    };

    _presenter.joinLobbyChannelOnError = (e, PersistenceType type) {
      print("room list: error joinLobbyChannel $e $type");
      loading(false);
    };

    _eventBus.on<RefreshList>().listen((_) {
      loading(true);

      // refresh room
      reload();
    });

    _eventBus.on<RefreshUnreadChat>().listen((_) {
      _unreadChats.clear();
      _unreadChats = _ucBox.values.toList();
      delay(() {
        refreshUI();
      });
    });

    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _searchedRooms = _rooms
          .where((u) => u.name!.toLowerCase().contains(s.toLowerCase()))
          .toList();
      refreshUI();
    });
  }

  User getOtherMember(Room room) {
    return room.participants!
        .firstWhere((element) => element.id != _userData.id);
  }

  Color getOtherMemberStatusColor(Room room) {
    User user = getOtherMember(room);
    Color otherMemberColor = ColorsItem.grey606060;
    AppComponent.getInjector()
        .get<List<User>>(dependencyName: "user_list")
        .forEach((lobbyUser) {
      if (lobbyUser.id == user.id && lobbyUser.getStatusColor() != null) {
        otherMemberColor = lobbyUser.getStatusColor()!;
        return;
      }
    });
    return otherMemberColor;
  }

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    reloading(true);
    _loadedRoom = 0;
    _loadedMessage = 0;
    _getRooms();
    await Future.delayed(Duration(seconds: 1));
  }

  void _checkHasUnreadChats() {
    for (var chat in _rooms) {
      if (chat.unreadChats > 0) {
        _eventBus.fire(HasUnreadChat());
        return;
      }
      _eventBus.fire(ChatRead());
    }
  }

  // MARK: DELETE THIS WHEN MODULE POS WAS READY TO DEVELOP
  void gotoShop() {
    Navigator.pushNamed(context, Pages.shop,
        arguments: ShopArgs("Lion Parcel"));
  }

  // MARK: DELETE THIS WHEN MODULE POS WAS READY TO DEVELOP

  void goToFormAddProductLionParcel() {
    Navigator.pushNamed(context, Pages.formAddProduct);
  }
}
