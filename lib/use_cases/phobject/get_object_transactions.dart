import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/phobject_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/phobject_repository_interface.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';

class GetObjectTransactionsUseCase extends UseCase<List<PhTransaction>,
    GetObjectTransactionsRequestInterface> {
  PhobjectRepository _repository;

  GetObjectTransactionsUseCase(this._repository);

  @override
  Future<Stream<List<PhTransaction>?>> buildUseCaseStream(
      GetObjectTransactionsRequestInterface? params) async {
    final StreamController<List<PhTransaction>> _controller =
        StreamController();
    try {
      List<PhTransaction> objects = await _repository.findTransactions(params!);
      _controller.add(objects);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
