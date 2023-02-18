import 'dart:convert';
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/data/payload/api/lobby/update_status_api_request.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/phobject.dart';

part 'user.g.dart';

@HiveType(typeId: 23)
class User extends PhObject {
  @HiveField(7)
  DateTime? registeredAt;

  @HiveField(8)
  String availability;

  @HiveField(9)
  String email;

  @HiveField(11)
  String profileUrl;

  @HiveField(12)
  UserType userType;

  @HiveField(13)
  String phoneNumber;

  @HiveField(14)
  String? secondPhoneNumber;

  @HiveField(15)
  String? suiteId;

  @HiveField(16)
  bool? isRSP;

  @HiveField(17)
  bool? isOnboard;

  @HiveField(18)
  String? userStatus;

  @HiveField(19)
  String? statusIcon;

  @HiveField(20)
  String? currentTask;

  @HiveField(21)
  String? device;

  @HiveField(22)
  bool? isWorking;

  @HiveField(23)
  String? currentChannel;

  // for connect
  @HiveField(24)
  ProjectsInfo? projectsInfo;

  @HiveField(25)
  HiringInfo? hiringInfo;

  // for RSP
  @HiveField(26)
  SubscriptionInfo? subscriptionInfo;

  @HiveField(27)
  StoryPointInfo? storyPointInfo;

  // for refactory member
  @HiveField(28)
  WorkInfo? workInfo;

  int? intId = 0;

  List<String> roles = [];

  DateTime? lastCheckin;

  DateTime? birthDate;

  String? birthPlace;

  String? githubUrl;

  String? stackoverflowUrl;

  String? hackerrankUrl;

  String? duolingoUrl;

  String? linkedinUrl;

  int? stackoverflowScore;

  int? hackkerrankScore;

  int? duolingoScore;

  int? typingSpeedScore;

  User(
    id, {
    this.registeredAt,
    this.availability = "",
    this.email = "",
    this.profileUrl = "",
    this.userType = UserType.suite,
    this.phoneNumber = "",
    this.suiteId = "",
    this.secondPhoneNumber,
    this.projectsInfo,
    this.hiringInfo,
    this.subscriptionInfo,
    this.storyPointInfo,
    this.workInfo,
    this.intId,
    this.isRSP = false,
    this.isOnboard = false,
    this.userStatus,
    this.statusIcon,
    this.currentTask,
    this.device,
    this.isWorking,
    this.currentChannel = "",
    this.roles = const [],
    this.lastCheckin,
    this.birthDate,
    this.birthPlace,
    this.githubUrl,
    this.stackoverflowUrl,
    this.hackerrankUrl,
    this.duolingoUrl,
    this.linkedinUrl,
    this.stackoverflowScore,
    this.hackkerrankScore,
    this.duolingoScore,
    this.typingSpeedScore,
    uri,
    typeName,
    type,
    name,
    fullName,
    status,
    avatar,
  }) : super(
          id,
          uri: uri,
          typeName: typeName,
          type: type,
          name: name,
          fullName: fullName,
          status: status,
          avatar: avatar,
        ) {
    this._setType();
    this._setSubscriptionInfo();
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'registered_at':
            registeredAt == null ? 0 : registeredAt?.millisecondsSinceEpoch,
        'availability': availability,
        'email': email,
        'avatar': avatar,
        'profile_url': profileUrl,
        'user_type': userType == UserType.connect
            ? 'connect'
            : userType == UserType.refactory
                ? 'refactory'
                : userType == UserType.suite
                    ? 'suite'
                    : 'rsp',
        'phone_number': phoneNumber,
        'suite_id': suiteId,
        'second_phone_number': secondPhoneNumber,
        'projects_info': jsonEncode(projectsInfo),
        'hiring_info': jsonEncode(hiringInfo),
        'subscription_info': jsonEncode(subscriptionInfo),
        'story_point_info': jsonEncode(storyPointInfo),
        'work_info': jsonEncode(workInfo),
        'is_rsp': isRSP,
        'is_onboard': isOnboard,
        'user_status': userStatus,
        'status_icon': statusIcon,
        'current_task': currentTask,
        'device': device,
        'is_working': isWorking,
        'current_channel': currentChannel,
        'name': name,
        'fullName': fullName,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
        'roles': roles,
        'lastCheckin': lastCheckin,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      registeredAt: DateTime.fromMillisecondsSinceEpoch(json['registered_at']),
      availability: json['availability'],
      email: json['email'],
      avatar: json['avatar'],
      profileUrl: json['profile_url'],
      userType: UserType.refactory,
      phoneNumber: json['phone_number'],
      // suiteId: json['suite_id'],
      secondPhoneNumber: json['second_phone_number'],
      // projectsInfo: jsonDecode(json['projects_info']),
      // hiringInfo: jsonDecode(json['hiring_info']),
      // subscriptionInfo: jsonDecode(json['subscription_info']),
      // storyPointInfo: jsonDecode(json['story_point_info']),
      // workInfo: jsonDecode(json['work_info']),
      // isRSP: json['is_rsp'],
      // isOnboard: json['is_onBoard'],
      userStatus: json['user_status'],
      statusIcon: json['status_icon'],
      currentTask: json['current_task'],
      // device: json['device'],
      // isWorking: json['is_working'],
      currentChannel: json['current_channel'],
      name: json['name'],
      fullName: json['fullName'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
      roles: json['roles'],
      lastCheckin: json['lastCheckin'],
    );
  }

  static String getName() {
    return 'user';
  }

  @override
  String? getFullName() {
    return this.fullName?.split('(').last.split(")").first;
  }

  Color? getStatusColor() {
    if (this.userStatus != null) {
      if (this.status == UpdateStatusApiRequest.STATUS_IN_LOBBY &&
          this.isWorking == false) {
        return ColorsItem.grey606060;
      } else if (this.status == UpdateStatusApiRequest.STATUS_IN_CHANNEL) {
        return ColorsItem.green219653;
      } else if (this.status == UpdateStatusApiRequest.STATUS_IN_LOBBY) {
        return ColorsItem.green219653;
      } else {
        return ColorsItem.orangeFB9600;
      }
    }
  }

  UserType _setType() {
    if (this.email.endsWith("@refactory.id")) {
      userType = UserType.refactory;
    } else if (isRSP == true) {
      userType = UserType.rsp;
    } else {
      userType = UserType.connect;
    }

    return userType;
  }

  SubscriptionInfo? _setSubscriptionInfo() {
    var regAt = registeredAt;
    if (regAt == null) regAt = DateTime.now();

    subscriptionInfo = SubscriptionInfo(
        SubscriptionStatus.active, regAt.add(Duration(days: 90)));
    return subscriptionInfo;
  }

  @override
  User clone() {
    return User(
      this.id,
      registeredAt: this.registeredAt,
      availability: this.availability,
      email: this.email,
      avatar: this.avatar,
      profileUrl: this.profileUrl,
      userType: this.userType,
      phoneNumber: this.phoneNumber,
      suiteId: this.suiteId,
      secondPhoneNumber: this.secondPhoneNumber,
      projectsInfo: this.projectsInfo,
      hiringInfo: this.hiringInfo,
      subscriptionInfo: this.subscriptionInfo,
      storyPointInfo: this.storyPointInfo,
      workInfo: this.workInfo,
      isRSP: this.isRSP,
      isOnboard: this.isOnboard,
      userStatus: this.userStatus,
      statusIcon: this.statusIcon,
      currentTask: this.currentTask,
      device: this.device,
      isWorking: this.isWorking,
      currentChannel: this.currentChannel,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
      roles: this.roles,
      lastCheckin: this.lastCheckin,
    );
  }
}

// used by connect user, summary of all project
@HiveType(typeId: 24)
class ProjectsInfo extends BaseDomain {
  @HiveField(0)
  int totalProjects = 0;

  @HiveField(1)
  double totalStoryPoints = 0;

  @HiveField(2)
  double totalFinishedStoryPoints = 0;

  @HiveField(3)
  int totalDepositStoryPoints = 0;

  ProjectsInfo(
      {this.totalProjects = 0,
      this.totalStoryPoints = 0,
      this.totalFinishedStoryPoints = 0,
      this.totalDepositStoryPoints = 0});

  @override
  Map<String, dynamic> toJson() => {
        'total_projects': totalProjects,
        'total_story_points': totalStoryPoints,
        'total_finished_story_points': totalFinishedStoryPoints,
        'total_deposit_story_points': totalDepositStoryPoints
      };

  factory ProjectsInfo.fromJson(Map<String, dynamic> json) {
    return ProjectsInfo(
        totalProjects: json['total_projects'],
        totalStoryPoints: json['total_story_points'],
        totalFinishedStoryPoints: json['total_finished_story_points'],
        totalDepositStoryPoints: json['total_deposit_story_points']);
  }

  static String getName() {
    return 'project_info';
  }

  @override
  ProjectsInfo clone() {
    return ProjectsInfo(
        totalProjects: this.totalProjects,
        totalStoryPoints: this.totalStoryPoints,
        totalFinishedStoryPoints: this.totalFinishedStoryPoints,
        totalDepositStoryPoints: this.totalDepositStoryPoints);
  }
}

@HiveType(typeId: 25)
class SubscriptionInfo extends BaseDomain {
  @HiveField(0)
  SubscriptionStatus status;

  @HiveField(1)
  DateTime expiredDate;

  SubscriptionInfo(this.status, this.expiredDate);

  @override
  Map<String, dynamic> toJson() => {
        'status': status == SubscriptionStatus.active
            ? 'active'
            : status == SubscriptionStatus.preparation
                ? 'preparation'
                : 'expired',
        'expired_date': expiredDate.millisecondsSinceEpoch,
      };

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
        json['status'] == 'active'
            ? SubscriptionStatus.active
            : json['status'] == 'preparation'
                ? SubscriptionStatus.preparation
                : SubscriptionStatus.expired,
        DateTime.fromMillisecondsSinceEpoch(json['expired_at']));
  }

  static String getName() {
    return 'subscription_info';
  }

  @override
  SubscriptionInfo clone() {
    return SubscriptionInfo(this.status, this.expiredDate);
  }
}

@HiveType(typeId: 26)
class StoryPointInfo extends BaseDomain {
  @HiveField(0)
  double? totalFinishedStoryPoints = 0;

  @HiveField(1)
  String? totalIncome = "0";

  @HiveField(2)
  String? totalWithdrawableIncome = "0";

  StoryPointInfo(
      {this.totalFinishedStoryPoints,
      this.totalIncome,
      this.totalWithdrawableIncome});

  @override
  Map<String, dynamic> toJson() => {
        'total_finished_story_points': totalFinishedStoryPoints,
        'total_income': totalIncome,
        'total_withdrawal_income': totalWithdrawableIncome
      };

  factory StoryPointInfo.fromJson(Map<String, dynamic> json) {
    return StoryPointInfo(
        totalFinishedStoryPoints: json['total_finished_story_points'],
        totalIncome: json['total_income'],
        totalWithdrawableIncome: json['total_withdrawal_income']);
  }

  static String getName() {
    return 'story_point_info';
  }

  @override
  StoryPointInfo clone() {
    return StoryPointInfo(
        totalFinishedStoryPoints: this.totalFinishedStoryPoints,
        totalIncome: this.totalIncome,
        totalWithdrawableIncome: this.totalWithdrawableIncome);
  }
}

// used by connect user
@HiveType(typeId: 27)
class HiringInfo extends BaseDomain {
  @HiveField(0)
  int? totalJobs = 0;

  @HiveField(1)
  int? totalHired = 0;

  HiringInfo(this.totalJobs, this.totalHired);

  Map<String, dynamic> toJson() =>
      {'total_jobs': totalJobs, 'total_hired': totalHired};

  factory HiringInfo.fromJson(Map<String, dynamic> json) {
    return HiringInfo(json['total_jobs'], json['total_hired']);
  }

  static String getName() {
    return 'hiring_info';
  }

  @override
  HiringInfo clone() {
    return HiringInfo(this.totalJobs, this.totalHired);
  }
}

@HiveType(typeId: 28)
class WorkInfo extends BaseDomain {
  @HiveField(0)
  DateTime joinedDate;

  @HiveField(1)
  String occupation;

  WorkInfo(this.joinedDate, this.occupation);

  @override
  Map<String, dynamic> toJson() => {
        'joined_date': joinedDate.millisecondsSinceEpoch,
        'occupation': occupation
      };

  factory WorkInfo.fromJson(Map<String, dynamic> json) {
    return WorkInfo(DateTime.fromMillisecondsSinceEpoch(json['joined_date']),
        json['occupation']);
  }

  static String getName() {
    return 'work_info';
  }

  @override
  WorkInfo clone() {
    return WorkInfo(this.joinedDate, this.occupation);
  }
}

@HiveType(typeId: 29)
enum UserType {
  @HiveField(0)
  connect,
  @HiveField(1)
  refactory,
  @HiveField(2)
  suite,
  @HiveField(3)
  rsp
}

@HiveType(typeId: 30)
enum SubscriptionStatus {
  @HiveField(0)
  preparation,
  @HiveField(1)
  active,
  @HiveField(2)
  expired
}
