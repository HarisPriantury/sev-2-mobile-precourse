import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/user_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/user_repository_interface.dart';
import 'package:mobile_sev2/domain/contribution.dart';
import 'package:mobile_sev2/domain/user.dart';

class UserApiRepository implements UserRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  UserMapper _mapper;

  UserApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<User>> findAll(GetUsersRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.users(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetUsersApiResponse(resp);
  }

  @override
  Future<User> getProfile(GetProfileRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.profile(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetProfileApiResponse(resp);
  }

  @override
  Future<StoryPointInfo> getStoryPointInfo(
      GetStoryPointInfoRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.storyPoint(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetStoryPointInfoApiResponse(resp);
  }

  @override
  Future<User> getSuiteProfile(GetSuiteProfileRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.suiteProfile(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetSuiteProfileApiResponse(resp);
  }

  @override
  Future<bool> create(CreateUserRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<bool> update(UpdateUserRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.editUser(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> updateAvatar(UpdateAvatarUserRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.editAvatarUser(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<List<Contribution>> getuserContributions(
      GetUserContributionsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.getUserContributions(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetUserContributions(resp);
  }

  @override
  Future<User> checkin(UserCheckinRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.checkin(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetUserLastCheckin(resp);
  }

  @override
  Future<bool> deleteAccount(UserDeleteAccountRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.deleteAccount(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }
}
