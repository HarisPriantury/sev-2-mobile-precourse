import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/user/create_user_db_request.dart';
import 'package:mobile_sev2/data/payload/db/user/get_profile_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/user_repository_interface.dart';
import 'package:mobile_sev2/domain/contribution.dart';
import 'package:mobile_sev2/domain/user.dart';

class UserDBRepository implements UserRepository {
  Box<User> _userBox;
  Box<StoryPointInfo> _spBox;

  UserDBRepository(this._userBox, this._spBox);

  @override
  Future<List<User>> findAll(GetUsersRequestInterface params) {
    var users = _userBox.values.toList();
    return Future.value(users);
  }

  @override
  Future<User> getProfile(GetProfileRequestInterface params) {
    var profile = _userBox.get((params as GetProfileDBRequest).userId);
    return Future.value(profile);
  }

  @override
  Future<StoryPointInfo> getStoryPointInfo(
      GetStoryPointInfoRequestInterface params) {
    var sp = _spBox.get(StoryPointInfo.getName());
    return Future.value(sp);
  }

  @override
  Future<User> getSuiteProfile(GetSuiteProfileRequestInterface params) {
    throw UnimplementedError();
  }

  @override
  Future<bool> create(CreateUserRequestInterface request) {
    var params = request as CreateUserDBRequest;
    _userBox.put(params.user.id, params.user);
    return Future.value(true);
  }

  @override
  Future<bool> update(UpdateUserRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> updateAvatar(UpdateAvatarUserRequestInterface request) {
    // TODO: implement updateAvatar
    throw UnimplementedError();
  }

  @override
  Future<List<Contribution>> getuserContributions(
      GetUserContributionsRequestInterface params) {
    // TODO: implement getuserContribution
    throw UnimplementedError();
  }

  @override
  Future<User> checkin(UserCheckinRequestInterface params) {
    // TODO: implement checkin
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteAccount(UserDeleteAccountRequestInterface params) {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }
}
