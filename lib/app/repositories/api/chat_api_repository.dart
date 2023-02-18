import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/chat_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/chat_repository_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';

class ChatApiRepository implements ChatRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  ChatMapper _mapper;

  ChatApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Chat>> findAll(GetMessagesRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.getMessages(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetChatsApiResponse(resp);
  }

  @override
  Future<bool> sendMessage(SendMessageRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.sendChats(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }

  @override
  Future<bool> deleteMessage(DeleteMessageRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.deleteMessage(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      print("error deleteMessage: $error");
      rethrow;
    }
    return true;
  }
}
