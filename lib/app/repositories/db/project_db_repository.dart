import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/project_repository_interface.dart';
import 'package:mobile_sev2/domain/project.dart';

class ProjectDBRepository implements ProjectRepository {
  Box<Project> _box;

  ProjectDBRepository(this._box);

  @override
  Future<List<Project>> findAll(GetProjectsRequestInterface params) {
    var projects = _box.values.toList();
    return Future.value(projects);
  }

  // @override
  // Future<bool> create(CreateProjectRequestInterface request) {
  //   var params = request as CreateProjectDBRequest;
  //   _box.put(params.project.id, params.project);
  //   return Future.value(true);
  // }

  @override
  Future<BaseApiResponse> create(CreateProjectRequestInterface request) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<List<ProjectColumn>> getColumns(GetProjectColumnsRequestInterface params) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProjectColumn>> getColumnTicket(GetProjectColumnTicketRequestInterface params) {
    throw UnimplementedError();
  }

  // @override
  // Future<BaseApiResponse> moveTicket(MoveTicketRequestInterface params) {
  //   throw UnimplementedError();
  // }
  @override
  Future<List<BaseApiResponse>> moveTicket(MoveTicketRequestInterface request) {
    // TODO: implement moveTicket
    throw UnimplementedError();
  }

  @override
  Future<BaseApiResponse> editColumn(EditColumnRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<BaseApiResponse> reorderColumn(ReorderColumnRequestInterface request) {
    // TODO: implement reorderColumn
    throw UnimplementedError();
  }

  @override
  Future<BaseApiResponse> createColumn(CreateColumnRequestInterface request) {
    // TODO: implement createColumn
    throw UnimplementedError();
  }

  @override
  Future<BaseApiResponse> setProjectStatus(SetProjectStatusRequestInterface request) {
    // TODO: implement setProjectStatus
    throw UnimplementedError();
  }

  @override
  Future<BaseApiResponse> createMilestone(CreateMilestoneRequestInterface request) {
    // TODO: implement createMilestone
    throw UnimplementedError();
  }
}
