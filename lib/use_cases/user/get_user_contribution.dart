import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/user_repository_interface.dart';
import 'package:mobile_sev2/domain/contribution.dart';

class GetUserContributionsUseCase extends UseCase<List<Contribution>, GetUserContributionsRequestInterface> {
  UserRepository _repository;

  GetUserContributionsUseCase(
    this._repository,
  );

  @override
  Future<Stream<List<Contribution>?>> buildUseCaseStream(GetUserContributionsRequestInterface? params) async {
    final StreamController<List<Contribution>> _controller = StreamController();
    try {
      List<Contribution> contribution = await _repository.getuserContributions(params!);
      _controller.add(contribution);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
