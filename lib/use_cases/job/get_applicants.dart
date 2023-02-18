import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/job_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/job_repository_interface.dart';
import 'package:mobile_sev2/domain/job.dart';

class GetApplicantsUseCase
    extends UseCase<List<Job>, GetApplicantsRequestInterface> {
  JobRepository _repository;

  GetApplicantsUseCase(this._repository);

  @override
  Future<Stream<List<Job>?>> buildUseCaseStream(
      GetApplicantsRequestInterface? params) async {
    final StreamController<List<Job>> _controller = StreamController();
    try {
      List<Job> jobs = await _repository.findApplicants(params!);
      _controller.add(jobs);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
