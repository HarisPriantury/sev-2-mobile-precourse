import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/job_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/job/create_job_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/job_repository_interface.dart';
import 'package:mobile_sev2/domain/job.dart';

class JobDBRepository implements JobRepository {
  Box<Job> _box;

  JobDBRepository(this._box);

  @override
  Future<List<Job>> findAll(GetJobsRequestInterface params) {
    var jobs = _box.values.toList();
    return Future.value(jobs);
  }

  @override
  Future<List<Job>> findApplicants(GetApplicantsRequestInterface params) {
    throw UnimplementedError();
  }

  @override
  Future<bool> create(CreateJobRequestInterface request) {
    var params = request as CreateJobDBRequest;
    _box.put(params.job.id, params.job);
    return Future.value(true);
  }
}
