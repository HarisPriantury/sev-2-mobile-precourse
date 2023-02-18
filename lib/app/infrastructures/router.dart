import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/ui/assets/widget/account_created.dart';
import 'package:mobile_sev2/app/ui/assets/widget/login_error.dart';
import 'package:mobile_sev2/app/ui/assets/widget/error_page.dart';
import 'package:mobile_sev2/app/ui/pages/auth/login/view.dart';
import 'package:mobile_sev2/app/ui/pages/auth/on_board/view.dart';
import 'package:mobile_sev2/app/ui/pages/auth/register/view.dart';
import 'package:mobile_sev2/app/ui/pages/auth/splash/view.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/list/view.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/view.dart';
import 'package:mobile_sev2/app/ui/pages/calendar/view.dart';
import 'package:mobile_sev2/app/ui/pages/channel_setting/view.dart';
import 'package:mobile_sev2/app/ui/pages/create/custom_policy/view.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/view.dart';
import 'package:mobile_sev2/app/ui/pages/create/policy/view.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/view.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/add_action/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_assignee/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_project/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_subscriber/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_stickit/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/edit_member/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/search_member/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/column_list/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/form_column/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/project_column_search/view.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/calendar/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/member/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/stickit/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/ticket/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/chat/view.dart';
import 'package:mobile_sev2/app/ui/pages/create/daily_task_form/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/view.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/view.dart';
import 'package:mobile_sev2/app/ui/pages/main/view.dart';
import 'package:mobile_sev2/app/ui/pages/member/view.dart';
import 'package:mobile_sev2/app/ui/pages/notification/comment/view.dart';
import 'package:mobile_sev2/app/ui/pages/notification/list/view.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_calendar/view.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_edit/view.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/view.dart';
import 'package:mobile_sev2/app/ui/pages/project/create/view.dart';
import 'package:mobile_sev2/app/ui/pages/project/list/view.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/view.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/view.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/room/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/chat/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/user_list/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/detail/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/list/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/view.dart';
import 'package:mobile_sev2/app/ui/pages/search/advanced_search/view.dart';
import 'package:mobile_sev2/app/ui/pages/search/basic_search/view.dart';
import 'package:mobile_sev2/app/ui/pages/search/queries/view.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/view_account.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/view_datetime.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/view_email.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/view_language.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/view_notification.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/view_phone.dart';
import 'package:mobile_sev2/app/ui/pages/setting/contact/view.dart';
import 'package:mobile_sev2/app/ui/pages/setting/faq/view.dart';
import 'package:mobile_sev2/app/ui/pages/setting/appearance/view.dart';
import 'package:mobile_sev2/app/ui/pages/setting/support/chat/view.dart';
import 'package:mobile_sev2/app/ui/pages/setting/support/view.dart';
import 'package:mobile_sev2/app/ui/pages/shop/checkout/view.dart';
import 'package:mobile_sev2/app/ui/pages/shop/product/form/view.dart';
import 'package:mobile_sev2/app/ui/pages/status/view.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/detail/view.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/list/view.dart';

class Router {
  late RouteObserver<PageRoute> routeObserver;

  Router() {
    routeObserver = RouteObserver<PageRoute>();
  }

  Route<dynamic>? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.main:
        return _buildRoute(
            settings, new MainPage(arguments: settings.arguments));
      case Pages.onboard:
        return _buildRoute(
            settings, new OnBoardPage(arguments: settings.arguments));
      case Pages.splash:
        return _buildRoute(
            settings, new SplashPage(arguments: settings.arguments));
      case Pages.workspace:
        return _buildRoute(
            settings, new WorkspaceLoginPage(arguments: settings.arguments));
      case Pages.workspaceList:
        return _buildRoute(
            settings, new WorkspaceListPage(arguments: settings.arguments));
      case Pages.login:
        return _buildRoute(
            settings, new LoginPage(arguments: settings.arguments));
      case Pages.register:
        return _buildRoute(
            settings, new RegisterPage(arguments: settings.arguments));
      case Pages.loginError:
        return _buildRoute(settings, new LoginErrorPage());
      case Pages.errorPage:
        return _buildRoute(settings, new ErrorPage());
      case Pages.accountCreated:
        return _buildRoute(settings, new AccountCreatedPage());
      case Pages.notifications:
        return _buildRoute(
            settings, new NotificationsPage(arguments: settings.arguments));
      case Pages.mainCalendar:
        return _buildRoute(
            settings, new MainCalendarPage(arguments: settings.arguments));
      case Pages.lobby:
        return _buildRoute(
            settings, new LobbyPage(arguments: settings.arguments));
      case Pages.profile:
        return _buildRoute(
            settings, new ProfilePage(arguments: settings.arguments));
      case Pages.comment:
        return _buildRoute(
            settings, new CommentPage(arguments: settings.arguments));
      case Pages.chat:
        return _buildRoute(
            settings, new ChatPage(arguments: settings.arguments));
      case Pages.mediaDetail:
        return _buildRoute(
            settings, new MediaPage(arguments: settings.arguments));
      case Pages.createRoomForm:
        return _buildRoute(
            settings, new CreateRoomPage(arguments: settings.arguments));
      case Pages.createRoomUserList:
        return _buildRoute(
            settings, new UserListPage(arguments: settings.arguments));
      case Pages.roomDetail:
        return _buildRoute(
            settings, new RoomDetailPage(arguments: settings.arguments));
      case Pages.rooms:
        return _buildRoute(
            settings, new RoomsPage(arguments: settings.arguments));
      case Pages.lobbyRoom:
        return _buildRoute(
            settings, new LobbyRoomPage(arguments: settings.arguments));
      case Pages.roomTicket:
        return _buildRoute(
            settings, new RoomTicketPage(arguments: settings.arguments));
      case Pages.roomCalendar:
        return _buildRoute(
            settings, new RoomCalendarPage(arguments: settings.arguments));
      case Pages.roomMember:
        return _buildRoute(
            settings, new RoomMemberPage(arguments: settings.arguments));
      case Pages.roomFile:
        return _buildRoute(
            settings, new RoomFilePage(arguments: settings.arguments));
      case Pages.roomStickit:
        return _buildRoute(
            settings, new RoomStickitPage(arguments: settings.arguments));
      case Pages.roomChat:
        return _buildRoute(
            settings, new RoomChatPage(arguments: settings.arguments));
      case Pages.member:
        return _buildRoute(
            settings, new MemberPage(arguments: settings.arguments));
      case Pages.status:
        return _buildRoute(
            settings, new StatusPage(arguments: settings.arguments));
      case Pages.detail:
        return _buildRoute(
            settings, new DetailPage(arguments: settings.arguments));
      case Pages.basicSearch:
        return _buildRoute(
            settings, new BasicSearchPage(arguments: settings.arguments));
      case Pages.create:
        return _buildRoute(
            settings, new CreatePage(arguments: settings.arguments));
      case Pages.dailyTaskForm:
        return _buildRoute(
            settings, new DailyTaskForm(arguments: settings.arguments));
      case Pages.advancedSearch:
        return _buildRoute(
            settings, new AdvancedSearchPage(arguments: settings.arguments));
      case Pages.queries:
        return _buildRoute(
            settings, new QueriesPage(arguments: settings.arguments));
      case Pages.policy:
        return _buildRoute(
            settings, new PolicyPage(arguments: settings.arguments));
      case Pages.customPolicy:
        return _buildRoute(
            settings, new CustomPolicyPage(arguments: settings.arguments));
      case Pages.objectSearch:
        return _buildRoute(
            settings, new ObjectSearchPage(arguments: settings.arguments));
      case Pages.taskAction:
        return _buildRoute(
            settings, new TaskActionPage(arguments: settings.arguments));
      case Pages.setting:
        return _buildRoute(
            settings, new SettingPage(arguments: settings.arguments));
      case Pages.account:
        return _buildRoute(
            settings, new AccountPage(arguments: settings.arguments));
      case Pages.datetime:
        return _buildRoute(
            settings, new DateTimePage(arguments: settings.arguments));
      case Pages.language:
        return _buildRoute(
            settings, new LanguagePage(arguments: settings.arguments));
      case Pages.phone:
        return _buildRoute(
            settings, new PhonePage(arguments: settings.arguments));
      case Pages.email:
        return _buildRoute(
            settings, new EmailPage(arguments: settings.arguments));
      case Pages.notificationSetting:
        return _buildRoute(settings,
            new NotificationSettingPage(arguments: settings.arguments));
      case Pages.faq:
        return _buildRoute(
            settings, new FaqPage(arguments: settings.arguments));
      case Pages.appearance:
        return _buildRoute(settings, new AppearancePage());
      case Pages.faqDetail:
        return _buildRoute(
            settings, new FaqDetailPage(arguments: settings.arguments));
      case Pages.contact:
        return _buildRoute(
            settings, new ContactPage(arguments: settings.arguments));
      case Pages.profileEdit:
        return _buildRoute(
            settings, new ProfileEditPage(arguments: settings.arguments));
      case Pages.profileCalendar:
        return _buildRoute(
            settings, new ProfileCalendarPage(arguments: settings.arguments));
      case Pages.support:
        return _buildRoute(
            settings, new SupportPage(arguments: settings.arguments));
      case Pages.chatSupport:
        return _buildRoute(
            settings, new ChatSupportPage(arguments: settings.arguments));
      case Pages.publicSpace:
        return _buildRoute(
            settings, new PublicSpace(arguments: settings.arguments));
      case Pages.publicSpaceRoom:
        return _buildRoute(
            settings, new PublicSpaceRoom(arguments: settings.arguments));
      case Pages.workboard:
        return _buildRoute(
            settings, new WorkboardPage(arguments: settings.arguments));
      case Pages.formColumn:
        return _buildRoute(
            settings, new FormColumnPage(arguments: settings.arguments));
      case Pages.columnList:
        return _buildRoute(
            settings, new ColumnListPage(arguments: settings.arguments));
      case Pages.project:
        return _buildRoute(
            settings, new ProjectPage(arguments: settings.arguments));
      case Pages.createProject:
        return _buildRoute(
            settings, new CreateProjectPage(arguments: settings.arguments));
      case Pages.projectMember:
        return _buildRoute(
            settings, new ProjectMemberPage(arguments: settings.arguments));
      case Pages.projectColumnSearch:
        return _buildRoute(settings,
            new ProjectColumnSearchPage(arguments: settings.arguments));
      case Pages.stickitDetail:
        return _buildRoute(
            settings, new DetailStickitPage(arguments: settings.arguments));
      case Pages.eventDetail:
        return _buildRoute(
            settings, new DetailEventPage(arguments: settings.arguments));
      case Pages.ticketDetail:
        return _buildRoute(
            settings, new DetailTicketPage(arguments: settings.arguments));
      case Pages.editMember:
        return _buildRoute(
            settings, new EditMemberPage(arguments: settings.arguments));
      case Pages.searchMember:
        return _buildRoute(
            settings, new SearchMemberPage(arguments: settings.arguments));
      case Pages.projectDetail:
        return _buildRoute(
            settings, new DetailProjectPage(arguments: settings.arguments));
      case Pages.addAction:
        return _buildRoute(
            settings, new AddActionPage(arguments: settings.arguments));
      case Pages.detailAction:
        return _buildRoute(
            settings, new DetailActionPage(arguments: settings.arguments));
      case Pages.detailChangeSubscriber:
        return _buildRoute(settings,
            new DetailChangeSubscriberPage(arguments: settings.arguments));
      case Pages.detailChangeAssignee:
        return _buildRoute(settings,
            new DetailChangeAssigneePage(arguments: settings.arguments));
      case Pages.detailChangeProject:
        return _buildRoute(settings,
            new DetailChangeProjectPage(arguments: settings.arguments));
      case Pages.channelSetting:
        return _buildRoute(
            settings, new ChannelSetting(arguments: settings.arguments));
      case Pages.formAddProduct:
        return _buildRoute(
            settings, new FormAddProduct(arguments: settings.arguments));
      case Pages.shop:
        return _buildRoute(
            settings, new ShopPage(arguments: settings.arguments));
      case Pages.wikiList:
        return _buildRoute(settings, new WikiListPage());
      case Pages.detailWiki:
        return _buildRoute(
            settings, new DetailWikiPage(arguments: settings.arguments));
      default:
        return null;
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}
