import 'package:mobile_sev2/app/infrastructures/endpoints.dart';
import 'package:mobile_sev2/data/infrastructures/api_service_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/api_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/job_request_interface.dart';
import 'package:mobile_sev2/data/persistences/mappers/job_mapper.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/job_repository_interface.dart';
import 'package:mobile_sev2/domain/job.dart';

class JobApiRepository implements JobRepository {
  ApiServiceInterface _service;
  Endpoints _endpoints;
  JobMapper _mapper;

  JobApiRepository(
    this._service,
    this._endpoints,
    this._mapper,
  );

  @override
  Future<List<Job>> findAll(GetJobsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.jobs(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetJobsApiResponse(resp);
  }

  @override
  Future<List<Job>> findApplicants(GetApplicantsRequestInterface params) async {
    dynamic resp;
    try {
      resp = await _service.invokeHttp(
        _endpoints.jobApplicants(),
        params as ApiRequestInterface,
      );
    } catch (error) {
      rethrow;
    }
    return _mapper.convertGetJobsApiResponse(resp);
  }

  @override
  Future<bool> create(CreateJobRequestInterface request) {
    throw UnimplementedError();
  }
}
