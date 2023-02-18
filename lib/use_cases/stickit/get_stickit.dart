import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/stickit_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/stickit_repository_interface.dart';
import 'package:mobile_sev2/domain/stickit.dart';

class GetStickitsUseCase
    extends UseCase<List<Stickit>, GetStickitRequestInterface> {
  StickitRepository _repository;

  GetStickitsUseCase(this._repository);
  @override
  Future<Stream<List<Stickit>?>> buildUseCaseStream(
      GetStickitRequestInterface? params) async {
    final StreamController<List<Stickit>> _controller = StreamController();
    try {
      List<Stickit> stickits = await _repository.findAll(params!);
      _controller.add(stickits);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
