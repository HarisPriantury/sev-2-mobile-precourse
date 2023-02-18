import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injector/injector.dart';
import 'package:mobile_sev2/app/ui/pages/appbar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/register/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/splash/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/calendar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/custom_policy/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/daily_mood/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/add_action/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_assignee/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_project/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_subscriber/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_stickit/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/edit_member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/search_member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/column_list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/form_column/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/calendar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/stickit/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/ticket/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/main/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/notification/comment/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/notification/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_calendar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_edit/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/project/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/user_list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/detail/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/search/advanced_search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/search/basic_search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/search/queries/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/setting/contact/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/setting/faq/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/shop/checkout/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/status/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/detail/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/list/presenter.dart';
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
import 'package:mobile_sev2/use_cases/lobby/restore_room.dart';
import 'package:mobile_sev2/use_cases/lobby/set_as_read_stickit.dart';
import 'package:mobile_sev2/use_cases/lobby/store_list_reactions_to_db.dart';
import 'package:mobile_sev2/use_cases/lobby/store_list_user_db.dart';
import 'package:mobile_sev2/use_cases/lobby/update_status.dart';
import 'package:mobile_sev2/use_cases/lobby/work_on_task.dart';
import 'package:mobile_sev2/use_cases/mention/get_mentions.dart';
import 'package:mobile_sev2/use_cases/mood/get_moods.dart';
import 'package:mobile_sev2/use_cases/mood/send_mood.dart';
import 'package:mobile_sev2/use_cases/notification/create_notifications.dart';
import 'package:mobile_sev2/use_cases/notification/get_embraces.dart';
import 'package:mobile_sev2/use_cases/notification/get_notifications.dart';
import 'package:mobile_sev2/use_cases/notification/mark_all_read.dart';
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
import 'package:mobile_sev2/use_cases/user/get_suite_profile.dart';
import 'package:mobile_sev2/use_cases/user/get_user_contribution.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';
import 'package:mobile_sev2/use_cases/user/update_avatar.dart';
import 'package:mobile_sev2/use_cases/user/update_user.dart';
import 'package:mobile_sev2/use_cases/user/user_checkin.dart';
import 'package:mobile_sev2/use_cases/wiki/get_wikis.dart';

class PresenterModule {
  static void init(Injector injector) {
    injector.registerDependency<WorkspaceLoginPresenter>(() {
      return new WorkspaceLoginPresenter(
        injector.get<GetWorkspaceUseCase>(dependencyName: "get_workspace_db"),
      );
    });

    injector.registerDependency<PublicSpacePresenter>(() {
      return new PublicSpacePresenter(
        injector.get<GetWorkspaceUseCase>(dependencyName: "get_workspace_api"),
        injector.get<GetPublicSpaceUseCase>(
            dependencyName: "get_public_space_api"),
        injector.get<GetTokenUseCase>(dependencyName: "get_token_api"),
        injector.get<JoinWorkspaceUseCase>(
            dependencyName: 'join_workspace_api'),
      );
    });

    injector.registerDependency<PublicSpaceRoomPresenter>(() {
      return new PublicSpaceRoomPresenter(
        injector.get<GetMessagesPublicSpaceUseCase>(
            dependencyName: "get_messages_public_space_api"),
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_api"),
        injector.get<SendMessageUseCase>(dependencyName: "send_messages_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<SubscribeTopicUseCase>(
            dependencyName: "subscribe_topic_api"),
        injector.get<SubscribeTopicUseCase>(
            dependencyName: "subscribe_topic_db"),
        injector.get<UnsubscribeTopicUseCase>(
            dependencyName: "unsubscribe_topic_api"),
        injector.get<UnsubscribeTopicUseCase>(
            dependencyName: "unsubscribe_topic_db"),
        injector.get<GetSubscribeListUseCase>(
            dependencyName: "get_subscribe_list_db"),
        injector.get<GetFlagsUseCase>(dependencyName: "get_flags_api"),
      );
    });

    injector.registerDependency<WorkspaceListPresenter>(() {
      return new WorkspaceListPresenter(
        // injector.get<GetWorkspaceUseCase>(dependencyName: "get_workspace_db"),
        injector.get<GetWorkspaceUseCase>(dependencyName: "get_workspace_api"),
        injector.get<DeleteWorkspaceUseCase>(
            dependencyName: "delete_workspace_db"),
        injector.get<GetTokenUseCase>(dependencyName: "get_token_api"),
        injector.get<GetPublicSpaceUseCase>(
            dependencyName: "get_public_space_api"),
        injector.get<GetSubscribeListUseCase>(
            dependencyName: "get_subscribe_list_db"),
        injector.get<UnsubscribeTopicUseCase>(
            dependencyName: "unsubscribe_topic_api"),
        injector.get<UnsubscribeTopicUseCase>(
            dependencyName: "unsubscribe_topic_db"),
      );
    });

    injector.registerDependency<LoginPresenter>(() {
      return new LoginPresenter(
        injector.get<GetTokenUseCase>(dependencyName: "get_token_api"),
        injector.get<LoginUseCase>(dependencyName: "login_api"),
        injector.get<UpdateWorkspaceUseCase>(
            dependencyName: "update_workspace_db"),
        dotenv.env['GOOGLE_SIGN_IN_CLIENT_ID']!,
        dotenv.env['OAUTH_URI_SCHEME']!,
        dotenv.env['OAUTH_AUTH_URL']!,
        dotenv.env['OAUTH_TOKEN_URL']!,
        dotenv.env['OAUTH_GRANT_TYPE']!,
      );
    });

    injector.registerDependency<RegisterPresenter>(() {
      return new RegisterPresenter(
          injector.get<RegisterUseCase>(dependencyName: "register_api"));
    });

    injector.registerDependency<AppbarPresenter>(() {
      return new AppbarPresenter(injector.get<GetLobbyParticipantsUseCase>(
          dependencyName: "get_lobby_participants_api"));
    });

    injector.registerDependency<LobbyPresenter>(() {
      return new LobbyPresenter(
        injector.get<GetRoomHQUseCase>(dependencyName: "get_room_hq_api"),
        injector.get<GetLobbyRoomsUseCase>(
            dependencyName: "get_lobby_rooms_api"),
        injector.get<GetLobbyRoomsUseCase>(
            dependencyName: "get_lobby_rooms_db"),
        injector.get<GetLobbyParticipantsUseCase>(
            dependencyName: "get_lobby_participants_api"),
        injector.get<JoinLobbyChannelUseCase>(
            dependencyName: "join_lobby_channel_api"),
        injector.get<JoinLobbyUseCase>(dependencyName: "join_lobby_api"),
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_api"),
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_db"),
        injector.get<SendMessageUseCase>(dependencyName: "send_messages_db"),
        injector.get<RestoreRoomUseCase>(dependencyName: "restore_room_api"),
        injector.get<StoreListUserDbUseCase>(
            dependencyName: "store_list_user_db"),
        injector.get<CreateRoomUseCase>(dependencyName: "create_room_db"),
        injector.get<GetFlagsUseCase>(dependencyName: "get_flags_api"),
        injector.get<CreateFlagUseCase>(dependencyName: "create_flag_api"),
        injector.get<DeleteFlagUseCase>(dependencyName: "delete_flag_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<GetProfileUseCase>(dependencyName: "get_profile_api"),
        injector.get<GetCountriesUseCase>(dependencyName: "get_countries_api"),
      );
    });

    injector.registerDependency<LobbyRoomPresenter>(() {
      return new LobbyRoomPresenter(
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_api"),
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_db"),
        injector.get<SendMessageUseCase>(dependencyName: "send_messages_api"),
        injector.get<SendMessageUseCase>(dependencyName: "send_messages_db"),
        injector.get<DeleteMessageUseCase>(),
        injector.get<DeleteRoomUseCase>(dependencyName: "delete_room_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_db"),
        injector.get<GetLobbyRoomsUseCase>(
            dependencyName: "get_lobby_rooms_api"),
        injector.get<GetLobbyRoomStickitsUseCase>(
            dependencyName: "get_lobby_room_stickits_api"),
        injector.get<GetLobbyRoomCalendarUseCase>(
            dependencyName: "get_lobby_room_calendar_api"),
        injector.get<GetLobbyRoomFilesUseCase>(
            dependencyName: "get_lobby_room_files_api"),
        injector.get<GetLobbyRoomTicketsUseCase>(
            dependencyName: "get_lobby_room_tickets_api"),
        injector.get<CreateFileUseCase>(dependencyName: "create_file_api"),
        injector.get<PrepareCreateFileUseCase>(
            dependencyName: "prepare_files_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
        injector.get<AddRoomParticipantsUseCase>(
            dependencyName: "add_participants_api"),
        injector.get<GiveReactionUseCase>(dependencyName: "give_reaction_api"),
        injector.get<GetObjectReactionsUseCase>(
            dependencyName: "get_object_reactions_api"),
        injector.get<GetListUserDbUseCase>(dependencyName: "get_list_user_db"),
        injector.get<GetReactionsUseCase>(dependencyName: "get_reactions_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<GetEventsUseCase>(dependencyName: "get_events_api"),
        injector.get<GetFlagsUseCase>(dependencyName: "get_flags_api"),
      );
    });

    injector.registerDependency<RoomTicketPresenter>(() {
      return new RoomTicketPresenter(
        injector.get<GetLobbyRoomTicketsUseCase>(
            dependencyName: "get_lobby_room_tickets_api"),
      );
    });

    injector.registerDependency<RoomCalendarPresenter>(() {
      return new RoomCalendarPresenter(
        injector.get<GetLobbyRoomCalendarUseCase>(
            dependencyName: "get_lobby_room_calendar_api"),
      );
    });

    injector.registerDependency<RoomStickitPresenter>(() {
      return new RoomStickitPresenter(
        injector.get<GetLobbyRoomStickitsUseCase>(
            dependencyName: "get_lobby_room_stickits_api"),
        injector.get<SetAsReadStickitUseCase>(
            dependencyName: "set_as_read_stickit_api"),
      );
    });

    injector.registerDependency<RoomMemberPresenter>(() {
      return new RoomMemberPresenter(
        injector.get<GetLobbyParticipantsUseCase>(
            dependencyName: "get_lobby_participants_api"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
        injector.get<AddRoomParticipantsUseCase>(
            dependencyName: "add_participants_api"),
      );
    });

    injector.registerDependency<RoomFilePresenter>(() {
      return new RoomFilePresenter(
        injector.get<GetLobbyRoomFilesUseCase>(
            dependencyName: "get_lobby_room_files_api"),
        injector.get<CreateFileUseCase>(dependencyName: "create_file_api"),
        injector.get<PrepareCreateFileUseCase>(
            dependencyName: "prepare_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
      );
    });

    injector.registerDependency<BasicSearchPresenter>(() {
      return new BasicSearchPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_api"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<GetEventsUseCase>(dependencyName: "get_events_api"),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
        injector.get<JoinLobbyChannelUseCase>(
            dependencyName: "join_lobby_channel_api"),
        injector.get<GetSearchHistoryUseCase>(
            dependencyName: "get_search_history_db"),
        injector.get<AddSearchHistoryUseCase>(
            dependencyName: "add_search_history_db"),
        injector.get<DeleteSearchHistoryUseCase>(
            dependencyName: "delete_search_history_db"),
        injector.get<DeleteAllSearchHistoryUseCase>(
            dependencyName: "delete_all_search_history_db"),
      );
    });

    injector.registerDependency<AdvancedSearchPresenter>(() {
      return new AdvancedSearchPresenter(
          injector.get<AddQueryUseCase>(dependencyName: "add_query_db"));
    });

    injector.registerDependency<QueriesPresenter>(() {
      return new QueriesPresenter(
        injector.get<GetQueryUseCase>(dependencyName: "get_query_db"),
        injector.get<DeleteQueryUseCase>(dependencyName: "delete_query_db"),
      );
    });

    injector.registerDependency<CommentPresenter>(() {
      return new CommentPresenter();
    });

    injector.registerDependency<NotificationsPresenter>(() {
      return new NotificationsPresenter(
        injector.get<GetNotificationsUseCase>(
            dependencyName: "get_notifications_api"),
        injector.get<GetNotificationsUseCase>(
            dependencyName: "get_notifications_db"),
        injector.get<MarkNotificationsReadUseCase>(
            dependencyName: "mark_notifications_api"),
        injector.get<MarkNotificationsReadUseCase>(
            dependencyName: "mark_notifications_db"),
        injector.get<CreateNotificationUseCase>(
            dependencyName: "create_notification_db"),
        injector.get<GetEmbracesUseCase>(dependencyName: "get_embraces_api"),
        injector.get<GetFeedsUseCase>(dependencyName: "get_feeds_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_api"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
        injector.get<GetMentionsUseCase>(dependencyName: "get_mentions_api"),
        injector.get<GetEventsUseCase>(dependencyName: "get_events_api"),
      );
    });

    injector.registerDependency<ProfilePresenter>(() {
      return new ProfilePresenter(
        injector.get<GetProfileUseCase>(dependencyName: "get_profile_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
        injector.get<GetUserContributionsUseCase>(
            dependencyName: "get_user_contributions_api"),
        injector.get<GetFlagsUseCase>(dependencyName: "get_flags_api"),
        injector.get<DeleteFlagUseCase>(dependencyName: "delete_flag_api"),
      );
    });

    injector.registerDependency<ProfileEditPresenter>(() {
      return new ProfileEditPresenter(
        injector.get<UpdateUserUseCase>(dependencyName: "update_user_api"),
        injector.get<UpdateAvatarUserUseCase>(
            dependencyName: "update_avatar_user_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
      );
    });

    injector.registerDependency<ChatPresenter>(() {
      return new ChatPresenter(
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_api"),
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_db"),
        injector.get<SendMessageUseCase>(dependencyName: "send_messages_api"),
        injector.get<SendMessageUseCase>(dependencyName: "send_messages_db"),
        injector.get<DeleteMessageUseCase>(),
        injector.get<GiveReactionUseCase>(dependencyName: "give_reaction_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_db"),
        injector.get<CreateFileUseCase>(dependencyName: "create_file_api"),
        injector.get<PrepareCreateFileUseCase>(
            dependencyName: "prepare_files_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_db"),
        injector.get<DeleteRoomUseCase>(dependencyName: "delete_room_api"),
        injector.get<DeleteRoomUseCase>(dependencyName: "delete_room_db"),
        injector.get<GetListUserDbUseCase>(dependencyName: "get_list_user_db"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<GetEventsUseCase>(dependencyName: "get_events_api"),
      );
    });

    injector.registerDependency<CreateRoomPresenter>(() {
      return new CreateRoomPresenter(
        injector.get<CreateRoomUseCase>(dependencyName: "create_room_api"),
        injector.get<CreateRoomUseCase>(dependencyName: "create_room_db"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_api"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_db"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
      );
    });

    injector.registerDependency<UserListPresenter>(() {
      return new UserListPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_db"),
        injector.get<CreateRoomUseCase>(dependencyName: "create_room_api"),
        injector.get<CreateRoomUseCase>(dependencyName: "create_room_db"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_api"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_db"),
        injector.get<CreateUserUseCase>(dependencyName: "create_user_db"),
      );
    });

    injector.registerDependency<RoomDetailPresenter>(() {
      return new RoomDetailPresenter(
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_db"),
        injector.get<AddRoomParticipantsUseCase>(
            dependencyName: "add_participants_api"),
        injector.get<AddRoomParticipantsUseCase>(
            dependencyName: "add_participants_db"),
        injector.get<RemoveRoomParticipantsUseCase>(
            dependencyName: "remove_participants_api"),
        injector.get<RemoveRoomParticipantsUseCase>(
            dependencyName: "remove_participants_db"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_db"),
      );
    });

    injector.registerDependency<RoomsPresenter>(() {
      return new RoomsPresenter(
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_api"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_db"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_api"),
        injector.get<GetMessagesUseCase>(dependencyName: "get_messages_db"),
        injector.get<SendMessageUseCase>(dependencyName: "send_messages_db"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_db"),
        injector.get<CreateRoomUseCase>(dependencyName: "create_room_db"),
        injector.get<JoinLobbyChannelUseCase>(
            dependencyName: "join_lobby_channel_api"),
      );
    });

    injector.registerDependency<MainPresenter>(() {
      return new MainPresenter(
        injector.get<GetProfileUseCase>(dependencyName: "get_profile_api"),
        injector.get<GetProfileUseCase>(dependencyName: "get_profile_db"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_db"),
        injector.get<GetSuiteProfileUseCase>(
            dependencyName: "get_suite_profile_api"),
        injector.get<GetSuiteProfileUseCase>(
            dependencyName: "get_suite_profile_db"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_api"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_db"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
        injector.get<GetSettingUseCase>(dependencyName: "get_setting_db"),
        injector.get<UpdateSettingUseCase>(dependencyName: "update_setting_db"),
        injector.get<SubscribeTopicUseCase>(
            dependencyName: "subscribe_topic_api"),
        injector.get<SubscribeTopicUseCase>(
            dependencyName: "subscribe_topic_db"),
        injector.get<UnsubscribeTopicUseCase>(
            dependencyName: "unsubscribe_topic_api"),
        injector.get<UnsubscribeTopicUseCase>(
            dependencyName: "unsubscribe_topic_db"),
        injector.get<GetSubscribeListUseCase>(
            dependencyName: "get_subscribe_list_db"),
        injector.get<GetReactionsUseCase>(dependencyName: "get_reactions_api"),
        injector.get<StoreListReactionToDbUseCase>(
            dependencyName: "store_list_reaction_db"),
        injector.get<GetWorkspaceUseCase>(dependencyName: "get_workspace_api"),
        injector.get<GetTokenUseCase>(dependencyName: "get_token_api"),
        injector.get<GetPushNotificationUseCase>(
            dependencyName: "get_push_notification_db"),
        injector.get<StorePushNotificationUseCase>(
            dependencyName: "store_push_notification_db"),
        injector.get<DeletePushNotificationUseCase>(
            dependencyName: "delete_push_notification_db"),
        injector.get<UserCheckinUseCase>(dependencyName: "user_checkin_api"),
      );
    });

    injector.registerDependency<MemberPresenter>(() {
      return new MemberPresenter(
        injector.get<GetLobbyParticipantsUseCase>(
            dependencyName: "get_lobby_participants_api"),
      );
    });

    injector.registerDependency<StatusPresenter>(() {
      return new StatusPresenter(
        injector.get<GetProfileUseCase>(dependencyName: "get_profile_api"),
        injector.get<GetLobbyParticipantsUseCase>(
            dependencyName: "get_lobby_participants_api"),
        injector.get<GetLobbyStatusesUseCase>(
            dependencyName: "get_lobby_statuses_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<WorkOnTaskUseCase>(dependencyName: "work_on_task_api"),
        injector.get<UpdateStatusUseCase>(dependencyName: "update_status_api"),
        injector.get<GetSettingUseCase>(dependencyName: "get_setting_db"),
        injector.get<UpdateSettingUseCase>(dependencyName: "update_setting_db"),
      );
    });

    injector.registerDependency<DetailPresenter>(() {
      return new DetailPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetObjectTransactionsUseCase>(
            dependencyName: "get_object_transactions_api"),
        injector.get<GetObjectsUseCase>(dependencyName: "get_objects_api"),
        injector.get<JoinEventUseCase>(dependencyName: "join_event_api"),
        injector.get<GetTicketSubscribersUseCase>(
            dependencyName: "get_ticket_subscribers_api"),
        injector.get<CreateEventUseCase>(dependencyName: "create_event_api"),
        injector.get<CreateLobbyRoomStickitUseCase>(
            dependencyName: "create_lobby_room_stickit_api"),
        injector.get<CreateLobbyRoomTaskUseCase>(
            dependencyName: "create_lobby_room_task_api"),
        injector.get<GetProjectColumnsUseCase>(
            dependencyName: "get_project_columns_api"),
        injector.get<GiveReactionUseCase>(dependencyName: "give_reaction_api"),
        injector.get<GetObjectReactionsUseCase>(
            dependencyName: "get_object_reactions_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
        injector.get<SetProjectStatusUseCase>(
            dependencyName: "set_project_status_api"),
        injector.get<GetStickitsUseCase>(dependencyName: "get_stickits_api"),
        injector.get<GetEventsUseCase>(dependencyName: "get_events_api"),
        // injector.get<SetProjectStatusUseCase>(
        //     dependencyName: "set_project_status_api"),
      );
    });

    injector.registerDependency<ObjectSearchPresenter>(() {
      return new ObjectSearchPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
      );
    });

    injector.registerDependency<CreatePresenter>(() {
      return new CreatePresenter(
        injector.get<CreateEventUseCase>(dependencyName: "create_event_api"),
        injector.get<CreateLobbyRoomTaskUseCase>(
            dependencyName: "create_lobby_room_task_api"),
        injector.get<CreateLobbyRoomStickitUseCase>(
            dependencyName: "create_lobby_room_stickit_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetObjectsUseCase>(dependencyName: "get_objects_api"),
      );
    });

    injector.registerDependency<PolicyPresenter>(() {
      return new PolicyPresenter(
        injector.get<GetPoliciesUseCase>(dependencyName: "get_policies_api"),
        injector.get<GetSpacesUseCase>(dependencyName: "get_spaces_api"),
      );
    });

    injector.registerDependency<CustomPolicyPresenter>(() {
      return new CustomPolicyPresenter();
    });

    injector.registerDependency<TaskActionPresenter>(() {
      return new TaskActionPresenter(
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<TaskTransactionUseCase>(
            dependencyName: "remove_sub_task_api"),
      );
    });

    injector.registerDependency<SettingPresenter>(() {
      return new SettingPresenter(
        injector.get<UpdateUserUseCase>(dependencyName: "update_user_api"),
        injector.get<UserDeleteAccountUseCase>(
            dependencyName: "user_delete_account_api"),
      );
    });

    injector.registerDependency<ContactPresenter>(() {
      return new ContactPresenter();
    });

    injector.registerDependency<FaqPresenter>(() {
      return new FaqPresenter(
          injector.get<GetFaqsUseCase>(dependencyName: "get_faqs_api"));
    });

    injector.registerDependency<ProfileCalendarPresenter>(() {
      return new ProfileCalendarPresenter(
          injector.get<GetEventsUseCase>(dependencyName: "get_events_api"));
    });

    injector.registerDependency<MainCalendarPresenter>(() {
      return new MainCalendarPresenter(
          injector.get<GetEventsUseCase>(dependencyName: "get_events_api"));
    });

    injector.registerDependency<DailyMoodPresenter>(() {
      return new DailyMoodPresenter(
        injector.get<GetMoodsUseCase>(dependencyName: "get_moods_api"),
        injector.get<SendMoodUseCase>(dependencyName: "send_mood_api"),
      );
    });

    injector.registerDependency<SplashPresenter>(() {
      return new SplashPresenter(
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_api"),
        injector.get<GetRoomsUseCase>(dependencyName: "get_rooms_db"),
        injector.get<GetRoomParticipantsUseCase>(
            dependencyName: "get_participants_api"),
        // injector.get<GetWorkspaceUseCase>(dependencyName: "get_workspace_db"),
        injector.get<GetWorkspaceUseCase>(dependencyName: "get_workspace_api"),
        injector.get<UpdateWorkspaceUseCase>(
            dependencyName: "update_workspace_db"),
        injector.get<GetTokenUseCase>(dependencyName: "get_token_api"),
        injector.get<DeletePushNotificationUseCase>(
            dependencyName: "delete_push_notification_db"),
      );
    });

    injector.registerDependency<WorkboardPresenter>(() {
      return new WorkboardPresenter(
        injector.get<GetProjectColumnTicketUseCase>(
            dependencyName: "get_project_column_ticket_api"),
        injector.get<MoveTicketUseCase>(dependencyName: "move_ticket_api"),
        injector.get<EditColumnUseCase>(dependencyName: "edit_column_api"),
      );
    });

    injector.registerDependency<ColumnListPresenter>(() {
      return new ColumnListPresenter(
        injector.get<GetProjectColumnTicketUseCase>(
            dependencyName: "get_project_column_ticket_api"),
        injector.get<ReorderColumnUseCase>(
            dependencyName: "reorder_column_api"),
      );
    });

    injector.registerDependency<FormColumnPresenter>(() {
      return new FormColumnPresenter(
        injector.get<EditColumnUseCase>(dependencyName: "edit_column_api"),
        injector.get<CreateColumnUseCase>(dependencyName: "create_column_api"),
      );
    });

    injector.registerDependency<ProjectPresenter>(() {
      return new ProjectPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
      );
    });

    injector.registerDependency<CreateProjectPresenter>(() {
      return new CreateProjectPresenter(
        injector.get<CreateProjectUseCase>(
            dependencyName: "create_project_api"),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
        injector.get<CreateMilestoneUseCase>(
            dependencyName: "create_milestone_api"),
      );
    });

    injector.registerDependency<ProjectMemberPresenter>(() {
      return new ProjectMemberPresenter(
        injector.get<CreateProjectUseCase>(
            dependencyName: "create_project_api"),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
      );
    });

    injector.registerDependency<ProjectColumnSearchPresenter>(() {
      return new ProjectColumnSearchPresenter(
        injector.get<MoveTicketUseCase>(dependencyName: "move_ticket_api"),
        injector.get<GetProjectColumnTicketUseCase>(
            dependencyName: "get_project_column_ticket_api"),
      );
    });

    injector.registerDependency<DetailStickitPresenter>(() {
      return new DetailStickitPresenter(
        injector.get<GetStickitsUseCase>(dependencyName: "get_stickits_api"),
        injector.get<GetObjectTransactionsUseCase>(
            dependencyName: "get_object_transactions_api"),
        injector.get<GetObjectsUseCase>(dependencyName: "get_objects_api"),
        injector.get<GetObjectReactionsUseCase>(
            dependencyName: "get_object_reactions_api"),
        injector.get<GiveReactionUseCase>(dependencyName: "give_reaction_api"),
        injector.get<CreateLobbyRoomStickitUseCase>(
            dependencyName: "create_lobby_room_stickit_api"),
        injector.get<CreateFileUseCase>(dependencyName: "create_file_api"),
        injector.get<PrepareCreateFileUseCase>(
            dependencyName: "prepare_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_db"),
      );
    });

    injector.registerDependency<DetailEventPresenter>(() {
      return new DetailEventPresenter(
        injector.get<JoinEventUseCase>(dependencyName: "join_event_api"),
        injector.get<GetEventsUseCase>(dependencyName: "get_events_api"),
        injector.get<GetObjectTransactionsUseCase>(
            dependencyName: "get_object_transactions_api"),
        injector.get<GetObjectsUseCase>(dependencyName: "get_objects_api"),
        injector.get<CreateEventUseCase>(dependencyName: "create_event_api"),
        injector.get<GetObjectReactionsUseCase>(
            dependencyName: "get_object_reactions_api"),
        injector.get<GiveReactionUseCase>(dependencyName: "give_reaction_api"),
        injector.get<CreateFileUseCase>(dependencyName: "create_file_api"),
        injector.get<PrepareCreateFileUseCase>(
            dependencyName: "prepare_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_db"),
      );
    });

    injector.registerDependency<DetailTicketPresenter>(() {
      return new DetailTicketPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetObjectTransactionsUseCase>(
            dependencyName: "get_object_transactions_api"),
        injector.get<GetObjectsUseCase>(dependencyName: "get_objects_api"),
        injector.get<GetTicketSubscribersUseCase>(
            dependencyName: "get_ticket_subscribers_api"),
        injector.get<CreateLobbyRoomTaskUseCase>(
            dependencyName: "create_lobby_room_task_api"),
        injector.get<GiveReactionUseCase>(dependencyName: "give_reaction_api"),
        injector.get<GetObjectReactionsUseCase>(
            dependencyName: "get_object_reactions_api"),
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<CreateFileUseCase>(dependencyName: "create_file_api"),
        injector.get<PrepareCreateFileUseCase>(
            dependencyName: "prepare_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_api"),
        injector.get<GetFilesUseCase>(dependencyName: "get_files_db"),
        injector.get<GetProjectColumnTicketUseCase>(
            dependencyName: "get_project_column_ticket_api"),
      );
    });

    injector.registerDependency<EditMemberPresenter>(() {
      return new EditMemberPresenter(
        injector.get<CreateEventUseCase>(dependencyName: "create_event_api"),
      );
    });

    injector.registerDependency<SearchMemberPresenter>(() {
      return new SearchMemberPresenter(
        injector.get<CreateEventUseCase>(dependencyName: "create_event_api"),
      );
    });

    injector.registerDependency<DetailProjectPresenter>(() {
      return new DetailProjectPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetObjectTransactionsUseCase>(
            dependencyName: "get_object_transactions_api"),
        injector.get<GetObjectsUseCase>(dependencyName: "get_objects_api"),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
        injector.get<SetProjectStatusUseCase>(
          dependencyName: "set_project_status_api",
        ),
      );
    });

    injector.registerDependency<AddActionPresenter>(() {
      return new AddActionPresenter(
        injector.get<GetTicketsUseCase>(dependencyName: "get_tickets_api"),
        injector.get<GetProjectColumnTicketUseCase>(
          dependencyName: "get_project_column_ticket_api",
        ),
        injector.get<GetTicketProjectsUseCase>(
          dependencyName: "get_ticket_projects_api",
        ),
      );
    });

    injector.registerDependency<DetailActionPresenter>(() {
      return new DetailActionPresenter(
        injector.get<CreateLobbyRoomTaskUseCase>(
          dependencyName: "create_lobby_room_task_api",
        ),
        injector.get<GetTicketSubscribersUseCase>(
          dependencyName: "get_ticket_subscribers_api",
        ),
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
        injector.get<GetTicketProjectsUseCase>(
          dependencyName: "get_ticket_projects_api",
        ),
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
      );
    });

    injector.registerDependency<DetailChangeSubscriberPresenter>(() {
      return new DetailChangeSubscriberPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
      );
    });

    injector.registerDependency<DetailChangeAssigneePresenter>(() {
      return new DetailChangeAssigneePresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
      );
    });

    injector.registerDependency<DetailChangeProjectPresenter>(() {
      return new DetailChangeProjectPresenter(
        injector.get<GetProjectsUseCase>(dependencyName: "get_projects_api"),
      );
    });

    injector.registerDependency<ReportPresenter>(() {
      return new ReportPresenter(
        injector.get<CreateFlagUseCase>(dependencyName: "create_flag_api"),
      );
    });

    injector.registerDependency<ShopPresenter>(() {
      return new ShopPresenter();
    });

    injector.registerDependency<WikiListPresenter>(() {
      return new WikiListPresenter(
        injector.get<GetWikisUseCase>(dependencyName: "get_wikis_api"),
      );
    });

    injector.registerDependency<DetailWikiPresenter>(() {
      return new DetailWikiPresenter(
        injector.get<GetUsersUseCase>(dependencyName: "get_users_api"),
      );
    });
  }
}
