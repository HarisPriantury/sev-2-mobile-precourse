import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/flag_repository.dart';
import 'package:mobile_sev2/domain/flag.dart';

class GetFlagsUseCase extends UseCase<List<Flag>, GetFlagsRequestInterface> {
  FlagRepository _repository;

  GetFlagsUseCase(this._repository);

  @override
  Future<Stream<List<Flag>?>> buildUseCaseStream(
      GetFlagsRequestInterface? params) async {
    final StreamController<List<Flag>> _controller = StreamController();
    try {
      List<Flag> flags = await _repository.findAll(params!);
      _controller.add(flags);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
