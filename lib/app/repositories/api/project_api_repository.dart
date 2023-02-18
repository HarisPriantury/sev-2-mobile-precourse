import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/project_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/project_repository_interface.dart';
import 'package:mobile_sev2/domain/project.dart';

class ProjectApiRepository implements ProjectRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  ProjectMapper _mapper;

  ProjectApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Project>> findAll(GetProjectsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.projects(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetProjectsApiResponse(resp);
  }

  @override
  Future<BaseApiResponse> create(CreateProjectRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.createOrUpdateProject(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertCreateProjectApiResponse(resp);
  }

  @override
  Future<List<ProjectColumn>> getColumns(GetProjectColumnsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.projectColumns(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetProjectColumnsApiResponse(resp);
  }

  @override
  Future<List<ProjectColumn>> getColumnTicket(GetProjectColumnTicketRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.projectColumnTicket(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetProjectColumnTicketApiResponse(resp);
  }

  @override
  Future<List<BaseApiResponse>> moveTicket(MoveTicketRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.moveTicket(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertMoveTicketResponse(resp);
  }

  @override
  Future<BaseApiResponse> editColumn(EditColumnRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.editColumn(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertEditColumnResponse(resp);
  }

  @override
  Future<BaseApiResponse> reorderColumn(ReorderColumnRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.reorderColumn(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }

    return _mapper.convertReorderColumnResponse(resp);
  }

  @override
  Future<BaseApiResponse> createColumn(CreateColumnRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.createColumn(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }

    return _mapper.convertReorderColumnResponse(resp);
  }

  @override
  Future<BaseApiResponse> setProjectStatus(SetProjectStatusRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.setProjectStatus(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }

    return _mapper.convertSetProjectStatusResponse(resp);
  }

  @override
  Future<BaseApiResponse> createMilestone(CreateMilestoneRequestInterface request) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.createMilestone(),
        request as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }

    return _mapper.convertCreateMilestoneResponse(resp);
  }
}
