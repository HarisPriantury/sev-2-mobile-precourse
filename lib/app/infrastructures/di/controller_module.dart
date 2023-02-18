import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:injector/injector.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base64encoder.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/downloader.dart';
import 'package:mobile_sev2/app/infrastructures/misc/file_picker.dart';
import 'package:mobile_sev2/app/infrastructures/misc/ringtone_player.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/signaling.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/websocket.dart';
import 'package:mobile_sev2/app/ui/pages/appbar/controller.dart';
import 'package:mobile_sev2/app/ui/pages/appbar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/controller.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/on_board/controller.dart';
import 'package:mobile_sev2/app/ui/pages/auth/register/controller.dart';
import 'package:mobile_sev2/app/ui/pages/auth/register/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/splash/controller.dart';
import 'package:mobile_sev2/app/ui/pages/auth/splash/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/controller.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/calendar/controller.dart';
import 'package:mobile_sev2/app/ui/pages/calendar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/custom_policy/controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/daily_task_form/controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/daily_mood/controller.dart';
import 'package:mobile_sev2/app/ui/pages/daily_mood/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/add_action/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/add_action/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_assignee/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_assignee/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_project/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_project/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_subscriber/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_subscriber/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_stickit/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_stickit/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/edit_member/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/edit_member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/search_member/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/search_member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/column_list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/column_list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/form_column/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/form_column/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/calendar/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/calendar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/member/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/stickit/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/stickit/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/ticket/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/ticket/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/controller.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/main/controller.dart';
import 'package:mobile_sev2/app/ui/pages/main/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/member/controller.dart';
import 'package:mobile_sev2/app/ui/pages/member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/notification/comment/controller.dart';
import 'package:mobile_sev2/app/ui/pages/notification/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/notification/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_calendar/controller.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_calendar/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_edit/controller.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_edit/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/controller.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/controller.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/project/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/project/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/controller.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/controller.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/controller.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/user_list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/user_list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/detail/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/detail/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/list/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/controller.dart';
import 'package:mobile_sev2/app/ui/pages/search/advanced_search/controller.dart';
import 'package:mobile_sev2/app/ui/pages/search/advanced_search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/search/basic_search/controller.dart';
import 'package:mobile_sev2/app/ui/pages/search/basic_search/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/search/queries/controller.dart';
import 'package:mobile_sev2/app/ui/pages/search/queries/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/controller.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/setting/appearance/controller.dart';
import 'package:mobile_sev2/app/ui/pages/setting/contact/controller.dart';
import 'package:mobile_sev2/app/ui/pages/setting/faq/controller.dart';
import 'package:mobile_sev2/app/ui/pages/setting/faq/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/setting/support/chat/controller.dart';
import 'package:mobile_sev2/app/ui/pages/setting/support/controller.dart';
import 'package:mobile_sev2/app/ui/pages/shop/checkout/controller.dart';
import 'package:mobile_sev2/app/ui/pages/shop/checkout/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/shop/product/form/controller.dart';
import 'package:mobile_sev2/app/ui/pages/status/controller.dart';
import 'package:mobile_sev2/app/ui/pages/status/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/detail/controller.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/detail/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/list/presenter.dart';
import 'package:mobile_sev2/domain/meta/status_history.dart';
import 'package:mobile_sev2/domain/meta/unread_chat.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mobile_sev2/app/ui/pages/channel_setting/controller.dart';

class ControllerModule {
  static void init(Injector injector) {
    injector.registerDependency<SplashController>(() {
      return new SplashController(
        injector.get<SplashPresenter>(),
        injector.get<UserData>(),
        injector.get<EventBus>(),
        injector.get<FlutterLocalNotificationsPlugin>(),
      );
    });

    injector.registerDependency<OnBoardController>(() {
      return new OnBoardController();
    });

    injector.registerDependency<WorkspaceLoginController>(() {
      return new WorkspaceLoginController(
        injector.get<WorkspaceLoginPresenter>(),
        injector.get<DateUtil>(),
        injector.get<Dio>(dependencyName: "dio_check_connection"),
      );
    });

    injector.registerDependency<WorkspaceListController>(() {
      return new WorkspaceListController(
        injector.get<WorkspaceListPresenter>(),
        injector.get<EventBus>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<LoginController>(() {
      return new LoginController(
        injector.get<LoginPresenter>(),
        injector.get<EventBus>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<FirebaseAnalytics>(),
      );
    });

    injector.registerDependency<RegisterController>(() {
      return new RegisterController(injector.get<RegisterPresenter>());
    });

    injector.registerDependency<MainController>(() {
      return new MainController(
        injector.get<MainPresenter>(),
        injector.get<UserData>(),
        injector.get<EventBus>(),
        injector.get<DateUtil>(),
        injector.get<WebSocketDashboardClient>(
            dependencyName: "dashboard_websocket"),
        injector.get<FlutterLocalNotificationsPlugin>(),
        injector.get<Workmanager>(),
      );
    });

    injector.registerDependency<AppbarController>(() {
      return new AppbarController(
        injector.get<AppbarPresenter>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<LobbyController>(() {
      return new LobbyController(
        injector.get<LobbyPresenter>(),
        injector.get<UserData>(),
        injector.get<WebSocketDashboardClient>(
            dependencyName: "dashboard_websocket"),
        injector.get<EventBus>(),
        injector.get<DateUtil>(),
      );
    });

    injector.registerDependency<DailyTaskFormController>(() {
      return new DailyTaskFormController();
    });

    injector.registerDependency<LobbyRoomController>(() {
      return new LobbyRoomController(
        injector.get<LobbyRoomPresenter>(),
        injector.get<Downloader>(),
        injector.get<EventBus>(),
        injector.get<FilesPicker>(),
        injector.get<Base64Encoder>(),
        injector.get<Signaling>(dependencyName: "room_signaling"),
        injector.get<RingtonePlayer>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<Box<UnreadChat>>(),
        injector.get<List<Reaction>>(dependencyName: "reaction_list"),
        // injector.get<WebSocketDashboardClient>(dependencyName: "dashboard_websocket"),
        injector.get<List<User>>(dependencyName: 'user_list'),
      );
    });

    injector.registerDependency<RoomTicketController>(() {
      return new RoomTicketController(
        injector.get<RoomTicketPresenter>(),
      );
    });

    injector.registerDependency<RoomCalendarController>(() {
      return new RoomCalendarController(
        injector.get<RoomCalendarPresenter>(),
      );
    });

    injector.registerDependency<RoomStickitController>(() {
      return new RoomStickitController(
        injector.get<RoomStickitPresenter>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<RoomMemberController>(() {
      return new RoomMemberController(
        injector.get<RoomMemberPresenter>(),
      );
    });

    injector.registerDependency<RoomFileController>(() {
      return new RoomFileController(
        injector.get<RoomFilePresenter>(),
        injector.get<Downloader>(),
        injector.get<FilesPicker>(),
        injector.get<Base64Encoder>(),
        injector.get<DateUtil>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<BasicSearchController>(() {
      return new BasicSearchController(
        injector.get<BasicSearchPresenter>(),
        injector.get<DateUtil>(),
        injector.get<UserData>(),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<AdvancedSearchController>(() {
      return new AdvancedSearchController(
        injector.get<AdvancedSearchPresenter>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<QueriesController>(() {
      return new QueriesController(
        injector.get<QueriesPresenter>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<CommentController>(() {
      return new CommentController();
    });

    injector.registerDependency<NotificationsController>(() {
      return new NotificationsController(
        injector.get<NotificationsPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<List<User>>(dependencyName: 'user_list'),
      );
    });

    injector.registerDependency<ProfileController>(() {
      return new ProfileController(
        injector.get<ProfilePresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<ProfileEditController>(() {
      return new ProfileEditController(
        injector.get<ProfileEditPresenter>(),
        injector.get<UserData>(),
        injector.get<EventBus>(),
        injector.get<FilesPicker>(),
        injector.get<Base64Encoder>(),
        injector.get<DateUtil>(),
      );
    });

    // room
    injector.registerDependency<RoomsController>(() {
      return new RoomsController(
        injector.get<RoomsPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<EventBus>(),
        injector.get<Box<UnreadChat>>(),
        // injector.get<WebSocketDashboardClient>(dependencyName: "dashboard_websocket"),
      );
    });

    injector.registerDependency<ChatController>(() {
      return new ChatController(
        injector.get<ChatPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<FilesPicker>(),
        injector.get<Base64Encoder>(),
        injector.get<EventBus>(),
        injector.get<Downloader>(),
        injector.get<Box<UnreadChat>>(),
        injector.get<Signaling>(dependencyName: "room_signaling"),
        // injector.get<WebSocketDashboardClient>(dependencyName: "dashboard_websocket"),
        injector.get<List<User>>(dependencyName: 'user_list'),
      );
    });

    injector.registerDependency<RoomDetailController>(() {
      return new RoomDetailController(
        injector.get<RoomDetailPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<Downloader>(),
      );
    });

    injector.registerDependency<CreateRoomController>(() {
      return new CreateRoomController(
        injector.get<CreateRoomPresenter>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<UserListController>(() {
      return new UserListController(
        injector.get<UserListPresenter>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<MemberController>(() {
      return new MemberController(injector.get<MemberPresenter>());
    });

    injector.registerDependency<StatusController>(() {
      return new StatusController(
        injector.get<StatusPresenter>(),
        injector.get<UserData>(),
        injector.get<Box<StatusHistory>>(),
        injector.get<DateUtil>(),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<DetailController>(() {
      return new DetailController(
        injector.get<DetailPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<List<User>>(dependencyName: 'user_list'),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<ObjectSearchController>(() {
      return new ObjectSearchController(injector.get<ObjectSearchPresenter>());
    });

    injector.registerDependency<CreateController>(() {
      return new CreateController(
        injector.get<CreatePresenter>(),
        injector.get<DateUtil>(),
        injector.get<EventBus>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<PolicyController>(() {
      return new PolicyController(injector.get<PolicyPresenter>());
    });

    injector.registerDependency<CustomPolicyController>(() {
      return new CustomPolicyController();
    });

    injector.registerDependency<TaskActionController>(() {
      return new TaskActionController(
        injector.get<TaskActionPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
      );
    });

    injector.registerDependency<SettingController>(() {
      return new SettingController(
        injector.get<SettingPresenter>(),
        injector.get<UserData>(),
        injector.get<EventBus>(),
        injector.get<Box<Phone>>(),
        injector.get<Box<Email>>(),
        injector.get<DateUtil>(),
      );
    });

    injector.registerDependency<ContactController>(() {
      return new ContactController();
    });

    injector.registerDependency<AppearanceController>(() {
      return new AppearanceController(injector.get<UserData>());
    });

    injector.registerDependency<FaqController>(() {
      return new FaqController(
        injector.get<FaqPresenter>(),
        injector.get<DateUtil>(),
      );
    });

    injector.registerDependency<ProfileCalendarController>(() {
      return new ProfileCalendarController(
        injector.get<ProfileCalendarPresenter>(),
        injector.get<DateUtil>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<MainCalendarController>(() {
      return new MainCalendarController(
        injector.get<MainCalendarPresenter>(),
        injector.get<DateUtil>(),
        injector.get<UserData>(),
      );
    });

    injector.registerDependency<ShopController>(() {
      return new ShopController(
        injector.get<ShopPresenter>(),
      );
    });

    injector.registerDependency<MediaController>(() {
      return new MediaController();
    });

    injector.registerDependency<DailyMoodController>(() {
      return new DailyMoodController(
        injector.get<UserData>(),
        injector.get<DailyMoodPresenter>(),
        injector.get<DateUtil>(),
      );
    });

    injector.registerDependency<SupportController>(() {
      return new SupportController();
    });

    injector.registerDependency<ChatSupportController>(() {
      return new ChatSupportController();
    });

    injector.registerDependency<PublicSpaceController>(() {
      return new PublicSpaceController(
        injector.get<DateUtil>(),
        injector.get<UserData>(),
        injector.get<PublicSpacePresenter>(),
      );
    });

    injector.registerDependency<PublicSpaceRoomController>(() {
      return new PublicSpaceRoomController(
        injector.get<DateUtil>(),
        injector.get<UserData>(),
        injector.get<EventBus>(),
        injector.get<PublicSpaceRoomPresenter>(),
      );
    });

    injector.registerDependency<WorkboardController>(() {
      return new WorkboardController(
        injector.get<WorkboardPresenter>(),
        injector.get<UserData>(),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<ColumnListController>(() {
      return new ColumnListController(
        injector.get<ColumnListPresenter>(),
      );
    });

    injector.registerDependency<FormColumnController>(() {
      return new FormColumnController(
        injector.get<FormColumnPresenter>(),
      );
    });
    injector.registerDependency<ProjectController>(() {
      return new ProjectController(
        injector.get<ProjectPresenter>(),
        injector.get<UserData>(),
        injector.get<EventBus>(),
      );
    });
    injector.registerDependency<CreateProjectController>(() {
      return new CreateProjectController(
        injector.get<CreateProjectPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<EventBus>(),
      );
    });
    injector.registerDependency<ProjectMemberController>(() {
      return new ProjectMemberController(
        injector.get<ProjectMemberPresenter>(),
        injector.get<List<User>>(dependencyName: 'user_list'),
        injector.get<EventBus>(),
      );
    });
    injector.registerDependency<ProjectColumnSearchController>(() {
      return new ProjectColumnSearchController(
        injector.get<ProjectColumnSearchPresenter>(),
      );
    });
    injector.registerDependency<DetailStickitController>(() {
      return new DetailStickitController(
        injector.get<DetailStickitPresenter>(),
        injector.get<DateUtil>(),
        injector.get<List<User>>(dependencyName: 'user_list'),
        injector.get<FilesPicker>(),
        injector.get<Base64Encoder>(),
        injector.get<Downloader>(),
      );
    });
    injector.registerDependency<DetailEventController>(() {
      return new DetailEventController(
        injector.get<DetailEventPresenter>(),
        injector.get<DateUtil>(),
        injector.get<UserData>(),
        injector.get<List<User>>(dependencyName: 'user_list'),
        injector.get<FilesPicker>(),
        injector.get<Base64Encoder>(),
        injector.get<Downloader>(),
      );
    });

    injector.registerDependency<DetailTicketController>(() {
      return new DetailTicketController(
        injector.get<DetailTicketPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<List<User>>(dependencyName: 'user_list'),
        injector.get<EventBus>(),
        injector.get<FilesPicker>(),
        injector.get<Base64Encoder>(),
        injector.get<Downloader>(),
      );
    });

    injector.registerDependency<EditMemberController>(() {
      return new EditMemberController(
        injector.get<EditMemberPresenter>(),
      );
    });
    injector.registerDependency<SearchMemberController>(() {
      return new SearchMemberController(
        injector.get<SearchMemberPresenter>(),
      );
    });

    injector.registerDependency<DetailProjectController>(() {
      return new DetailProjectController(
        injector.get<DetailProjectPresenter>(),
        injector.get<UserData>(),
        injector.get<DateUtil>(),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<AddActionController>(() {
      return new AddActionController(
        injector.get<AddActionPresenter>(),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<DetailActionController>(() {
      return new DetailActionController(
        injector.get<DetailActionPresenter>(),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<DetailChangeSubscriberController>(() {
      return new DetailChangeSubscriberController(
        injector.get<DetailChangeSubscriberPresenter>(),
      );
    });

    injector.registerDependency<DetailChangeAssigneeControler>(() {
      return new DetailChangeAssigneeControler(
        injector.get<DetailChangeAssigneePresenter>(),
      );
    });

    injector.registerDependency<DetailChangeProjectController>(() {
      return new DetailChangeProjectController(
        injector.get<DetailChangeProjectPresenter>(),
      );
    });

    injector.registerDependency<ReportController>(() {
      return new ReportController(
        injector.get<ReportPresenter>(),
        injector.get<EventBus>(),
      );
    });

    injector.registerDependency<ChannelSettingController>(
        () => new ChannelSettingController());

    injector.registerDependency<FormAddProductController>(
        () => new FormAddProductController());

    injector.registerDependency<WikiListController>(() {
      return new WikiListController(
        injector.get<WikiListPresenter>(),
        injector.get<DateUtil>(),
      );
    });

    injector.registerDependency<DetailWikiController>(
      () => new DetailWikiController(
        injector.get<DetailWikiPresenter>(),
      ),
    );
  }
}
