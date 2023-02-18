import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/domain/contribution.dart';
import 'package:mobile_sev2/domain/user.dart';

abstract class UserRepository {
  Future<List<User>> findAll(GetUsersRequestInterface params);
  Future<bool> create(CreateUserRequestInterface request);
  Future<bool> update(UpdateUserRequestInterface request);
  Future<bool> updateAvatar(UpdateAvatarUserRequestInterface request);
  Future<User> getProfile(GetProfileRequestInterface params);
  Future<User> getSuiteProfile(GetSuiteProfileRequestInterface params);
  Future<StoryPointInfo> getStoryPointInfo(GetStoryPointInfoRequestInterface params);
  Future<List<Contribution>> getuserContributions(GetUserContributionsRequestInterface params);
  Future<User> checkin(UserCheckinRequestInterface params);
  Future<bool> deleteAccount(UserDeleteAccountRequestInterface params);
}
