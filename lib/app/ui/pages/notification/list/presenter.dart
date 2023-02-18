import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/feed/get_feeds_api_request.dart';
import 'package:mobile_sev2/data/payload/api/mention/get_mentions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/notification/get_embraces_api_request.dart';
import 'package:mobile_sev2/data/payload/api/notification/get_notifications_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/mention_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/notification/create_notification_db_request.dart';
import 'package:mobile_sev2/data/payload/db/notification/mark_notifications_read_db_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/embrace.dart';
import 'package:mobile_sev2/domain/feed.dart';
import 'package:mobile_sev2/domain/mention.dart';
import 'package:mobile_sev2/domain/notification.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/calendar/get_events.dart';
import 'package:mobile_sev2/use_cases/feed/get_feeds.dart';
import 'package:mobile_sev2/use_cases/mention/get_mentions.dart';
import 'package:mobile_sev2/use_cases/notification/create_notifications.dart';
import 'package:mobile_sev2/use_cases/notification/get_embraces.dart';
import 'package:mobile_sev2/use_cases/notification/get_notifications.dart';
import 'package:mobile_sev2/use_cases/notification/mark_all_read.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_rooms.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';

class NotificationsPresenter extends Presenter {
  GetNotificationsUseCase _notificationUsecase;
  GetNotificationsUseCase _notificationDbUsecase;
  MarkNotificationsReadUseCase _markUseCase;
  MarkNotificationsReadUseCase _markDbUseCase;
  CreateNotificationUseCase _createNotificationDbUseCase;
  GetFeedsUseCase _getFeedsUseCase;
  GetMentionsUseCase _getMentionsUseCase;

  GetEmbracesUseCase _embracesUseCase;

  GetTicketsUseCase _ticketsUseCase;
  GetRoomsUseCase _getRoomsUseCase;
  GetRoomParticipantsUseCase _participantsUseCase;
  GetProjectsUseCase _projectsUseCase;
  GetEventsUseCase _eventsUseCase;

  // for get notifications
  late Function getNotificationsOnNext;
  late Function getNotificationsOnComplete;
  late Function getNotificationsOnError;

  // create notif
  late Function createNotificationOnNext;
  late Function createNotificationOnComplete;
  late Function createNotificationOnError;

  // mark notifications as read
  late Function markNotificationsReadOnNext;
  late Function markNotificationsReadOnComplete;
  late Function markNotificationsReadOnError;

  // get notif stream as read
  late Function getNotifStreamsOnNext;
  late Function getNotifStreamsOnComplete;
  late Function getNotifStreamsOnError;

  // get notif stream as read
  late Function getMentionsOnNext;
  late Function getMentionsOnComplete;
  late Function getMentionsOnError;

  // embraces
  late Function getEmbracesOnNext;
  late Function getEmbracesOnComplete;
  late Function getEmbracesOnError;

  // get tickets
  late Function getTicketsOnNext;
  late Function getTicketsOnComplete;
  late Function getTicketsOnError;

  // get rooms
  late Function getRoomsOnNext;
  late Function getRoomsOnComplete;
  late Function getRoomsOnError;

  // get room participants
  late Function getParticipantsOnNext;
  late Function getParticipantsOnComplete;
  late Function getParticipantsOnError;

  // get projects
  late Function getProjectsOnNext;
  late Function getProjectsOnComplete;
  late Function getProjectsOnError;

  // for get calendar events
  late Function getEventsOnNext;
  late Function getEventsOnComplete;
  late Function getEventsOnError;

  NotificationsPresenter(
    this._notificationUsecase,
    this._notificationDbUsecase,
    this._markUseCase,
    this._markDbUseCase,
    this._createNotificationDbUseCase,
    this._embracesUseCase,
    this._getFeedsUseCase,
    this._ticketsUseCase,
    this._getRoomsUseCase,
    this._participantsUseCase,
    this._projectsUseCase,
    this._getMentionsUseCase,
    this._eventsUseCase,
  );

  void onGetNotifications(GetNotificationsRequestInterface req) {
    if (req is GetNotificationApiRequest) {
      _notificationUsecase.execute(
          _GetNotificationsObserver(this, PersistenceType.api), req);
    } else {
      _notificationDbUsecase.execute(
          _GetNotificationsObserver(this, PersistenceType.db), req);
    }
  }

  void onGetStreams(GetFeedsRequestInterface req) {
    if (req is GetFeedsApiRequest) {
      _getFeedsUseCase.execute(_GetStreamsObserver(this), req);
    }
  }

  void onGetEmbraces(GetEmbracesRequestInterface req) {
    if (req is GetEmbracesApiRequest) {
      _embracesUseCase.execute(_GetEmbracesObserver(this), req);
    }
  }

  void onCreateNotification(CreateNotificationRequestInterface req) {
    if (req is CreateNotificationDBRequest) {
      _createNotificationDbUseCase.execute(
          _CreateNotificationObserver(this, PersistenceType.db), req);
    }
  }

  void onMarkAllAsRead(MarkNotificationsReadRequestInterface req) {
    if (req is MarkNotificationsReadDBRequest) {
      _markUseCase.execute(
          _MarkNotificationsReadObserver(this, PersistenceType.api), req);
    } else {
      _markDbUseCase.execute(
          _MarkNotificationsReadObserver(this, PersistenceType.db), req);
    }
  }

  void onGetTickets(GetTicketsRequestInterface req) {
    if (req is GetTicketsApiRequest) {
      _ticketsUseCase.execute(
          _GetTicketsObserver(this, PersistenceType.api), req);
    }
  }

  void onGetRooms(GetRoomsRequestInterface req) {
    if (req is GetRoomsApiRequest) {
      _getRoomsUseCase.execute(
        _GetRoomsObserver(this, PersistenceType.api),
        req,
      );
    }
  }

  void onGetRoomParticipants(GetParticipantsRequestInterface req, Room room) {
    if (req is GetParticipantsApiRequest) {
      _participantsUseCase.execute(_GetParticipantsObserver(this, room), req);
    }
  }

  void onGetProjects(GetProjectsRequestInterface req) {
    _projectsUseCase.execute(_GetProjectsObserver(this), req);
  }

  void onGetMentions(GetMentionsRequestInterface req) {
    if (req is GetMentionsApiRequest) {
      _getMentionsUseCase.execute(_GetMentionsObserver(this), req);
    }
  }

  void onGetCalendars(GetEventsRequestInterface req) {
    if (req is GetEventsApiRequest) {
      _eventsUseCase.execute(_GetEventsObserver(this), req);
    }
  }

  void dispose() {
    _notificationUsecase.dispose();
    _notificationDbUsecase.dispose();
    _markUseCase.dispose();
    _markDbUseCase.dispose();
    _createNotificationDbUseCase.dispose();
    _embracesUseCase.dispose();
    _getFeedsUseCase.dispose();
    _ticketsUseCase.dispose();
    _getRoomsUseCase.dispose();
    _participantsUseCase.dispose();
    _projectsUseCase.dispose();
    _getMentionsUseCase.dispose();
    _eventsUseCase.dispose();
  }
}

class _GetNotificationsObserver implements Observer<List<Notification>> {
  NotificationsPresenter _presenter;
  PersistenceType _type;

  _GetNotificationsObserver(this._presenter, this._type);

  void onNext(List<Notification>? notifications) {
    _presenter.getNotificationsOnNext(notifications, _type);
  }

  void onComplete() {
    _presenter.getNotificationsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getNotificationsOnError(e, _type);
  }
}

class _GetStreamsObserver implements Observer<List<Feed>> {
  NotificationsPresenter _presenter;

  _GetStreamsObserver(this._presenter);

  void onNext(List<Feed>? streams) {
    _presenter.getNotifStreamsOnNext(streams);
  }

  void onComplete() {
    _presenter.getNotifStreamsOnComplete();
  }

  void onError(e) {
    _presenter.getNotifStreamsOnError(e);
  }
}

class _GetEmbracesObserver implements Observer<List<Embrace>> {
  NotificationsPresenter _presenter;

  _GetEmbracesObserver(this._presenter);

  void onNext(List<Embrace>? embraces) {
    _presenter.getEmbracesOnNext(embraces);
  }

  void onComplete() {
    _presenter.getEmbracesOnComplete();
  }

  void onError(e) {
    _presenter.getEmbracesOnError(e);
  }
}

class _MarkNotificationsReadObserver implements Observer<bool> {
  NotificationsPresenter _presenter;
  PersistenceType _type;

  _MarkNotificationsReadObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.markNotificationsReadOnNext(result, _type);
  }

  void onComplete() {
    _presenter.markNotificationsReadOnComplete(_type);
  }

  void onError(e) {
    _presenter.markNotificationsReadOnError(e, _type);
  }
}

class _CreateNotificationObserver implements Observer<bool> {
  NotificationsPresenter _presenter;
  PersistenceType _type;

  _CreateNotificationObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.createNotificationOnNext(result, _type);
  }

  void onComplete() {
    _presenter.createNotificationOnComplete(_type);
  }

  void onError(e) {
    _presenter.createNotificationOnError(e, _type);
  }
}

class _GetTicketsObserver implements Observer<List<Ticket>> {
  NotificationsPresenter _presenter;
  PersistenceType _type;

  _GetTicketsObserver(this._presenter, this._type);

  void onNext(List<Ticket>? tickets) {
    _presenter.getTicketsOnNext(tickets, _type);
  }

  void onComplete() {
    _presenter.getTicketsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getTicketsOnError(e, _type);
  }
}

class _GetRoomsObserver implements Observer<List<Room>> {
  NotificationsPresenter _presenter;
  PersistenceType _type;

  _GetRoomsObserver(
    this._presenter,
    this._type,
  );

  void onNext(List<Room>? rooms) {
    _presenter.getRoomsOnNext(rooms, _type);
  }

  void onComplete() {
    _presenter.getRoomsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getRoomsOnError(e, _type);
  }
}

class _GetParticipantsObserver implements Observer<List<User>> {
  NotificationsPresenter _presenter;
  Room _room;

  _GetParticipantsObserver(this._presenter, this._room);

  void onNext(List<User>? users) {
    _presenter.getParticipantsOnNext(users, _room);
  }

  void onComplete() {
    _presenter.getParticipantsOnComplete();
  }

  void onError(e) {
    _presenter.getParticipantsOnError(e);
  }
}

class _GetProjectsObserver implements Observer<List<Project>> {
  NotificationsPresenter _presenter;

  _GetProjectsObserver(this._presenter);

  void onNext(List<Project>? projects) {
    _presenter.getProjectsOnNext(projects);
  }

  void onComplete() {
    _presenter.getProjectsOnComplete();
  }

  void onError(e) {
    _presenter.getProjectsOnError(e);
  }
}

class _GetMentionsObserver implements Observer<List<Mention>> {
  NotificationsPresenter _presenter;

  _GetMentionsObserver(this._presenter);

  void onNext(List<Mention>? mentions) {
    _presenter.getMentionsOnNext(mentions);
  }

  void onComplete() {
    _presenter.getMentionsOnComplete();
  }

  void onError(e) {
    _presenter.getMentionsOnError(e);
  }
}

class _GetEventsObserver implements Observer<List<Calendar>> {
  NotificationsPresenter _presenter;

  _GetEventsObserver(this._presenter);

  void onNext(List<Calendar>? calendars) {
    _presenter.getEventsOnNext(calendars);
  }

  void onComplete() {
    _presenter.getEventsOnComplete();
  }

  void onError(e) {
    _presenter.getEventsOnError(e);
  }
}