import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/persistences/http_service.dart';
import 'package:mobile_sev2/data/payload/api/public_space/get_messages_public_space_api_request.dart';
import 'package:mobile_sev2/data/payload/api/public_space/get_public_space_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/public_space_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/public_space_repository_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:http/http.dart' as http;

class PublicSpaceApiRepository implements PublicSpaceRepository {
  PublicSpaceMapper _mapper;

  PublicSpaceApiRepository(
    this._mapper,
  );

  @override
  Future<Room> getPublicSpace(GetPublicSpaceRequestInterface request) async {
    GetPublicSpaceApiRequest apiRequest = request as GetPublicSpaceApiRequest;
    var response;
    response = await http.get(
      HTTPService.getUrl(endpoint: 'api/workspaces/${apiRequest.workspaceId}/public_channel'),
      headers: HTTPService.getHeader(),
    );
    return _mapper.convertGetPublicSpaceApiResponse(jsonDecode(response.body));
  }

  @override
  Future<List<Chat>> findAll(GetMessagesPublicSpaceRequestInterface params) async {
    GetMessagesPublicSpaceApiRequest apiRequest = params as GetMessagesPublicSpaceApiRequest;
    var response;
    response = await http.get(
        HTTPService.getUrl(
          endpoint:
              'api/workspaces/${apiRequest.workspaceId}/public_channel/messages?offset=${apiRequest.offset}&limit=${apiRequest.limit}'),
      headers: HTTPService.getHeader(),
    );
    return _mapper.convertGetPublicSpaceChatsApiResponse(jsonDecode(response.body));
  }
}
