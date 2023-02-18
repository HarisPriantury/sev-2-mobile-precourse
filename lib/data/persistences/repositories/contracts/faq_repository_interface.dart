import 'package:mobile_sev2/data/payload/contracts/faq_request_interface.dart';
import 'package:mobile_sev2/domain/faq.dart';

abstract class FaqRepository {
  Future<List<Faq>> findAll(GetFaqsRequestInterface params);
}
