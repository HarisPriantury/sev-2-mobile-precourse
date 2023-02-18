import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/policy_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/policy_repository_interface.dart';
import 'package:mobile_sev2/domain/space.dart';

class GetSpacesUseCase extends UseCase<List<Space>, GetSpacesRequestInterface> {
  PolicyRepository _repository;

  GetSpacesUseCase(this._repository);

  @override
  Future<Stream<List<Space>?>> buildUseCaseStream(GetSpacesRequestInterface? params) async {
    final StreamController<List<Space>> _controller = StreamController();
    try {
      List<Space> spaces = await _repository.getSpaces(params!);
      _controller.add(spaces);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
