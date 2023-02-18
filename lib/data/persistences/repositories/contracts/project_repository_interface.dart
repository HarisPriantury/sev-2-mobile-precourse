import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/domain/project.dart';

abstract class ProjectRepository {
  Future<BaseApiResponse> create(CreateProjectRequestInterface request);
  Future<List<Project>> findAll(GetProjectsRequestInterface params);
  Future<List<ProjectColumn>> getColumns(GetProjectColumnsRequestInterface params);
  Future<List<ProjectColumn>> getColumnTicket(GetProjectColumnTicketRequestInterface params);
  Future<List<BaseApiResponse>> moveTicket(MoveTicketRequestInterface request);
  Future<BaseApiResponse> editColumn(EditColumnRequestInterface request);
  Future<BaseApiResponse> reorderColumn(ReorderColumnRequestInterface request);
  Future<BaseApiResponse> createColumn(CreateColumnRequestInterface request);
  Future<BaseApiResponse> setProjectStatus(SetProjectStatusRequestInterface request);
  Future<BaseApiResponse> createMilestone(CreateMilestoneRequestInterface request);
}
