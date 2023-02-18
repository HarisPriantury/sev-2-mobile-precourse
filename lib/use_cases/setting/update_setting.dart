import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/setting_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/setting_repository_interface.dart';

class UpdateSettingUseCase
    extends UseCase<bool, UpdateSettingRequestInterface> {
  SettingRepository _repository;

  UpdateSettingUseCase(this._repository);

  @override
  Future<Stream<bool>> buildUseCaseStream(
      UpdateSettingRequestInterface? params) async {
    final StreamController<bool> _controller = StreamController();
    try {
      bool result = await _repository.update(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
