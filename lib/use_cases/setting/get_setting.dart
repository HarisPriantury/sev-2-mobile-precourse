import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/setting_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/setting_repository_interface.dart';
import 'package:mobile_sev2/domain/setting.dart';

class GetSettingUseCase extends UseCase<Setting, GetSettingRequestInterface> {
  SettingRepository _repository;

  GetSettingUseCase(this._repository);

  @override
  Future<Stream<Setting?>> buildUseCaseStream(
      GetSettingRequestInterface? params) async {
    final StreamController<Setting> _controller = StreamController();
    try {
      Setting setting = await _repository.find(params!);
      _controller.add(setting);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
