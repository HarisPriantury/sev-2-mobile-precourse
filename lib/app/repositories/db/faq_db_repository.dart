import 'package:mobile_sev2/data/payload/contracts/faq_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/faq_repository_interface.dart';
import 'package:mobile_sev2/domain/faq.dart';

class FaqDBRepository implements FaqRepository {
  @override
  Future<List<Faq>> findAll(GetFaqsRequestInterface params) {
    throw UnimplementedError();
  }
}
