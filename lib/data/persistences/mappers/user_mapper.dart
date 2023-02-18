import 'package:basic_utils/basic_utils.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/contribution.dart';
import 'package:mobile_sev2/domain/user.dart';

class UserMapper {
  DateUtilInterface _dateUtil;

  UserMapper(this._dateUtil);

  List<User> convertGetUsersApiResponse(Map<String, dynamic> response) {
    var users = List<User>.empty(growable: true);
    var data = response['result']['data'];
    for (var user in data) {
      var registeredAt = _dateUtil.fromSeconds(user['fields']['dateCreated']);
      users.add(
        User(
          user['phid'],
          name: user['fields']['username'],
          fullName: user['fields']['realName'],
          registeredAt: registeredAt,
          availability: user['attachments']['availability']['value'],
          avatar: user['fields']['profileImageURI'],
          intId: user['id'],
          // used by refactory member
          workInfo: WorkInfo(registeredAt, "-"),
          roles: IterableUtils.isNullOrEmpty(user['fields']['roles'])
              ? []
              : (user['fields']['roles'] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList(),
          birthDate: (user['fields']['custom.birthdate'] != null)
              ? _dateUtil.fromSeconds(user['fields']['custom.birthdate'])
              : null,
          birthPlace: user['fields']['custom.birthplace'] ?? "",
          githubUrl: user['fields']['custom.github'] ?? "",
          stackoverflowUrl: user['fields']['custom.stackoverflow'] ?? "",
          hackerrankUrl: user['fields']['custom.hackerrank'] ?? "",
          duolingoUrl: user['fields']['custom.duolingo'] ?? "",
          linkedinUrl: user['fields']['custom.linkedin'] ?? "",
        ),
      );
    }
    return users;
  }

  User convertGetProfileApiResponse(Map<String, dynamic> response) {
    var data = response['result'];
    var state = data['state'];
    var lastCheckin = _dateUtil.fromSeconds(data['lastCheckin']);
    return User(
      data['phid'],
      name: data['userName'],
      fullName: data['realName'],
      avatar: data['image'],
      profileUrl: data['uri'],
      currentTask: state == null ? "" : data['state']['currentTask'],
      currentChannel: state == null ? "" : data['state']['currentChannel'],
      status: state == null ? "" : data['state']['status'],
      email: data['primaryEmail'] ?? "",
      phoneNumber: data['phoneNumber'] ?? "-",
      // currently, there is no data for this
      secondPhoneNumber: "-",
      roles: IterableUtils.isNullOrEmpty(data['roles'])
          ? []
          : (data['roles'] as List<dynamic>).map((e) => e.toString()).toList(),
      lastCheckin: lastCheckin,
    );
  }

  User convertGetSuiteProfileApiResponse(Map<String, dynamic> response) {
    var data = response['result'];
    if (data == null) {
      return User("");
    }

    return User(
      data['phid'],
      suiteId: data['phid'],
      fullName: data['realName'],
      isRSP: data['isRsp'],
      isOnboard: data['isOnboard'],
    );
  }

  StoryPointInfo convertGetStoryPointInfoApiResponse(
      Map<String, dynamic> response) {
    var data = response['result'];
    return StoryPointInfo(
      totalFinishedStoryPoints: double.parse(data['storyPoints'].toString()),
      totalIncome: data['amountWithdrawn'],
      totalWithdrawableIncome: data['amountBalance'],
    );
  }

  UserType getUserType(List<String> roles) {
    throw UnimplementedError();
  }

  List<Contribution> convertGetUserContributions(Map<String, dynamic> respons) {
    var contributions = List<Contribution>.empty(growable: true);

    var data = respons['result']['data'];
    if (data != null) {
      data.forEach((key, value) {
        contributions.add(Contribution(
            title: value['title'],
            level: value['level'],
            epoch: _dateUtil.fromSeconds(value['epoch']),
            seconds: value['seconds'],
            hours: value['hours']));
      });
    }
    return contributions;
  }

  User convertGetUserLastCheckin(Map<String, dynamic> response) {
    var data = response['result'];
    return User(
      data['phid'],
      lastCheckin: _dateUtil.fromSeconds(data['lastCheckin']),
    );
  }
}
