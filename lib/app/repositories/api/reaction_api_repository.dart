import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/reaction_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/reaction_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/reaction_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/reaction.dart';

class ReactionApiRepository implements ReactionRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  ReactionMapper _mapper;

  ReactionApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Reaction>> findAll(GetReactionsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.reactions(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetReactionsApiResponse(resp);
  }

  @override
  Future<List<ObjectReactions>> findObjectReactions(GetObjectReactionsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.objectReactions(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetObjectReactionsApiResponse(resp);
  }

  @override
  Future<bool> give(GiveReactionRequestInterface request) async {
    try {
      await _service.invokeHttp(
        _endpoints.giveReactions(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return true;
  }
}
