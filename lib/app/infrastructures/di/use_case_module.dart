import 'package:injector/injector.dart';
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
import 'package:mobile_sev2/app/repositories/db/phobject_db_repository.dart';
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
import 'package:mobile_sev2/data/persistences/repositories/contracts/country_inteface.dart';
import 'package:mobile_sev2/use_cases/auth/delete_workspace.dart';
import 'package:mobile_sev2/use_cases/auth/get_token.dart';
import 'package:mobile_sev2/use_cases/auth/get_workspace.dart';
import 'package:mobile_sev2/use_cases/auth/join_workspace.dart';
import 'package:mobile_sev2/use_cases/auth/login.dart';
import 'package:mobile_sev2/use_cases/auth/register.dart';
import 'package:mobile_sev2/use_cases/auth/update_workspace.dart';
import 'package:mobile_sev2/use_cases/calendar/create_event.dart';
import 'package:mobile_sev2/use_cases/calendar/get_events.dart';
import 'package:mobile_sev2/use_cases/calendar/join_event.dart';
import 'package:mobile_sev2/use_cases/chat/delete_message.dart';
import 'package:mobile_sev2/use_cases/chat/get_messages.dart';
import 'package:mobile_sev2/use_cases/chat/send_message.dart';
import 'package:mobile_sev2/use_cases/country/getCountries.dart';
import 'package:mobile_sev2/use_cases/faq/get_faqs.dart';
import 'package:mobile_sev2/use_cases/feed/get_feeds.dart';
import 'package:mobile_sev2/use_cases/file/create_file.dart';
import 'package:mobile_sev2/use_cases/file/get_files.dart';
import 'package:mobile_sev2/use_cases/file/prepare_create_file.dart';
import 'package:mobile_sev2/use_cases/flag/create_flag.dart';
import 'package:mobile_sev2/use_cases/flag/delete_flag.dart';
import 'package:mobile_sev2/use_cases/flag/get_flags.dart';
import 'package:mobile_sev2/use_cases/job/create_job.dart';
import 'package:mobile_sev2/use_cases/job/get_applicants.dart';
import 'package:mobile_sev2/use_cases/job/get_jobs.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_files.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_stickits.dart';
import 'package:mobile_sev2/use_cases/lobby/create_lobby_room_task.dart';
import 'package:mobile_sev2/use_cases/lobby/get_list_user_db.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_participants.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_calendar.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_files.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_stickits.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_room_tickets.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_rooms.dart';
import 'package:mobile_sev2/use_cases/lobby/get_lobby_statuses.dart';
import 'package:mobile_sev2/use_cases/lobby/get_room_hq.dart';
import 'package:mobile_sev2/use_cases/lobby/join_lobby.dart';
import 'package:mobile_sev2/use_cases/lobby/join_lobby_channel.dart';
import 'package:mobile_sev2/use_cases/lobby/leave_work.dart';
import 'package:mobile_sev2/use_cases/lobby/restore_room.dart';
import 'package:mobile_sev2/use_cases/lobby/set_as_read_stickit.dart';
import 'package:mobile_sev2/use_cases/lobby/store_list_reactions_to_db.dart';
import 'package:mobile_sev2/use_cases/lobby/store_list_user_db.dart';
import 'package:mobile_sev2/use_cases/lobby/update_status.dart';
import 'package:mobile_sev2/use_cases/lobby/work_on_task.dart';
import 'package:mobile_sev2/use_cases/mention/get_mentions.dart';
import 'package:mobile_sev2/use_cases/mood/get_moods.dart';
import 'package:mobile_sev2/use_cases/mood/send_mood.dart';
import 'package:mobile_sev2/use_cases/notification/create_notif_stream.dart';
import 'package:mobile_sev2/use_cases/notification/create_notifications.dart';
import 'package:mobile_sev2/use_cases/notification/get_embraces.dart';
import 'package:mobile_sev2/use_cases/notification/get_notif_streams.dart';
import 'package:mobile_sev2/use_cases/notification/get_notifications.dart';
import 'package:mobile_sev2/use_cases/notification/mark_all_read.dart';
import 'package:mobile_sev2/use_cases/phobject/create_object.dart';
import 'package:mobile_sev2/use_cases/phobject/get_object_transactions.dart';
import 'package:mobile_sev2/use_cases/phobject/get_objects.dart';
import 'package:mobile_sev2/use_cases/policy/get_policies.dart';
import 'package:mobile_sev2/use_cases/policy/get_spaces.dart';
import 'package:mobile_sev2/use_cases/project/create_column.dart';
import 'package:mobile_sev2/use_cases/project/create_milestone.dart';
import 'package:mobile_sev2/use_cases/project/create_project.dart';
import 'package:mobile_sev2/use_cases/project/edit_column.dart';
import 'package:mobile_sev2/use_cases/project/get_project_column_ticket.dart';
import 'package:mobile_sev2/use_cases/project/get_project_columns.dart';
import 'package:mobile_sev2/use_cases/project/get_projects.dart';
import 'package:mobile_sev2/use_cases/project/move_ticket.dart';
import 'package:mobile_sev2/use_cases/project/reorder_column.dart';
import 'package:mobile_sev2/use_cases/project/set_project_status.dart';
import 'package:mobile_sev2/use_cases/public_space/get_messages_public_space.dart';
import 'package:mobile_sev2/use_cases/public_space/get_public_space.dart';
import 'package:mobile_sev2/use_cases/push_notification/delete_push_notifications.dart';
import 'package:mobile_sev2/use_cases/push_notification/get_push_notifications.dart';
import 'package:mobile_sev2/use_cases/push_notification/store_push_notification.dart';
import 'package:mobile_sev2/use_cases/reaction/get_object_reactions.dart';
import 'package:mobile_sev2/use_cases/reaction/get_reactions.dart';
import 'package:mobile_sev2/use_cases/reaction/give_reaction.dart';
import 'package:mobile_sev2/use_cases/room/add_participants.dart';
import 'package:mobile_sev2/use_cases/room/create_room.dart';
import 'package:mobile_sev2/use_cases/room/delete_room.dart';
import 'package:mobile_sev2/use_cases/room/get_participants.dart';
import 'package:mobile_sev2/use_cases/room/get_rooms.dart';
import 'package:mobile_sev2/use_cases/room/remove_participants.dart';
import 'package:mobile_sev2/use_cases/room/update_room.dart';
import 'package:mobile_sev2/use_cases/search/add_query.dart';
import 'package:mobile_sev2/use_cases/search/add_search_history.dart';
import 'package:mobile_sev2/use_cases/search/delete_all_search_history.dart';
import 'package:mobile_sev2/use_cases/search/delete_query.dart';
import 'package:mobile_sev2/use_cases/search/delete_search_history.dart';
import 'package:mobile_sev2/use_cases/search/get_query.dart';
import 'package:mobile_sev2/use_cases/search/get_search_history.dart';
import 'package:mobile_sev2/use_cases/setting/get_setting.dart';
import 'package:mobile_sev2/use_cases/setting/update_setting.dart';
import 'package:mobile_sev2/use_cases/stickit/get_stickit.dart';
import 'package:mobile_sev2/use_cases/ticket/create_ticket.dart';
import 'package:mobile_sev2/use_cases/ticket/get_ticket_projects.dart';
import 'package:mobile_sev2/use_cases/ticket/get_ticket_subscribers.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mobile_sev2/use_cases/ticket/task_transaction.dart';
import 'package:mobile_sev2/use_cases/topic/get_subscribe_list.dart';
import 'package:mobile_sev2/use_cases/topic/subscribe_topic.dart';
import 'package:mobile_sev2/use_cases/topic/unsubscribe_topic.dart';
import 'package:mobile_sev2/use_cases/user/create_user.dart';
import 'package:mobile_sev2/use_cases/user/delete_account.dart';
import 'package:mobile_sev2/use_cases/user/get_profile_info.dart';
import 'package:mobile_sev2/use_cases/user/get_story_point_info.dart';
import 'package:mobile_sev2/use_cases/user/get_suite_profile.dart';
import 'package:mobile_sev2/use_cases/user/get_user_contribution.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';
import 'package:mobile_sev2/use_cases/user/update_avatar.dart';
import 'package:mobile_sev2/use_cases/user/update_user.dart';
import 'package:mobile_sev2/use_cases/user/user_checkin.dart';
import 'package:mobile_sev2/use_cases/wiki/get_wikis.dart';

class UseCaseModule {
  static void init(Injector injector) {
    // chat
    injector.registerDependency<GetMessagesUseCase>(
      () {
        return GetMessagesUseCase(injector.get<ChatApiRepository>());
      },
      dependencyName: "get_messages_api",
    );

    injector.registerDependency<GetMessagesUseCase>(
      () {
        return GetMessagesUseCase(injector.get<ChatDBRepository>());
      },
      dependencyName: "get_messages_db",
    );

    injector.registerDependency<SendMessageUseCase>(
      () {
        return SendMessageUseCase(injector.get<ChatApiRepository>());
      },
      dependencyName: "send_messages_api",
    );

    injector.registerDependency<SendMessageUseCase>(
      () {
        return SendMessageUseCase(injector.get<ChatDBRepository>());
      },
      dependencyName: "send_messages_db",
    );

    injector.registerDependency<DeleteMessageUseCase>(() {
      return DeleteMessageUseCase(injector.get<ChatApiRepository>());
    });

    // rooms
    injector.registerDependency<GetRoomsUseCase>(
      () {
        return GetRoomsUseCase(injector.get<RoomApiRepository>());
      },
      dependencyName: "get_rooms_api",
    );

    injector.registerDependency<GetRoomsUseCase>(
      () {
        return GetRoomsUseCase(injector.get<RoomDBRepository>());
      },
      dependencyName: "get_rooms_db",
    );

    injector.registerDependency<CreateRoomUseCase>(
      () {
        return CreateRoomUseCase(injector.get<RoomApiRepository>());
      },
      dependencyName: "create_room_api",
    );

    injector.registerDependency<CreateRoomUseCase>(
      () {
        return CreateRoomUseCase(injector.get<RoomDBRepository>());
      },
      dependencyName: "create_room_db",
    );

    injector.registerDependency<UpdateRoomUseCase>(
      () {
        return UpdateRoomUseCase(injector.get<RoomApiRepository>());
      },
      dependencyName: "update_room_api",
    );

    injector.registerDependency<UpdateRoomUseCase>(
      () {
        return UpdateRoomUseCase(injector.get<RoomDBRepository>());
      },
      dependencyName: "update_room_db",
    );

    injector.registerDependency<DeleteRoomUseCase>(
      () {
        return DeleteRoomUseCase(injector.get<RoomApiRepository>());
      },
      dependencyName: "delete_room_api",
    );

    injector.registerDependency<DeleteRoomUseCase>(
      () {
        return DeleteRoomUseCase(injector.get<RoomDBRepository>());
      },
      dependencyName: "delete_room_db",
    );

    injector.registerDependency<AddRoomParticipantsUseCase>(
      () {
        return AddRoomParticipantsUseCase(injector.get<RoomApiRepository>());
      },
      dependencyName: "add_participants_api",
    );

    injector.registerDependency<AddRoomParticipantsUseCase>(
      () {
        return AddRoomParticipantsUseCase(injector.get<RoomDBRepository>());
      },
      dependencyName: "add_participants_db",
    );

    injector.registerDependency<RemoveRoomParticipantsUseCase>(
      () {
        return RemoveRoomParticipantsUseCase(injector.get<RoomApiRepository>());
      },
      dependencyName: "remove_participants_api",
    );

    injector.registerDependency<RemoveRoomParticipantsUseCase>(
      () {
        return RemoveRoomParticipantsUseCase(injector.get<RoomDBRepository>());
      },
      dependencyName: "remove_participants_db",
    );

    injector.registerDependency<GetRoomParticipantsUseCase>(
      () {
        return GetRoomParticipantsUseCase(injector.get<RoomApiRepository>());
      },
      dependencyName: "get_participants_api",
    );

    injector.registerDependency<GetRoomParticipantsUseCase>(
      () {
        return GetRoomParticipantsUseCase(injector.get<RoomDBRepository>());
      },
      dependencyName: "get_participants_db",
    );

    // feeds
    injector.registerDependency<GetFeedsUseCase>(
      () {
        return GetFeedsUseCase(injector.get<FeedApiRepository>());
      },
      dependencyName: "get_feeds_api",
    );

    injector.registerDependency<GetFeedsUseCase>(
      () {
        return GetFeedsUseCase(injector.get<FeedDBRepository>());
      },
      dependencyName: "get_feeds_db",
    );

    // faq
    injector.registerDependency<GetFaqsUseCase>(
      () {
        return GetFaqsUseCase(injector.get<FaqApiRepository>());
      },
      dependencyName: "get_faqs_api",
    );

    injector.registerDependency<GetFaqsUseCase>(
      () {
        return GetFaqsUseCase(injector.get<FaqDBRepository>());
      },
      dependencyName: "get_faqs_db",
    );

    // notification
    injector.registerDependency<GetNotificationsUseCase>(
      () {
        return GetNotificationsUseCase(
            injector.get<NotificationApiRepository>());
      },
      dependencyName: "get_notifications_api",
    );

    injector.registerDependency<GetNotificationsUseCase>(
      () {
        return GetNotificationsUseCase(
            injector.get<NotificationDBRepository>());
      },
      dependencyName: "get_notifications_db",
    );

    injector.registerDependency<MarkNotificationsReadUseCase>(
      () {
        return MarkNotificationsReadUseCase(
            injector.get<NotificationApiRepository>());
      },
      dependencyName: "mark_notifications_api",
    );

    injector.registerDependency<MarkNotificationsReadUseCase>(
      () {
        return MarkNotificationsReadUseCase(
            injector.get<NotificationDBRepository>());
      },
      dependencyName: "mark_notifications_db",
    );

    injector.registerDependency<CreateNotificationUseCase>(
      () {
        return CreateNotificationUseCase(
            injector.get<NotificationDBRepository>());
      },
      dependencyName: "create_notification_db",
    );

    injector.registerDependency<GetMentionsUseCase>(
      () {
        return GetMentionsUseCase(injector.get<MentionApiRepository>());
      },
      dependencyName: "get_mentions_api",
    );

    // jobs
    injector.registerDependency<GetJobsUseCase>(
      () {
        return GetJobsUseCase(injector.get<JobApiRepository>());
      },
      dependencyName: "get_jobs_api",
    );

    injector.registerDependency<GetJobsUseCase>(
      () {
        return GetJobsUseCase(injector.get<JobDBRepository>());
      },
      dependencyName: "get_jobs_db",
    );

    injector.registerDependency<GetApplicantsUseCase>(
      () {
        return GetApplicantsUseCase(injector.get<JobApiRepository>());
      },
      dependencyName: "get_applicants_api",
    );

    injector.registerDependency<GetApplicantsUseCase>(
      () {
        return GetApplicantsUseCase(injector.get<JobDBRepository>());
      },
      dependencyName: "get_applicants_db",
    );

    injector.registerDependency<CreateJobUseCase>(
      () {
        return CreateJobUseCase(injector.get<JobDBRepository>());
      },
      dependencyName: "create_job_db",
    );

    // ticket
    injector.registerDependency<GetTicketsUseCase>(
      () {
        return GetTicketsUseCase(injector.get<TicketApiRepository>());
      },
      dependencyName: "get_tickets_api",
    );

    injector.registerDependency<GetTicketsUseCase>(
      () {
        return GetTicketsUseCase(injector.get<TicketDBRepository>());
      },
      dependencyName: "get_tickets_db",
    );

    injector.registerDependency<CreateTicketUseCase>(
      () {
        return CreateTicketUseCase(injector.get<TicketDBRepository>());
      },
      dependencyName: "create_ticket_db",
    );

    injector.registerDependency<GetTicketProjectsUseCase>(
      () {
        return GetTicketProjectsUseCase(injector.get<TicketApiRepository>());
      },
      dependencyName: "get_ticket_projects_api",
    );

    // project
    injector.registerDependency<GetProjectsUseCase>(
      () {
        return GetProjectsUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "get_projects_api",
    );

    injector.registerDependency<GetProjectsUseCase>(
      () {
        return GetProjectsUseCase(injector.get<ProjectDBRepository>());
      },
      dependencyName: "get_projects_db",
    );

    injector.registerDependency<CreateProjectUseCase>(
      () {
        return CreateProjectUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "create_project_api",
    );

    injector.registerDependency<CreateProjectUseCase>(
      () {
        return CreateProjectUseCase(injector.get<ProjectDBRepository>());
      },
      dependencyName: "create_project_db",
    );

    injector.registerDependency<GetProjectColumnsUseCase>(
      () {
        return GetProjectColumnsUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "get_project_columns_api",
    );

    injector.registerDependency<GetProjectColumnTicketUseCase>(
      () {
        return GetProjectColumnTicketUseCase(
            injector.get<ProjectApiRepository>());
      },
      dependencyName: "get_project_column_ticket_api",
    );

    injector.registerDependency<MoveTicketUseCase>(
      () {
        return MoveTicketUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "move_ticket_api",
    );

    injector.registerDependency<EditColumnUseCase>(
      () {
        return EditColumnUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "edit_column_api",
    );

    injector.registerDependency<ReorderColumnUseCase>(
      () {
        return ReorderColumnUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "reorder_column_api",
    );

    injector.registerDependency<CreateColumnUseCase>(
      () {
        return CreateColumnUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "create_column_api",
    );

    injector.registerDependency<SetProjectStatusUseCase>(
      () {
        return SetProjectStatusUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "set_project_status_api",
    );

    injector.registerDependency<CreateMilestoneUseCase>(
      () {
        return CreateMilestoneUseCase(injector.get<ProjectApiRepository>());
      },
      dependencyName: "create_milestone_api",
    );

    // subscribers info
    injector.registerDependency<GetTicketSubscribersUseCase>(
      () {
        return GetTicketSubscribersUseCase(injector.get<TicketApiRepository>());
      },
      dependencyName: "get_ticket_subscribers_api",
    );

    // user
    injector.registerDependency<GetUsersUseCase>(
      () {
        return GetUsersUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "get_users_api",
    );

    injector.registerDependency<GetUsersUseCase>(
      () {
        return GetUsersUseCase(injector.get<UserDBRepository>());
      },
      dependencyName: "get_users_db",
    );

    injector.registerDependency<GetProfileUseCase>(
      () {
        return GetProfileUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "get_profile_api",
    );

    injector.registerDependency<GetProfileUseCase>(
      () {
        return GetProfileUseCase(injector.get<UserDBRepository>());
      },
      dependencyName: "get_profile_db",
    );

    injector.registerDependency<GetStoryPointUseCase>(
      () {
        return GetStoryPointUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "get_story_point_api",
    );

    injector.registerDependency<GetStoryPointUseCase>(
      () {
        return GetStoryPointUseCase(injector.get<UserDBRepository>());
      },
      dependencyName: "get_story_point_db",
    );

    injector.registerDependency<GetSuiteProfileUseCase>(
      () {
        return GetSuiteProfileUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "get_suite_profile_api",
    );

    injector.registerDependency<GetSuiteProfileUseCase>(
      () {
        return GetSuiteProfileUseCase(injector.get<UserDBRepository>());
      },
      dependencyName: "get_suite_profile_db",
    );

    injector.registerDependency<UpdateUserUseCase>(
      () {
        return UpdateUserUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "update_user_api",
    );
    injector.registerDependency<UpdateAvatarUserUseCase>(
      () {
        return UpdateAvatarUserUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "update_avatar_user_api",
    );

    injector.registerDependency<CreateUserUseCase>(
      () {
        return CreateUserUseCase(injector.get<UserDBRepository>());
      },
      dependencyName: "create_user_db",
    );

    injector.registerDependency<GetUserContributionsUseCase>(
      () {
        return GetUserContributionsUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "get_user_contributions_api",
    );

    // file
    injector.registerDependency<GetFilesUseCase>(
      () {
        return GetFilesUseCase(injector.get<FileApiRepository>());
      },
      dependencyName: "get_files_api",
    );

    injector.registerDependency<GetFilesUseCase>(
      () {
        return GetFilesUseCase(injector.get<FileDBRepository>());
      },
      dependencyName: "get_files_db",
    );

    injector.registerDependency<CreateFileUseCase>(
      () {
        return CreateFileUseCase(injector.get<FileApiRepository>());
      },
      dependencyName: "create_file_api",
    );

    injector.registerDependency<CreateFileUseCase>(
      () {
        return CreateFileUseCase(injector.get<FileDBRepository>());
      },
      dependencyName: "create_file_db",
    );

    injector.registerDependency<PrepareCreateFileUseCase>(
      () {
        return PrepareCreateFileUseCase(injector.get<FileApiRepository>());
      },
      dependencyName: "prepare_files_api",
    );

    // objects
    injector.registerDependency<GetObjectsUseCase>(
      () {
        return GetObjectsUseCase(injector.get<PhobjectApiRepository>());
      },
      dependencyName: "get_objects_api",
    );

    injector.registerDependency<GetObjectsUseCase>(
      () {
        return GetObjectsUseCase(injector.get<PhObjectDBRepository>());
      },
      dependencyName: "get_objects_db",
    );

    injector.registerDependency<GetObjectTransactionsUseCase>(
      () {
        return GetObjectTransactionsUseCase(
            injector.get<PhobjectApiRepository>());
      },
      dependencyName: "get_object_transactions_api",
    );

    injector.registerDependency<GetObjectTransactionsUseCase>(
      () {
        return GetObjectTransactionsUseCase(
            injector.get<PhObjectDBRepository>());
      },
      dependencyName: "get_object_transactions_db",
    );

    injector.registerDependency<CreateObjectUseCase>(
      () {
        return CreateObjectUseCase(injector.get<PhobjectApiRepository>());
      },
      dependencyName: "create_object_db",
    );

    // auth
    injector.registerDependency<LoginUseCase>(
      () {
        return LoginUseCase(injector.get<AuthApiRepository>());
      },
      dependencyName: "login_api",
    );

    injector.registerDependency<RegisterUseCase>(
      () {
        return RegisterUseCase(injector.get<AuthApiRepository>());
      },
      dependencyName: "register_api",
    );

    injector.registerDependency<GetTokenUseCase>(
      () {
        return GetTokenUseCase(injector.get<AuthApiRepository>());
      },
      dependencyName: "get_token_api",
    );

    injector.registerDependency<GetWorkspaceUseCase>(
      () {
        return GetWorkspaceUseCase(injector.get<AuthApiRepository>());
      },
      dependencyName: "get_workspace_api",
    );

    injector.registerDependency<GetWorkspaceUseCase>(
      () {
        return GetWorkspaceUseCase(injector.get<AuthDBRepository>());
      },
      dependencyName: "get_workspace_db",
    );

    injector.registerDependency<JoinWorkspaceUseCase>(
      () {
        return JoinWorkspaceUseCase(injector.get<AuthApiRepository>());
      },
      dependencyName: "join_workspace_api",
    );

    injector.registerDependency<UpdateWorkspaceUseCase>(
      () {
        return UpdateWorkspaceUseCase(injector.get<AuthDBRepository>());
      },
      dependencyName: "update_workspace_db",
    );

    injector.registerDependency<DeleteWorkspaceUseCase>(
      () {
        return DeleteWorkspaceUseCase(injector.get<AuthDBRepository>());
      },
      dependencyName: "delete_workspace_db",
    );

    // lobby
    injector.registerDependency<GetLobbyParticipantsUseCase>(
      () {
        return GetLobbyParticipantsUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "get_lobby_participants_api",
    );

    injector.registerDependency<GetLobbyRoomsUseCase>(
      () {
        return GetLobbyRoomsUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "get_lobby_rooms_api",
    );

    injector.registerDependency<GetRoomHQUseCase>(
      () {
        return GetRoomHQUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "get_room_hq_api",
    );

    injector.registerDependency<UpdateStatusUseCase>(
      () {
        return UpdateStatusUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "update_status_api",
    );

    injector.registerDependency<JoinLobbyUseCase>(
      () {
        return JoinLobbyUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "join_lobby_api",
    );

    injector.registerDependency<JoinLobbyChannelUseCase>(
      () {
        return JoinLobbyChannelUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "join_lobby_channel_api",
    );

    injector.registerDependency<LeaveWorkUseCase>(
      () {
        return LeaveWorkUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "leave_work_api",
    );

    injector.registerDependency<WorkOnTaskUseCase>(
      () {
        return WorkOnTaskUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "work_on_task_api",
    );

    injector.registerDependency<GetLobbyStatusesUseCase>(
      () {
        return GetLobbyStatusesUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "get_lobby_statuses_api",
    );

    injector.registerDependency<GetLobbyStatusesUseCase>(
      () {
        return GetLobbyStatusesUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "get_lobby_statuses_db",
    );

    injector.registerDependency<GetLobbyRoomCalendarUseCase>(
      () {
        return GetLobbyRoomCalendarUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "get_lobby_room_calendar_api",
    );

    injector.registerDependency<GetEventsUseCase>(
      () {
        return GetEventsUseCase(injector.get<CalendarApiRepository>());
      },
      dependencyName: "get_events_api",
    );

    injector.registerDependency<JoinEventUseCase>(
      () {
        return JoinEventUseCase(injector.get<CalendarApiRepository>());
      },
      dependencyName: "join_event_api",
    );

    injector.registerDependency<GetLobbyRoomFilesUseCase>(
      () {
        return GetLobbyRoomFilesUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "get_lobby_room_files_api",
    );

    injector.registerDependency<GetLobbyRoomStickitsUseCase>(
      () {
        return GetLobbyRoomStickitsUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "get_lobby_room_stickits_api",
    );

    injector.registerDependency<GetLobbyRoomTicketsUseCase>(
      () {
        return GetLobbyRoomTicketsUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "get_lobby_room_tickets_api",
    );

    injector.registerDependency<StoreListUserDbUseCase>(
      () {
        return StoreListUserDbUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "store_list_user_db",
    );

    injector.registerDependency<GetListUserDbUseCase>(
      () {
        return GetListUserDbUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "get_list_user_db",
    );
    injector.registerDependency<StoreListReactionToDbUseCase>(
      () {
        return StoreListReactionToDbUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "store_list_reaction_db",
    );

    // lobby room info
    injector.registerDependency<GetLobbyRoomsUseCase>(
      () {
        return GetLobbyRoomsUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "get_lobby_rooms_db",
    );

    injector.registerDependency<GetLobbyRoomCalendarUseCase>(
      () {
        return GetLobbyRoomCalendarUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "get_lobby_room_calendar_db",
    );

    injector.registerDependency<GetLobbyRoomFilesUseCase>(
      () {
        return GetLobbyRoomFilesUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "get_lobby_room_files_db",
    );

    injector.registerDependency<GetLobbyRoomStickitsUseCase>(
      () {
        return GetLobbyRoomStickitsUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "get_lobby_room_stickits_db",
    );

    injector.registerDependency<GetLobbyRoomTicketsUseCase>(
      () {
        return GetLobbyRoomTicketsUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "get_lobby_room_tickets_db",
    );

    injector.registerDependency<CreateEventUseCase>(
      () {
        return CreateEventUseCase(injector.get<CalendarApiRepository>());
      },
      dependencyName: "create_event_api",
    );

    injector.registerDependency<CreateLobbyRoomFileUseCase>(
      () {
        return CreateLobbyRoomFileUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "create_lobby_room_file_db",
    );

    injector.registerDependency<CreateLobbyRoomTaskUseCase>(
      () {
        return CreateLobbyRoomTaskUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "create_lobby_room_task_api",
    );

    injector.registerDependency<CreateLobbyRoomTaskUseCase>(
      () {
        return CreateLobbyRoomTaskUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "create_lobby_room_task_db",
    );

    injector.registerDependency<CreateLobbyRoomStickitUseCase>(
      () {
        return CreateLobbyRoomStickitUseCase(
            injector.get<LobbyApiRepository>());
      },
      dependencyName: "create_lobby_room_stickit_api",
    );

    injector.registerDependency<CreateLobbyRoomStickitUseCase>(
      () {
        return CreateLobbyRoomStickitUseCase(injector.get<LobbyDBRepository>());
      },
      dependencyName: "create_lobby_room_stickit_db",
    );

    // setting
    injector.registerDependency<GetSettingUseCase>(
      () {
        return GetSettingUseCase(injector.get<SettingDBRepository>());
      },
      dependencyName: "get_setting_db",
    );

    injector.registerDependency<UpdateSettingUseCase>(
      () {
        return UpdateSettingUseCase(injector.get<SettingDBRepository>());
      },
      dependencyName: "update_setting_db",
    );

    // reaction
    injector.registerDependency<GiveReactionUseCase>(
      () {
        return GiveReactionUseCase(injector.get<ReactionApiRepository>());
      },
      dependencyName: "give_reaction_api",
    );

    injector.registerDependency<GetReactionsUseCase>(
      () {
        return GetReactionsUseCase(injector.get<ReactionApiRepository>());
      },
      dependencyName: "get_reactions_api",
    );

    injector.registerDependency<GetObjectReactionsUseCase>(
      () {
        return GetObjectReactionsUseCase(injector.get<ReactionApiRepository>());
      },
      dependencyName: "get_object_reactions_api",
    );

    injector.registerDependency<GiveReactionUseCase>(
      () {
        return GiveReactionUseCase(injector.get<ReactionDBRepository>());
      },
      dependencyName: "give_reaction_db",
    );

    injector.registerDependency<GetReactionsUseCase>(
      () {
        return GetReactionsUseCase(injector.get<ReactionDBRepository>());
      },
      dependencyName: "get_reactions_db",
    );

    injector.registerDependency<GetObjectReactionsUseCase>(
      () {
        return GetObjectReactionsUseCase(injector.get<ReactionDBRepository>());
      },
      dependencyName: "get_object_reactions_db",
    );

    injector.registerDependency<GetPoliciesUseCase>(
      () {
        return GetPoliciesUseCase(injector.get<PolicyApiRepository>());
      },
      dependencyName: "get_policies_api",
    );

    injector.registerDependency<GetSpacesUseCase>(
      () {
        return GetSpacesUseCase(injector.get<PolicyApiRepository>());
      },
      dependencyName: "get_spaces_api",
    );

    // notif stream
    injector.registerDependency<CreateNotifStreamUseCase>(
      () {
        return CreateNotifStreamUseCase(
            injector.get<NotificationDBRepository>());
      },
      dependencyName: "create_notif_stream_api",
    );

    injector.registerDependency<GetNotifStreamsUseCase>(
      () {
        return GetNotifStreamsUseCase(injector.get<NotificationDBRepository>());
      },
      dependencyName: "get_notif_streams_db",
    );

    injector.registerDependency<GetEmbracesUseCase>(
      () {
        return GetEmbracesUseCase(injector.get<NotificationDBRepository>());
      },
      dependencyName: "get_embraces_api",
    );

    // search history
    injector.registerDependency<GetSearchHistoryUseCase>(
      () {
        return GetSearchHistoryUseCase(injector.get<SearchDBRepository>());
      },
      dependencyName: "get_search_history_db",
    );

    injector.registerDependency<AddSearchHistoryUseCase>(
      () {
        return AddSearchHistoryUseCase(injector.get<SearchDBRepository>());
      },
      dependencyName: "add_search_history_db",
    );

    injector.registerDependency<DeleteSearchHistoryUseCase>(
      () {
        return DeleteSearchHistoryUseCase(injector.get<SearchDBRepository>());
      },
      dependencyName: "delete_search_history_db",
    );

    injector.registerDependency<DeleteAllSearchHistoryUseCase>(
      () {
        return DeleteAllSearchHistoryUseCase(
            injector.get<SearchDBRepository>());
      },
      dependencyName: "delete_all_search_history_db",
    );

    // query
    injector.registerDependency<GetQueryUseCase>(
      () {
        return GetQueryUseCase(injector.get<SearchDBRepository>());
      },
      dependencyName: "get_query_db",
    );

    injector.registerDependency<AddQueryUseCase>(
      () {
        return AddQueryUseCase(injector.get<SearchDBRepository>());
      },
      dependencyName: "add_query_db",
    );

    injector.registerDependency<DeleteQueryUseCase>(
      () {
        return DeleteQueryUseCase(injector.get<SearchDBRepository>());
      },
      dependencyName: "delete_query_db",
    );

    // flag
    injector.registerDependency<GetFlagsUseCase>(
      () {
        return GetFlagsUseCase(injector.get<FlagApiRepository>());
      },
      dependencyName: "get_flags_api",
    );

    injector.registerDependency<CreateFlagUseCase>(
      () {
        return CreateFlagUseCase(injector.get<FlagApiRepository>());
      },
      dependencyName: "create_flag_api",
    );

    injector.registerDependency<DeleteFlagUseCase>(
      () {
        return DeleteFlagUseCase(injector.get<FlagApiRepository>());
      },
      dependencyName: "delete_flag_api",
    );

    // topic

    injector.registerDependency<SubscribeTopicUseCase>(
      () {
        return SubscribeTopicUseCase(injector.get<TopicApiRepository>());
      },
      dependencyName: "subscribe_topic_api",
    );

    injector.registerDependency<UnsubscribeTopicUseCase>(
      () {
        return UnsubscribeTopicUseCase(injector.get<TopicApiRepository>());
      },
      dependencyName: "unsubscribe_topic_api",
    );

    injector.registerDependency<GetSubscribeListUseCase>(
      () {
        return GetSubscribeListUseCase(injector.get<TopicDBRepository>());
      },
      dependencyName: "get_subscribe_list_db",
    );

    injector.registerDependency<SubscribeTopicUseCase>(
      () {
        return SubscribeTopicUseCase(injector.get<TopicDBRepository>());
      },
      dependencyName: "subscribe_topic_db",
    );

    injector.registerDependency<UnsubscribeTopicUseCase>(
      () {
        return UnsubscribeTopicUseCase(injector.get<TopicDBRepository>());
      },
      dependencyName: "unsubscribe_topic_db",
    );

    injector.registerDependency<GetMoodsUseCase>(
      () {
        return GetMoodsUseCase(injector.get<MoodApiRepository>());
      },
      dependencyName: "get_moods_api",
    );

    injector.registerDependency<SendMoodUseCase>(
      () {
        return SendMoodUseCase(injector.get<MoodApiRepository>());
      },
      dependencyName: "send_mood_api",
    );

    injector.registerDependency<RestoreRoomUseCase>(
      () {
        return RestoreRoomUseCase(injector.get<RoomApiRepository>());
      },
      dependencyName: "restore_room_api",
    );

    injector.registerDependency<SetAsReadStickitUseCase>(
      () {
        return SetAsReadStickitUseCase(injector.get<LobbyApiRepository>());
      },
      dependencyName: "set_as_read_stickit_api",
    );

    injector.registerDependency<GetPublicSpaceUseCase>(
      () {
        return GetPublicSpaceUseCase(injector.get<PublicSpaceApiRepository>());
      },
      dependencyName: "get_public_space_api",
    );

    injector.registerDependency<GetMessagesPublicSpaceUseCase>(
      () {
        return GetMessagesPublicSpaceUseCase(
            injector.get<PublicSpaceApiRepository>());
      },
      dependencyName: "get_messages_public_space_api",
    );
    injector.registerDependency<TaskTransactionUseCase>(
      () {
        return TaskTransactionUseCase(injector.get<TicketApiRepository>());
      },
      dependencyName: "remove_sub_task_api",
    );

    // push notification
    injector.registerDependency<GetPushNotificationUseCase>(
      () {
        return GetPushNotificationUseCase(
            injector.get<PushNotificationDBRepository>());
      },
      dependencyName: "get_push_notification_db",
    );

    injector.registerDependency<StorePushNotificationUseCase>(
      () {
        return StorePushNotificationUseCase(
            injector.get<PushNotificationDBRepository>());
      },
      dependencyName: "store_push_notification_db",
    );

    injector.registerDependency<DeletePushNotificationUseCase>(
      () {
        return DeletePushNotificationUseCase(
            injector.get<PushNotificationDBRepository>());
      },
      dependencyName: "delete_push_notification_db",
    );

    injector.registerDependency<GetStickitsUseCase>(
      () {
        return GetStickitsUseCase(injector.get<StickitApiRepositry>());
      },
      dependencyName: "get_stickits_api",
    );

    injector.registerDependency<UserCheckinUseCase>(
      () {
        return UserCheckinUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "user_checkin_api",
    );

    injector.registerDependency<UserDeleteAccountUseCase>(
      () {
        return UserDeleteAccountUseCase(injector.get<UserApiRepository>());
      },
      dependencyName: "user_delete_account_api",
    );

    injector.registerDependency<GetCountriesUseCase>(
      () {
        return GetCountriesUseCase(injector.get<CountryApiRepository>());
      },
      dependencyName: "get_countries_api",
    );

    injector.registerDependency<GetWikisUseCase>(
      () {
        return GetWikisUseCase(injector.get<WikiApiRepository>());
      },
      dependencyName: "get_wikis_api",
    );
  }
}
