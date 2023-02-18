import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/job_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/job_repository_interface.dart';
import 'package:mobile_sev2/domain/job.dart';

class GetJobsUseCase extends UseCase<List<Job>, GetJobsRequestInterface> {
  JobRepository _repository;

  GetJobsUseCase(this._repository);

  @override
  Future<Stream<List<Job>?>> buildUseCaseStream(
      GetJobsRequestInterface? params) async {
    final StreamController<List<Job>> _controller = StreamController();
    try {
      List<Job> jobs = await _repository.findAll(params!);
      _controller.add(jobs);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
