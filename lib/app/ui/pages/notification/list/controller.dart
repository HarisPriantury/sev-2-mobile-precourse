import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/args.dart';
import 'package:mobile_sev2/app/ui/pages/notification/list/args.dart';
import 'package:mobile_sev2/app/ui/pages/notification/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/args.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/feed/get_feeds_api_request.dart';
import 'package:mobile_sev2/data/payload/api/mention/get_mentions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/notification/get_embraces_api_request.dart';
import 'package:mobile_sev2/data/payload/api/notification/get_notifications_api_request.dart';
import 'package:mobile_sev2/data/payload/api/notification/mark_notifications_read_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_projects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/embrace.dart';
import 'package:mobile_sev2/domain/feed.dart';
import 'package:mobile_sev2/domain/mention.dart';
import 'package:mobile_sev2/domain/notification.dart' as NotificationDomain;
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:collection/collection.dart';

import '../../pages.dart';

class NotificationsController extends SheetController {
  NotificationArgs? _data;

  // properties
  NotificationsPresenter _presenter;
  UserData _userData;
  DateUtilInterface _dateUtil;
  List<NotificationDomain.Notification> _notifications = [];
  List<Feed> _streams = [];
  List<Mention> _mentions = [];
  List<Embrace> _embraces = [];
  List<User> _userList;

  // used for pagination
  // _after will have the latest value of chrono key from API, and _limit won't be changed
  int _limit = 10;
  String _afterNotifications = "0";
  String _afterStreams = "0";
  int _afterMentions = 0;
  bool _isNotificationPaginating = false;
  bool _isStreamPaginating = false;
  bool _isEmbracePaginating = false;

  // getter
  List<NotificationDomain.Notification> get notifications => _notifications;

  DateUtilInterface get dateUtil => _dateUtil;

  List<Feed> get streams => _streams;

  List<Mention> get mentions => _mentions;

  UserData get userData => _userData;

  bool get isEmbracePaginating => _isEmbracePaginating;

  bool get isStreamPaginating => _isStreamPaginating;

  bool get isNotificationPaginating => _isNotificationPaginating;

  NotificationsController(
    this._presenter,
    this._userData,
    this._dateUtil,
    this._userList,
  );

  @override
  void load() {
    this.setScrollListener(
      _getNotifications,
      secondFunc: _getStreams,
      thirdFunc: _getMentions,
    );
    _getNotifications();
    _getStreams();
    _getMentions();
    _presenter.onGetEmbraces(GetEmbracesApiRequest());
  }

  void _getNotifications() {
    // fetch notifications
    if (!_isNotificationPaginating) {
      _presenter.onGetNotifications(
          GetNotificationApiRequest(after: _afterNotifications, limit: _limit));
      _isNotificationPaginating = true;
      refreshUI();
    }
  }

  void _getStreams() {
    if (!_isStreamPaginating) {
      _presenter.onGetStreams(GetFeedsApiRequest(after: _afterStreams));
      _isStreamPaginating = true;
      refreshUI();
    }
  }

  void _getMentions() {
    if (!_isEmbracePaginating) {
      _presenter.onGetMentions(
        GetMentionsApiRequest(
          limit: _limit,
          after: _afterMentions,
        ),
      );
      _isStreamPaginating = true;
      refreshUI();
    }
  }

  @override
  void getArgs() {
    if (args != null) _data = args as NotificationArgs;
    print(_data?.toPrint());
  }

  void markAllAsRead() {
    loading(true);
    _presenter.onMarkAllAsRead(MarkNotificationsReadApiRequest());
    refreshUI();
  }

  // format notification time
  String formatNotificationTime(DateTime dt) {
    return _dateUtil.displayDateTimeFormat(dt);
  }

  void initListeners() {
    _presenter.getNotificationsOnNext =
        (List<NotificationDomain.Notification> notifications,
            PersistenceType type) {
      print(
          "notification: success getNotifications $type ${_afterNotifications.isEmpty} ${_notifications.isNotEmpty}");
      if (_afterNotifications == "0" && _notifications.isNotEmpty) {
        _notifications.clear();
      }
      _notifications.addAll(notifications);
      if (_notifications.isNotEmpty) {
        // set _after with latest crono key
        _afterNotifications = _notifications.last.chronoKey;
        _isNotificationPaginating = false;
      }
      // // save to db
      // if (type == PersistenceType.api) {
      //   notifications.forEach((notif) {
      //     _presenter.onCreateNotification(CreateNotificationDBRequest(notif));
      //   });
      // }
    };

    _presenter.getNotificationsOnComplete = (PersistenceType type) {
      print("notification: completed getNotifications $type");
      loading(false);
      reloading(false);
    };

    _presenter.getNotificationsOnError = (e, PersistenceType type) {
      print("notification: error getNotifications $e $type");
      _isNotificationPaginating = false;
      loading(false);
      reloading(false);
    };

    _presenter.markNotificationsReadOnNext =
        (bool result, PersistenceType type) {};

    _presenter.markNotificationsReadOnComplete = (PersistenceType type) {
      print("notification: completed markNotificationsRead $type");

      // clear and reload
      _notifications.clear();
      load();
    };

    _presenter.markNotificationsReadOnError = (e, PersistenceType type) {
      print("notification markNotification $e $type");
    };

    _presenter.createNotificationOnNext = (bool result, PersistenceType type) {
      print("notification: success createNotification $type");
    };

    _presenter.createNotificationOnComplete = (PersistenceType type) {
      print("notification: completed createNotification $type");
    };

    _presenter.createNotificationOnError = (e, PersistenceType type) {
      print("notification createNotification $e $type");
    };

    _presenter.getNotifStreamsOnNext = (List<Feed> streams) {
      print("notification: success getNotifStreams ${streams.length}");
      if (_afterStreams == "0" && _streams.isNotEmpty) {
        _streams.clear();
      }
      List<Feed> _feeds = [];
      _feeds.addAll(streams);
      for (int i = 0; i < _feeds.length; i++) {
        User? searchedUser = _getUserById(_feeds[i].user.id);
        if (searchedUser != null) {
          _feeds[i].user = searchedUser;
        }
      }
      _streams.addAll(_feeds);
      _afterStreams = _streams.last.chronoKey;
      _isStreamPaginating = false;
    };

    _presenter.getNotifStreamsOnComplete = () {
      print("notification: completed getNotifStreams");
      loading(false);
      reloading(false);
    };

    _presenter.getNotifStreamsOnError = (e) {
      print("notification getNotifStreams $e");
      loading(false);
      reloading(false);
    };

    _presenter.getEmbracesOnNext = (List<Embrace> embraces) {
      print("notification: success getEmbraces");
      _embraces.clear();
      _embraces.addAll(embraces);
    };

    _presenter.getEmbracesOnComplete = () {
      print("notification: completed getEmbraces");
    };

    _presenter.getEmbracesOnError = (e) {
      print("notification getEmbraces $e");
    };

    _presenter.getTicketsOnNext = (List<Ticket> tickets, PersistenceType type) {
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

    _presenter.getRoomsOnNext = (List<Room> rooms, PersistenceType type) {
      print("notification: success getRooms $type");
      if (rooms.isNotEmpty) {
        _getParticipants(rooms.first);
      }
    };

    _presenter.getRoomsOnComplete = (PersistenceType type) {
      print("notification: completed getRooms $type");
    };

    _presenter.getRoomsOnError = (e, PersistenceType type) {
      print("notification: error getRooms: $e $type");
      Navigator.pop(context);
      showNotif(context, "Something went wrong...");
    };

    _presenter.getParticipantsOnNext = (List<User>? users, Room room) {
      print("notification: success getParticipants");
      if (users != null) {
        room.participants = users;
        Navigator.pop(context);
        _navigateToChat(room);
      }
    };

    _presenter.getParticipantsOnComplete = () {
      print("notification: completed getParticipants");
    };

    _presenter.getParticipantsOnError = (e) {
      print("notification: error getParticipants $e");
      Navigator.pop(context);
      showNotif(context, "Something went wrong...");
    };

    _presenter.getProjectsOnNext = (List<Project> projects) {
      print("notification: success getProjects ${projects.length}");
      if (projects.isNotEmpty && projects.length == 1) {
        Navigator.pop(context);
        Navigator.pushNamed(
          context,
          Pages.projectDetail,
          arguments: DetailProjectArgs(phid: projects.first.id),
        );
      }
    };
    _presenter.getProjectsOnComplete = () {
      print("notification: completed getProjects");
      loading(false);
    };
    _presenter.getProjectsOnError = (e) {
      print("notification: error getProjects: $e");
      loading(false);
      showNotif(context, "Something went wrong...");
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
      }
    };

    _presenter.getEventsOnComplete = () {
      print("profile: completed getEvents");
      loading(false);
    };

    _presenter.getEventsOnError = (e) {
      print("profile: error getEvents $e");
      loading(false);
      showNotif(context, "Something went wrong...");
    };

    _presenter.getMentionsOnNext = (List<Mention> mentions) {
      print("notification: success getMentions ${mentions.length}");
      _isStreamPaginating = false;
      if (_afterMentions == 0) {
        _mentions.clear();
      }
      _mentions.addAll(mentions);
      if (mentions.isNotEmpty) _afterMentions = mentions.last.intId;
    };

    _presenter.getMentionsOnComplete = () {
      print("notification: completed getMentions");
      loading(false);
    };

    _presenter.getMentionsOnError = (e) {
      print("notification: error getMentions: $e");
      loading(false);
    };
  }

  void onTapStream(Feed feed) {
    print("onTap feed: ${feed.objectPHID}");
    showOnLoading(context, "Loading...");
    if (feed.objectPHID != null) {
      if (feed.objectPHID!.contains("PHID-TASK")) {
        _presenter.onGetTickets(
          GetTicketsApiRequest(
            queryKey: GetTicketsApiRequest.QUERY_ALL,
            phids: [feed.objectPHID!],
          ),
        );
      } else if (feed.objectPHID!.contains("PHID-USER")) {
        User? _user = _getUserById(feed.objectPHID!);
        Navigator.pop(context);
        if (_user != null) {
          Navigator.pushNamed(
            context,
            Pages.profile,
            arguments: ProfileArgs(user: _user),
          );
        }
      } else if (feed.objectPHID!.contains("PHID-PROJ")) {
        _presenter.onGetProjects(
          GetProjectsApiRequest(ids: [feed.objectPHID!]),
        );
      } else if (feed.objectPHID!.contains("PHID-CONP")) {
        _presenter.onGetRooms(
          GetRoomsApiRequest(ids: [feed.objectPHID!]),
        );
      } else if (feed.objectPHID!.contains("PHID-CEVT")) {
        _presenter.onGetCalendars(
          GetEventsApiRequest(
            phids: [feed.objectPHID!],
            limit: 1,
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  void onTapMention(Mention mention) {
    print("onTap mention: ${mention.object?.id}");
    showOnLoading(context, "Loading...");
    if (mention.object?.id != null) {
      if (mention.object!.id.contains("PHID-TASK")) {
        _presenter.onGetTickets(
          GetTicketsApiRequest(
            queryKey: GetTicketsApiRequest.QUERY_ALL,
            phids: [mention.object!.id],
          ),
        );
      } else if (mention.object!.id.contains("PHID-USER")) {
        User? _user = _getUserById(mention.object!.id);
        Navigator.pop(context);
        if (_user != null) {
          Navigator.pushNamed(
            context,
            Pages.profile,
            arguments: ProfileArgs(user: _user),
          );
        }
      } else if (mention.object!.id.contains("PHID-PROJ")) {
        _presenter.onGetProjects(
          GetProjectsApiRequest(ids: [mention.object!.id]),
        );
      } else if (mention.object!.id.contains("PHID-CONP")) {
        _presenter.onGetRooms(
          GetRoomsApiRequest(ids: [mention.object!.id]),
        );
      } else if (mention.object!.id.contains("PHID-CEVT")) {
        _presenter.onGetCalendars(
          GetEventsApiRequest(
            phids: [mention.object!.id],
            limit: 1,
          ),
        );
      } else {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  User? _getUserById(String id) {
    return _userList.firstWhereOrNull((element) => element.id == id);
  }

  void _getParticipants(Room room) {
    _presenter.onGetRoomParticipants(GetParticipantsApiRequest(room.id), room);
  }

  void _navigateToChat(Room room) {
    if (room.participants != null) {
      if (room.participants!.length > 2) {
        Navigator.pushNamed(
          context,
          Pages.roomChat,
          arguments: LobbyRoomArgs(
            room,
            type: RoomType.chat,
          ),
        );
      } else {
        Navigator.pushNamed(
          context,
          Pages.chat,
          arguments: ChatArgs(
            room,
          ),
        );
      }
    }
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    reloading(true);
    _afterNotifications = "0";
    _afterStreams = "0";
    _afterMentions = 0;
    _getNotifications();
    _getStreams();
    _getMentions();
    _presenter.onGetEmbraces(GetEmbracesApiRequest());
    await Future.delayed(Duration(seconds: 1));
  }
}
