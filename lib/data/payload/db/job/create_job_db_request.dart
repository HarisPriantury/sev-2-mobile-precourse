import 'package:mobile_sev2/data/payload/contracts/job_request_interface.dart';
import 'package:mobile_sev2/domain/job.dart';

class CreateJobDBRequest implements CreateJobRequestInterface {
  Job job;

  CreateJobDBRequest(this.job);
}
