import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:injector/injector.dart';
import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/app/infrastructures/graphQl/graphql_api_client.dart';
import 'package:mobile_sev2/app/infrastructures/misc/encrypter.dart';
import 'package:mobile_sev2/app/infrastructures/persistences/api_service.dart';
import 'package:mobile_sev2/app/repositories/api/auth_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/calendar_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/chat_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/faq_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/feed_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/file_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/flag_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/job_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/lobby_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/mention_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/mood_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/notification_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/phobject_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/policy_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/project_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/public_space_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/reaction_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/room_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/stickit_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/ticket_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/topic_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/user_api_repository.dart';
import 'package:mobile_sev2/app/repositories/api/wiki_api_repository.dart';
import 'package:mobile_sev2/app/repositories/db/auth_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/chat_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/faq_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/feed_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/file_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/job_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/lobby_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/notification_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/project_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/push_notification_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/reaction_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/room_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/search_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/setting_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/ticket_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/topic_db_repository.dart';
import 'package:mobile_sev2/app/repositories/db/user_db_repository.dart';
import 'package:mobile_sev2/app/repositories/graphQL/country_api_repository.dart';
import 'package:mobile_sev2/data/persistences/mappers/auth_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/calendar_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/chat_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/faq_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/feed_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/file_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/flag_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/job_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/lobby_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/mention_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/mood_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/notification_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/phobject_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/policy_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/project_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/public_space_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/reaction_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/room_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/stickit_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/ticket_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/user_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/wiki_mapper.dart';
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
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/notification.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/query.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class RepositoryModule {
  static void init(Injector injector) {
    injector.registerDependency<ChatApiRepository>(() {
      return ChatApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<ChatMapper>(),
      );
    });

    injector.registerDependency<RoomApiRepository>(() {
      return RoomApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<RoomMapper>(),
      );
    });

    injector.registerDependency<FeedApiRepository>(() {
      return FeedApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<FeedMapper>(),
      );
    });

    injector.registerDependency<JobApiRepository>(() {
      return JobApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<JobMapper>(),
      );
    });

    injector.registerDependency<NotificationApiRepository>(() {
      return NotificationApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<NotificationMapper>(),
      );
    });

    injector.registerDependency<MentionApiRepository>(() {
      return MentionApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<MentionMapper>(),
      );
    });

    injector.registerDependency<ProjectApiRepository>(() {
      return ProjectApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<ProjectMapper>(),
      );
    });

    injector.registerDependency<TicketApiRepository>(() {
      return TicketApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<TicketMapper>(),
      );
    });

    injector.registerDependency<UserApiRepository>(() {
      return UserApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<UserMapper>(),
      );
    });

    injector.registerDependency<FileApiRepository>(() {
      return FileApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<FileMapper>(),
      );
    });

    injector.registerDependency<PhobjectApiRepository>(() {
      return PhobjectApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<PhobjectMapper>(),
      );
    });

    injector.registerDependency<AuthApiRepository>(() {
      return AuthApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<AuthMapper>(),
      );
    });

    injector.registerDependency<LobbyApiRepository>(() {
      return LobbyApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<LobbyMapper>(),
        injector.get<CalendarMapper>(),
      );
    });

    injector.registerDependency<ReactionApiRepository>(() {
      return ReactionApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<ReactionMapper>(),
      );
    });

    injector.registerDependency<CalendarApiRepository>(() {
      return CalendarApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<CalendarMapper>(),
      );
    });

    injector.registerDependency<FaqApiRepository>(() {
      return FaqApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<FaqMapper>(),
      );
    });

    injector.registerDependency<PolicyApiRepository>(() {
      return PolicyApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<PolicyMapper>(),
      );
    });

    injector.registerDependency<MoodApiRepository>(() {
      return MoodApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<MoodMapper>(),
      );
    });

    injector.registerDependency<PublicSpaceApiRepository>(() {
      return PublicSpaceApiRepository(
        injector.get<PublicSpaceMapper>(),
      );
    });

    // topic
    injector.registerDependency<TopicApiRepository>(() {
      return TopicApiRepository(injector.get<FirebaseMessaging>());
    });

    // flag
    injector.registerDependency<FlagApiRepository>(() {
      return FlagApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<FlagMapper>(),
      );
    });

    // ============= DB Repository =================== //

    injector.registerDependency<AuthDBRepository>(() {
      return AuthDBRepository(
        injector.get<Box<Workspace>>(),
        injector.get<Encrypter>(),
      );
    });

    injector.registerDependency<ChatDBRepository>(() {
      return ChatDBRepository(injector.get<Box<Chat>>());
    });

    injector.registerDependency<FeedDBRepository>(() {
      return FeedDBRepository(injector.get<Box<Feed>>());
    });

    injector.registerDependency<FileDBRepository>(() {
      return FileDBRepository(injector.get<Box<File>>());
    });

    injector.registerDependency<JobDBRepository>(() {
      return JobDBRepository(injector.get<Box<Job>>());
    });

    injector.registerDependency<NotificationDBRepository>(() {
      return NotificationDBRepository(
        injector.get<Box<Notification>>(),
        injector.get<Box<NotifStream>>(),
      );
    });

    injector.registerDependency<ProjectDBRepository>(() {
      return ProjectDBRepository(
        injector.get<Box<Project>>(),
      );
    });

    injector.registerDependency<RoomDBRepository>(() {
      return RoomDBRepository(
        injector.get<Box<Room>>(),
        injector.get<Box<RoomParticipants>>(),
      );
    });

    injector.registerDependency<TicketDBRepository>(() {
      return TicketDBRepository(injector.get<Box<Ticket>>());
    });

    injector.registerDependency<UserDBRepository>(() {
      return UserDBRepository(
        injector.get<Box<User>>(),
        injector.get<Box<StoryPointInfo>>(),
      );
    });

    injector.registerDependency<SearchDBRepository>(() {
      return SearchDBRepository(
        injector.get<Box<SearchHistory>>(),
        injector.get<Box<Query>>(),
      );
    });

    // setting
    injector.registerDependency<SettingDBRepository>(() {
      return SettingDBRepository(injector.get<Box<Setting>>());
    });

    injector.registerDependency<ReactionDBRepository>(() {
      return ReactionDBRepository(
        injector.get<Box<Reaction>>(),
        injector.get<Box<ObjectReactions>>(),
      );
    });

    // faq
    injector.registerDependency<FaqDBRepository>(() {
      return FaqDBRepository();
    });

    // topic
    injector.registerDependency<TopicDBRepository>(() {
      return TopicDBRepository(injector.get<Box<Topic>>());
    });

    // lobby
    injector.registerDependency<LobbyDBRepository>(() {
      return LobbyDBRepository(
        injector.get<Box<LobbyRoomInfo>>(),
        injector.get<Box<Room>>(),
        injector.get<Box<LobbyStatus>>(),
        injector.get<Box<User>>(),
        injector.get<Box<Reaction>>(),
      );
    });

    // push notification
    injector.registerDependency(() {
      return PushNotificationDBRepository(
          injector.get<Box<PushNotification>>());
    });

    //stickit
    injector.registerDependency<StickitApiRepositry>(() {
      return StickitApiRepositry(
        injector.get<Endpoints>(),
        injector.get<StickitMapper>(),
        injector.get<ApiService>(),
      );
    });

    injector.registerDependency<CountryApiRepository>(() {
      return CountryApiRepository(
        injector.get<GraphQLApiClient>(),
      );
    });

    injector.registerDependency<WikiApiRepository>(() {
      return WikiApiRepository(
        injector.get<ApiService>(),
        injector.get<Endpoints>(),
        injector.get<WikiMapper>(),
      );
    });
  }
}
