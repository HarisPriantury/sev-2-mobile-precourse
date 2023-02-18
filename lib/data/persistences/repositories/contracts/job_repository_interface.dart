import 'package:mobile_sev2/data/payload/contracts/job_request_interface.dart';
import 'package:mobile_sev2/domain/job.dart';

abstract class JobRepository {
  Future<bool> create(CreateJobRequestInterface request);
  Future<List<Job>> findAll(GetJobsRequestInterface params);
  Future<List<Job>> findApplicants(GetApplicantsRequestInterface params);
}
