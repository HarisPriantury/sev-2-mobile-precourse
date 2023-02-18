import 'package:hive_flutter/hive_flutter.dart';
import 'package:injector/injector.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/feed.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/job.dart';
import 'package:mobile_sev2/domain/meta/lobby_room_info.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';
import 'package:mobile_sev2/domain/meta/notif_stream.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/meta/push_notification.dart';
import 'package:mobile_sev2/domain/meta/room_participants.dart';
import 'package:mobile_sev2/domain/meta/search_history.dart';
import 'package:mobile_sev2/domain/meta/status_history.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/meta/unread_chat.dart';
import 'package:mobile_sev2/domain/notification.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/query.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class DBModule {
  static Future<void> init(Injector injector) async {

    // init Hive
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PushNotificationAdapter());
      Hive.registerAdapter(WorkspaceAdapter());
      Hive.registerAdapter(CalendarAdapter());
      Hive.registerAdapter(ChatAdapter());
      Hive.registerAdapter(QuotedChatAdapter());
      Hive.registerAdapter(FeedAdapter());
      Hive.registerAdapter(FileAdapter());
      Hive.registerAdapter(FileTypeAdapter());
      Hive.registerAdapter(JobAdapter());
      Hive.registerAdapter(JobApplicationAdapter());
      Hive.registerAdapter(JobStatusAdapter());
      Hive.registerAdapter(ApplyStatusAdapter());
      Hive.registerAdapter(NotificationAdapter());
      Hive.registerAdapter(PhTransactionAdapter());
      Hive.registerAdapter(ProjectAdapter());
      Hive.registerAdapter(ReactionAdapter());
      Hive.registerAdapter(RoomAdapter());
      Hive.registerAdapter(SettingAdapter());
      Hive.registerAdapter(StickitAdapter());
      Hive.registerAdapter(TicketAdapter());
      Hive.registerAdapter(TicketSubscriberInfoAdapter());
      Hive.registerAdapter(TicketStatusAdapter());
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(ProjectsInfoAdapter());
      Hive.registerAdapter(SubscriptionInfoAdapter());
      Hive.registerAdapter(StoryPointInfoAdapter());
      Hive.registerAdapter(HiringInfoAdapter());
      Hive.registerAdapter(WorkInfoAdapter());
      Hive.registerAdapter(UserTypeAdapter());
      Hive.registerAdapter(SubscriptionStatusAdapter());
      Hive.registerAdapter(LobbyRoomInfoAdapter());
      Hive.registerAdapter(LobbyStatusAdapter());
      Hive.registerAdapter(ObjectReactionsAdapter());
      Hive.registerAdapter(ReactionDataAdapter());
      Hive.registerAdapter(RoomParticipantsAdapter());
      Hive.registerAdapter(StatusHistoryAdapter());
      Hive.registerAdapter(SearchHistoryAdapter());
      Hive.registerAdapter(QueryAdapter());

      Hive.registerAdapter(PhoneAdapter());
      Hive.registerAdapter(EmailAdapter());

      Hive.registerAdapter(NotifStreamAdapter());
      Hive.registerAdapter(UnreadChatAdapter());
      Hive.registerAdapter(TopicAdapter());

      // (important) parent come last, issue: https://github.com/hivedb/hive/issues/179
      Hive.registerAdapter(PhObjectAdapter());

      // open all boxes
      await Hive.openBox<PushNotification>(PushNotification.getName());
      await Hive.openBox<Workspace>(Workspace.getName());
      await Hive.openBox<Calendar>(Calendar.getName());
      await Hive.openBox<Chat>(Chat.getName());
      await Hive.openBox<QuotedChat>(QuotedChat.getName());
      await Hive.openBox<Feed>(Feed.getName());
      await Hive.openBox<File>(File.getName());
      await Hive.openBox<Job>(Job.getName());
      await Hive.openBox<JobApplication>(JobApplication.getName());
      await Hive.openBox<Notification>(Notification.getName());
      await Hive.openBox<PhObject>(PhObject.getName());
      await Hive.openBox<PhTransaction>(PhTransaction.getName());
      await Hive.openBox<Project>(Project.getName());
      await Hive.openBox<Reaction>(Reaction.getName());
      await Hive.openBox<Room>(Room.getName());
      await Hive.openBox<Setting>(Setting.getName());
      await Hive.openBox<Stickit>(Stickit.getName());
      await Hive.openBox<Ticket>(Ticket.getName());
      await Hive.openBox<TicketSubscriberInfo>(TicketSubscriberInfo.getName());
      await Hive.openBox<User>(User.getName());
      await Hive.openBox<WorkInfo>(WorkInfo.getName());
      await Hive.openBox<HiringInfo>(HiringInfo.getName());
      await Hive.openBox<StoryPointInfo>(StoryPointInfo.getName());
      await Hive.openBox<SubscriptionInfo>(SubscriptionInfo.getName());
      await Hive.openBox<ProjectsInfo>(ProjectsInfo.getName());
      await Hive.openBox<LobbyRoomInfo>(LobbyRoomInfo.getName());
      await Hive.openBox<LobbyStatus>(LobbyStatus.getName());
      await Hive.openBox<ObjectReactions>(ObjectReactions.getName());
      await Hive.openBox<RoomParticipants>(RoomParticipants.getName());
      await Hive.openBox<StatusHistory>(StatusHistory.getName(), keyComparator: _reverseOrder);
      await Hive.openBox<SearchHistory>(SearchHistory.getName(), keyComparator: _reverseOrder);
      await Hive.openBox<Query>(Query.getName(), keyComparator: _reverseOrder);

      await Hive.openBox<Phone>(Phone.getName());
      await Hive.openBox<Email>(Email.getName());

      await Hive.openBox<NotifStream>(NotifStream.getName());
      await Hive.openBox<UnreadChat>(UnreadChat.getName());
      await Hive.openBox<Topic>(Topic.getName());
    }
    injector.registerSingleton<Box<PushNotification>>(() {
      return Hive.box<PushNotification>(PushNotification.getName());
    });

    injector.registerSingleton<Box<Workspace>>(() {
      return Hive.box<Workspace>(Workspace.getName());
    });

    injector.registerSingleton<Box<Calendar>>(() {
      return Hive.box<Calendar>(Calendar.getName());
    });

    injector.registerSingleton<Box<Chat>>(() {
      return Hive.box<Chat>(Chat.getName());
    });

    injector.registerSingleton<Box<QuotedChat>>(() {
      return Hive.box<QuotedChat>(QuotedChat.getName());
    });

    injector.registerSingleton<Box<Feed>>(() {
      return Hive.box<Feed>(Feed.getName());
    });

    injector.registerSingleton<Box<File>>(() {
      return Hive.box<File>(File.getName());
    });

    injector.registerSingleton<Box<Job>>(() {
      return Hive.box<Job>(Job.getName());
    });

    injector.registerSingleton<Box<JobApplication>>(() {
      return Hive.box<JobApplication>(JobApplication.getName());
    });

    injector.registerSingleton<Box<Notification>>(() {
      return Hive.box<Notification>(Notification.getName());
    });

    injector.registerSingleton<Box<PhObject>>(() {
      return Hive.box<PhObject>(PhObject.getName());
    });

    injector.registerSingleton<Box<PhTransaction>>(() {
      return Hive.box<PhTransaction>(PhTransaction.getName());
    });

    injector.registerSingleton<Box<Project>>(() {
      return Hive.box<Project>(Project.getName());
    });

    injector.registerSingleton<Box<Reaction>>(() {
      return Hive.box<Reaction>(Reaction.getName());
    });

    injector.registerSingleton<Box<Room>>(() {
      return Hive.box<Room>(Room.getName());
    });

    injector.registerSingleton<Box<Setting>>(() {
      return Hive.box<Setting>(Setting.getName());
    });

    injector.registerSingleton<Box<Stickit>>(() {
      return Hive.box<Stickit>(Stickit.getName());
    });

    injector.registerSingleton<Box<Ticket>>(() {
      return Hive.box<Ticket>(Ticket.getName());
    });

    injector.registerSingleton<Box<TicketSubscriberInfo>>(() {
      return Hive.box<TicketSubscriberInfo>(TicketSubscriberInfo.getName());
    });

    injector.registerSingleton<Box<User>>(() {
      return Hive.box<User>(User.getName());
    });

    injector.registerSingleton<Box<WorkInfo>>(() {
      return Hive.box<WorkInfo>(WorkInfo.getName());
    });

    injector.registerSingleton<Box<HiringInfo>>(() {
      return Hive.box<HiringInfo>(HiringInfo.getName());
    });

    injector.registerSingleton<Box<StoryPointInfo>>(() {
      return Hive.box<StoryPointInfo>(StoryPointInfo.getName());
    });

    injector.registerSingleton<Box<SubscriptionInfo>>(() {
      return Hive.box<SubscriptionInfo>(SubscriptionInfo.getName());
    });

    injector.registerSingleton<Box<ProjectsInfo>>(() {
      return Hive.box<ProjectsInfo>(ProjectsInfo.getName());
    });

    injector.registerSingleton<Box<LobbyRoomInfo>>(() {
      return Hive.box<LobbyRoomInfo>(LobbyRoomInfo.getName());
    });

    injector.registerSingleton<Box<LobbyStatus>>(() {
      return Hive.box<LobbyStatus>(LobbyStatus.getName());
    });

    injector.registerSingleton<Box<ObjectReactions>>(() {
      return Hive.box<ObjectReactions>(ObjectReactions.getName());
    });

    injector.registerSingleton<Box<RoomParticipants>>(() {
      return Hive.box<RoomParticipants>(RoomParticipants.getName());
    });

    injector.registerSingleton<Box<StatusHistory>>(() {
      return Hive.box<StatusHistory>(StatusHistory.getName());
    });

    injector.registerSingleton<Box<SearchHistory>>(() {
      return Hive.box<SearchHistory>(SearchHistory.getName());
    });

    injector.registerSingleton<Box<Query>>(() {
      return Hive.box<Query>(Query.getName());
    });

    injector.registerSingleton<Box<Phone>>(() {
      return Hive.box<Phone>(Phone.getName());
    });

    injector.registerSingleton<Box<Email>>(() {
      return Hive.box<Email>(Email.getName());
    });

    injector.registerSingleton<Box<NotifStream>>(() {
      return Hive.box<NotifStream>(NotifStream.getName());
    });

    injector.registerSingleton<Box<UnreadChat>>(() {
      return Hive.box<UnreadChat>(UnreadChat.getName());
    });

    injector.registerSingleton<Box<Topic>>(() {
      return Hive.box<Topic>(Topic.getName());
    });
  }

  static int _reverseOrder(k1, k2) {
    if (k1 is int) {
      if (k2 is int) {
        if (k1 > k2) {
          return -1;
        } else if (k1 < k2) {
          return 1;
        } else {
          return 0;
        }
      } else {
        return -1;
      }
    }

    return 1;
  }
}
