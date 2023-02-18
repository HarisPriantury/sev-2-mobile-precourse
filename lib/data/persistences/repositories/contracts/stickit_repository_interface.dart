import 'package:mobile_sev2/data/payload/contracts/stickit_request_interface.dart';
import 'package:mobile_sev2/domain/stickit.dart';

abstract class StickitRepository {
  Future<List<Stickit>> findAll(GetStickitRequestInterface params);
}
