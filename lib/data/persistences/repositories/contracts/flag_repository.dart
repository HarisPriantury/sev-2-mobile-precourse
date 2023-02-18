import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/domain/flag.dart';

abstract class FlagRepository {
  Future<List<Flag>> findAll(GetFlagsRequestInterface param);
  Future<bool> create(CreateFlagRequestInterface param);
  Future<bool> delete(DeleteFlagRequestInterface param);
}