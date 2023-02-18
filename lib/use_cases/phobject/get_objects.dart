import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/phobject_repository_interface.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class GetObjectsUseCase
    extends UseCase<List<PhObject>, GetObjectsRequestInterface> {
  PhobjectRepository _repository;

  GetObjectsUseCase(this._repository);

  @override
  Future<Stream<List<PhObject>?>> buildUseCaseStream(
      GetObjectsRequestInterface? params) async {
    final StreamController<List<PhObject>> _controller = StreamController();
    try {
      List<PhObject> objects = await _repository.findAll(params!);
      _controller.add(objects);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
