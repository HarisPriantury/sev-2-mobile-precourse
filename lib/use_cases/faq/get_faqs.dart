import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/faq_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/faq_repository_interface.dart';
import 'package:mobile_sev2/domain/faq.dart';

class GetFaqsUseCase extends UseCase<List<Faq>, GetFaqsRequestInterface> {
  FaqRepository _repository;

  GetFaqsUseCase(this._repository);

  @override
  Future<Stream<List<Faq>?>> buildUseCaseStream(GetFaqsRequestInterface? params) async {
    final StreamController<List<Faq>> _controller = StreamController();
    try {
      List<Faq> faqs = await _repository.findAll(params!);
      _controller.add(faqs);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
