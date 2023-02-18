import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/file_request_interface.dart';
import 'package:mobile_sev2/domain/file.dart';

abstract class FileRepository {
  Future<List<File>> findAll(GetFilesRequestInterface params);
  Future<BaseApiResponse> create(CreateFileRequestInterface request);
  Future<bool> prepare(PrepareCreateFileRequestInterface request);
}
