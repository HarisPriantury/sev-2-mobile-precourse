import 'package:injector/injector.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
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
import 'package:uuid/uuid.dart';

class MapperModule {
  static void init(Injector injector) {
    injector.registerSingleton<FeedMapper>(() => FeedMapper(injector.get<DateUtil>()));
    injector.registerSingleton<ChatMapper>(() => ChatMapper(injector.get<DateUtil>()));
    injector.registerSingleton<RoomMapper>(() => RoomMapper(injector.get<UserData>().workspace));
    injector.registerSingleton<NotificationMapper>(() => NotificationMapper(injector.get<DateUtil>()));
    injector.registerSingleton<ProjectMapper>(() => ProjectMapper(injector.get<DateUtil>()));
    injector.registerSingleton<TicketMapper>(() => TicketMapper(injector.get<DateUtil>()));
    injector.registerSingleton<UserMapper>(() => UserMapper(injector.get<DateUtil>()));
    injector.registerSingleton<JobMapper>(() => JobMapper(injector.get<DateUtil>()));
    injector.registerSingleton<FileMapper>(() => FileMapper(injector.get<DateUtil>()));
    injector.registerSingleton<PhobjectMapper>(() => PhobjectMapper(injector.get<DateUtil>(), injector.get<Uuid>()));
    injector.registerSingleton<AuthMapper>(() => AuthMapper(injector.get<DateUtil>()));
    injector.registerSingleton<LobbyMapper>(() => LobbyMapper(injector.get<DateUtil>(), injector.get<UserData>().workspace));
    injector.registerSingleton<ReactionMapper>(() => ReactionMapper(injector.get<DateUtil>()));
    injector.registerSingleton<FaqMapper>(() => FaqMapper(injector.get<DateUtil>()));
    injector.registerSingleton<PolicyMapper>(() => PolicyMapper());
    injector.registerSingleton<CalendarMapper>(() => CalendarMapper(injector.get<DateUtil>()));
    injector.registerSingleton<MoodMapper>(() => MoodMapper(injector.get<DateUtil>()));
    injector.registerSingleton<PublicSpaceMapper>(() => PublicSpaceMapper(injector.get<DateUtil>(),injector.get<UserData>().workspace));
    injector.registerSingleton<FlagMapper>(() => FlagMapper());
    injector.registerSingleton<MentionMapper>(() => MentionMapper(injector.get<DateUtil>()));
    injector.registerSingleton<StickitMapper>(() => StickitMapper(injector.get<DateUtil>()));
    injector.registerSingleton<WikiMapper>(() => WikiMapper(injector.get<DateUtil>()));
  }
}
