import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/job.dart';

class JobMapper {
  late DateUtilInterface _dateUtil;

  JobMapper(this._dateUtil);

  List<Job> convertGetJobsApiResponse(Map<String, dynamic> response) {
    var jobs = List<Job>.empty(growable: true);

    var data = response['result']['data'];
    for (var job in data) {
      jobs.add(
        Job(
          job['phid'],
          job['fields']['name'],
          job['fields']['description'],
          _getStatus(job['fields']['isLead']),
          _dateUtil.fromPattern("dd MMMM y", job['fields']['endDate']),
        ),
      );
    }
    return jobs;
  }

  List<Job> convertGetApplicantsApiResponse(Map<String, dynamic> response) {
    var jobs = List<Job>.empty(growable: true);

    var data = response['result']['data'];
    for (var job in data) {
      jobs.add(
        Job(
          job['phid'],
          job['job_name'],
          "",
          _getStatus(job['is_lead']),
          _dateUtil.fromPattern("dd MMMM y", job['fields']['end_at']),
          totalApplicant: job['total_applicants'],
        ),
      );
    }
    return jobs;
  }

  JobStatus _getStatus(String jobStatus) {
    if (jobStatus == "0") {
      return JobStatus.open;
    } else {
      return JobStatus.expired;
    }
  }
}
